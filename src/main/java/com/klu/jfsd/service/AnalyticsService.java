package com.klu.jfsd.service;

import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Order;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.repository.FarmerRepository;
import com.klu.jfsd.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Everything here is computed from real rows in the orders/products tables -
 * nothing on these pages is a hardcoded example number. Where a farmer,
 * product or order simply doesn't have enough history yet, the numbers are
 * genuinely zero or the section is empty, rather than backfilled with
 * plausible-looking placeholder data.
 */
@Service
public class AnalyticsService {

    private final OrderService orderService;
    private final ProductService productService;
    private final FarmerRepository farmerRepository;
    private final UserRepository userRepository;

    public AnalyticsService(OrderService orderService,
                            ProductService productService,
                            FarmerRepository farmerRepository,
                            UserRepository userRepository) {
        this.orderService = orderService;
        this.productService = productService;
        this.farmerRepository = farmerRepository;
        this.userRepository = userRepository;
    }

    // =====================================================================
    // Shared small DTOs
    // =====================================================================

    public static class NamedStat {
        public final String label;
        public final int quantity;
        public final BigDecimal revenue;

        public NamedStat(String label, int quantity, BigDecimal revenue) {
            this.label = label;
            this.quantity = quantity;
            this.revenue = revenue;
        }

        public String getLabel() { return label; }
        public int getQuantity() { return quantity; }
        public BigDecimal getRevenue() { return revenue; }
    }

    public static class SharePoint {
        public final String label;
        public final int count;
        public final double percent;

        public SharePoint(String label, int count, double percent) {
            this.label = label;
            this.count = count;
            this.percent = percent;
        }

        public String getLabel() { return label; }
        public int getCount() { return count; }
        public double getPercent() { return percent; }
    }

    public static class MonthPoint {
        public final String month;
        public final BigDecimal amount;

        public MonthPoint(String month, BigDecimal amount) {
            this.month = month;
            this.amount = amount;
        }

        public String getMonth() { return month; }
        public BigDecimal getAmount() { return amount; }
    }

    // =====================================================================
    // Farmer analytics
    // =====================================================================

    public static class FarmerAnalytics {
        public int totalProducts;
        public int totalOrders;
        public int totalQuantitySold;
        public BigDecimal totalRevenue = BigDecimal.ZERO;
        public String bestSellingProduct = "-";
        public String lowestSellingProduct = "-";
        public BigDecimal averagePrice = BigDecimal.ZERO;
        public List<SharePoint> salesByLocation = new ArrayList<>();
        public List<NamedStat> productPerformance = new ArrayList<>();
        public List<SharePoint> sellingTimeOfDay = new ArrayList<>();
        public String peakSellingWindow = "Not enough data yet";
        public List<MonthPoint> monthlyRevenue = new ArrayList<>();
        public List<NamedStat> inventory = new ArrayList<>();
        public List<String> lowStockAlerts = new ArrayList<>();

        // Getters so JSP EL (${analytics.totalProducts} etc.) can read every field.
        public int getTotalProducts() { return totalProducts; }
        public int getTotalOrders() { return totalOrders; }
        public int getTotalQuantitySold() { return totalQuantitySold; }
        public BigDecimal getTotalRevenue() { return totalRevenue; }
        public String getBestSellingProduct() { return bestSellingProduct; }
        public String getLowestSellingProduct() { return lowestSellingProduct; }
        public BigDecimal getAveragePrice() { return averagePrice; }
        public List<SharePoint> getSalesByLocation() { return salesByLocation; }
        public List<NamedStat> getProductPerformance() { return productPerformance; }
        public List<SharePoint> getSellingTimeOfDay() { return sellingTimeOfDay; }
        public String getPeakSellingWindow() { return peakSellingWindow; }
        public List<MonthPoint> getMonthlyRevenue() { return monthlyRevenue; }
        public List<NamedStat> getInventory() { return inventory; }
        public List<String> getLowStockAlerts() { return lowStockAlerts; }
    }

    public FarmerAnalytics getFarmerAnalytics(int farmerId) {
        FarmerAnalytics a = new FarmerAnalytics();

        List<Product> products = productService.getProductsByFarmerId(farmerId);
        a.totalProducts = products.size();

        List<Order> orders = orderService.getOrdersByFarmerId(farmerId);
        a.totalOrders = orders.size();

        if (orders.isEmpty()) {
            // No sales yet - inventory can still be shown from listed products.
            a.inventory = products.stream()
                    .map(p -> new NamedStat(p.getName(), p.getQuantityValue(), BigDecimal.ZERO))
                    .collect(Collectors.toList());
            return a;
        }

        a.totalQuantitySold = orders.stream().mapToInt(Order::getQuantity).sum();
        a.totalRevenue = orders.stream()
                .map(Order::getTotalAmount).filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // ---- Product performance (qty sold + revenue per product name) ----
        Map<String, int[]> qtyByProduct = new LinkedHashMap<>();     // name -> [qty]
        Map<String, BigDecimal> revenueByProduct = new HashMap<>();
        for (Order o : orders) {
            String name = o.getProductName() == null ? "Unknown" : o.getProductName();
            qtyByProduct.merge(name, new int[]{o.getQuantity()}, (a1, b1) -> new int[]{a1[0] + b1[0]});
            revenueByProduct.merge(name,
                    o.getTotalAmount() == null ? BigDecimal.ZERO : o.getTotalAmount(),
                    BigDecimal::add);
        }
        a.productPerformance = qtyByProduct.entrySet().stream()
                .map(e -> new NamedStat(e.getKey(), e.getValue()[0],
                        revenueByProduct.getOrDefault(e.getKey(), BigDecimal.ZERO)))
                .sorted((x, y) -> Integer.compare(y.getQuantity(), x.getQuantity()))
                .collect(Collectors.toList());

        if (!a.productPerformance.isEmpty()) {
            a.bestSellingProduct = a.productPerformance.get(0).getLabel();
            a.lowestSellingProduct = a.productPerformance.get(a.productPerformance.size() - 1).getLabel();
        }

        a.averagePrice = orders.stream()
                .map(Order::getPrice).filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .divide(BigDecimal.valueOf(orders.size()), 2, RoundingMode.HALF_UP);

        // ---- Sales by location (via the product each order pointed to) ----
        Map<String, Integer> locationCounts = new LinkedHashMap<>();
        for (Order o : orders) {
            Product p = productService.getProductById(o.getProductId());
            String loc = (p != null && p.getLocation() != null && !p.getLocation().isBlank())
                    ? p.getLocation() : "Unknown";
            locationCounts.merge(loc, o.getQuantity(), Integer::sum);
        }
        a.salesByLocation = toSharePoints(locationCounts);

        // ---- Peak selling time of day ----
        Map<String, Integer> timeBuckets = new LinkedHashMap<>();
        timeBuckets.put("Early Morning (12am-6am)", 0);
        timeBuckets.put("Morning (6am-12pm)", 0);
        timeBuckets.put("Afternoon (12pm-5pm)", 0);
        timeBuckets.put("Evening (5pm-9pm)", 0);
        timeBuckets.put("Night (9pm-12am)", 0);
        for (Order o : orders) {
            LocalDateTime dt = o.getOrderDate();
            if (dt == null) continue;
            int hour = dt.getHour();
            String bucket = hour < 6 ? "Early Morning (12am-6am)"
                    : hour < 12 ? "Morning (6am-12pm)"
                    : hour < 17 ? "Afternoon (12pm-5pm)"
                    : hour < 21 ? "Evening (5pm-9pm)"
                    : "Night (9pm-12am)";
            timeBuckets.merge(bucket, 1, Integer::sum);
        }
        a.sellingTimeOfDay = toSharePoints(timeBuckets);
        a.peakSellingWindow = timeBuckets.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .filter(e -> e.getValue() > 0)
                .map(Map.Entry::getKey)
                .orElse("Not enough data yet");

        // ---- Monthly revenue trend ----
        DateTimeFormatter monthFmt = DateTimeFormatter.ofPattern("yyyy-MM");
        Map<String, BigDecimal> monthly = new TreeMap<>();
        for (Order o : orders) {
            if (o.getOrderDate() == null) continue;
            String key = o.getOrderDate().format(monthFmt);
            monthly.merge(key, o.getTotalAmount() == null ? BigDecimal.ZERO : o.getTotalAmount(), BigDecimal::add);
        }
        a.monthlyRevenue = monthly.entrySet().stream()
                .map(e -> new MonthPoint(e.getKey(), e.getValue()))
                .collect(Collectors.toList());

        // ---- Inventory: listed vs remaining, using live product data ----
        for (Product p : products) {
            int soldForThisProduct = qtyByProduct.getOrDefault(p.getName(), new int[]{0})[0];
            a.inventory.add(new NamedStat(p.getName(), p.getQuantityValue(), BigDecimal.ZERO));
            if (p.getQuantityValue() > 0 && p.getQuantityValue() <= 10) {
                a.lowStockAlerts.add(p.getName() + " is running low (" + p.getDisplayQuantity() + " left)");
            } else if (p.getQuantityValue() == 0) {
                a.lowStockAlerts.add(p.getName() + " is out of stock");
            }
        }

        return a;
    }

    // =====================================================================
    // User (buyer) analytics
    // =====================================================================

    public static class UserAnalytics {
        public int totalOrders;
        public BigDecimal totalSpent = BigDecimal.ZERO;
        public BigDecimal averageOrderValue = BigDecimal.ZERO;
        public List<NamedStat> topProducts = new ArrayList<>();
        public List<SharePoint> spendingByCategory = new ArrayList<>();
        public List<MonthPoint> monthlySpend = new ArrayList<>();
        public String favoriteFarmerName = "-";
        public int favoriteFarmerOrders;

        public int getTotalOrders() { return totalOrders; }
        public BigDecimal getTotalSpent() { return totalSpent; }
        public BigDecimal getAverageOrderValue() { return averageOrderValue; }
        public List<NamedStat> getTopProducts() { return topProducts; }
        public List<SharePoint> getSpendingByCategory() { return spendingByCategory; }
        public List<MonthPoint> getMonthlySpend() { return monthlySpend; }
        public String getFavoriteFarmerName() { return favoriteFarmerName; }
        public int getFavoriteFarmerOrders() { return favoriteFarmerOrders; }
    }

    public UserAnalytics getUserAnalytics(int userId) {
        UserAnalytics a = new UserAnalytics();
        List<Order> orders = orderService.getOrdersByUserId(userId);
        a.totalOrders = orders.size();
        if (orders.isEmpty()) {
            return a;
        }

        a.totalSpent = orders.stream()
                .map(Order::getTotalAmount).filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        a.averageOrderValue = a.totalSpent.divide(BigDecimal.valueOf(orders.size()), 2, RoundingMode.HALF_UP);

        // ---- Top purchased products ----
        Map<String, Integer> qtyByProduct = new LinkedHashMap<>();
        for (Order o : orders) {
            qtyByProduct.merge(o.getProductName() == null ? "Unknown" : o.getProductName(),
                    o.getQuantity(), Integer::sum);
        }
        a.topProducts = qtyByProduct.entrySet().stream()
                .sorted((x, y) -> Integer.compare(y.getValue(), x.getValue()))
                .limit(5)
                .map(e -> new NamedStat(e.getKey(), e.getValue(), BigDecimal.ZERO))
                .collect(Collectors.toList());

        // ---- Spending by category + favorite farmer (via product lookup) ----
        Map<String, BigDecimal> spendByCategory = new LinkedHashMap<>();
        Map<Integer, Integer> ordersByFarmer = new HashMap<>();
        Map<Integer, BigDecimal> spendByFarmer = new HashMap<>();
        for (Order o : orders) {
            Product p = productService.getProductById(o.getProductId());
            BigDecimal amount = o.getTotalAmount() == null ? BigDecimal.ZERO : o.getTotalAmount();
            String category = (p != null && p.getSpecification() != null) ? p.getSpecification() : "Other";
            spendByCategory.merge(category, amount, BigDecimal::add);

            Integer farmerId = p != null ? p.getFarmerId() : null;
            if (farmerId != null) {
                ordersByFarmer.merge(farmerId, 1, Integer::sum);
                spendByFarmer.merge(farmerId, amount, BigDecimal::add);
            }
        }
        int totalSpendCount = spendByCategory.values().size();
        double totalCatAmount = spendByCategory.values().stream().mapToDouble(BigDecimal::doubleValue).sum();
        for (Map.Entry<String, BigDecimal> e : spendByCategory.entrySet()) {
            double pct = totalCatAmount == 0 ? 0 : (e.getValue().doubleValue() / totalCatAmount) * 100.0;
            a.spendingByCategory.add(new SharePoint(e.getKey(),
                    e.getValue().setScale(0, RoundingMode.HALF_UP).intValue(), round1(pct)));
        }

        ordersByFarmer.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .ifPresent(entry -> {
                    Farmer f = farmerRepository.findById(entry.getKey()).orElse(null);
                    a.favoriteFarmerName = f != null ? f.getName() : "Farmer #" + entry.getKey();
                    a.favoriteFarmerOrders = entry.getValue();
                });

        // ---- Monthly spend trend ----
        DateTimeFormatter monthFmt = DateTimeFormatter.ofPattern("yyyy-MM");
        Map<String, BigDecimal> monthly = new TreeMap<>();
        for (Order o : orders) {
            if (o.getOrderDate() == null) continue;
            String key = o.getOrderDate().format(monthFmt);
            monthly.merge(key, o.getTotalAmount() == null ? BigDecimal.ZERO : o.getTotalAmount(), BigDecimal::add);
        }
        a.monthlySpend = monthly.entrySet().stream()
                .map(e -> new MonthPoint(e.getKey(), e.getValue()))
                .collect(Collectors.toList());

        return a;
    }

    // =====================================================================
    // Platform (admin) analytics - extends what adminviewanalytics.jsp shows
    // =====================================================================

    public static class PlatformAnalytics {
        public List<NamedStat> topProductsByRevenue = new ArrayList<>();
        public List<SharePoint> farmersByState = new ArrayList<>();
        public List<SharePoint> usersByState = new ArrayList<>();

        public List<NamedStat> getTopProductsByRevenue() { return topProductsByRevenue; }
        public List<SharePoint> getFarmersByState() { return farmersByState; }
        public List<SharePoint> getUsersByState() { return usersByState; }
    }

    public PlatformAnalytics getPlatformAnalytics() {
        PlatformAnalytics a = new PlatformAnalytics();

        List<Order> allOrders = orderService.getAllOrders();
        Map<String, int[]> qtyByProduct = new LinkedHashMap<>();
        Map<String, BigDecimal> revenueByProduct = new HashMap<>();
        for (Order o : allOrders) {
            String name = o.getProductName() == null ? "Unknown" : o.getProductName();
            qtyByProduct.merge(name, new int[]{o.getQuantity()}, (x, y) -> new int[]{x[0] + y[0]});
            revenueByProduct.merge(name,
                    o.getTotalAmount() == null ? BigDecimal.ZERO : o.getTotalAmount(), BigDecimal::add);
        }
        a.topProductsByRevenue = revenueByProduct.entrySet().stream()
                .sorted((x, y) -> y.getValue().compareTo(x.getValue()))
                .limit(8)
                .map(e -> new NamedStat(e.getKey(), qtyByProduct.getOrDefault(e.getKey(), new int[]{0})[0], e.getValue()))
                .collect(Collectors.toList());

        Map<String, Integer> farmerStateCounts = new LinkedHashMap<>();
        farmerRepository.findAll().forEach(f -> {
            String state = (f.getState() == null || f.getState().isBlank()) ? "Unknown" : f.getState();
            farmerStateCounts.merge(state, 1, Integer::sum);
        });
        a.farmersByState = toSharePoints(farmerStateCounts);

        Map<String, Integer> userStateCounts = new LinkedHashMap<>();
        userRepository.findAll().forEach(u -> {
            String state = (u.getState() == null || u.getState().isBlank()) ? "Unknown" : u.getState();
            userStateCounts.merge(state, 1, Integer::sum);
        });
        a.usersByState = toSharePoints(userStateCounts);

        return a;
    }

    // =====================================================================
    // Helpers
    // =====================================================================

    private List<SharePoint> toSharePoints(Map<String, Integer> counts) {
        int total = counts.values().stream().mapToInt(Integer::intValue).sum();
        return counts.entrySet().stream()
                .filter(e -> e.getValue() > 0)
                .sorted((x, y) -> Integer.compare(y.getValue(), x.getValue()))
                .map(e -> new SharePoint(e.getKey(), e.getValue(),
                        total == 0 ? 0 : round1((e.getValue() * 100.0) / total)))
                .collect(Collectors.toList());
    }

    private double round1(double value) {
        return Math.round(value * 10.0) / 10.0;
    }
}
