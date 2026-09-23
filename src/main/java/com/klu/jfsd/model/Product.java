package com.klu.jfsd.model;

import jakarta.persistence.*;

@Entity
@Table(name = "product_table")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id", nullable = false, unique = true)
    private int id;

    @Column(name = "product_name", nullable = false)
    private String name;

    @Column(name = "product_specification", nullable = false)
    private String specification;

    @Column(name = "product_type", nullable = false)
    private String type;

    @Column(name = "product_price")
    private String price;

    @Column(name = "product_quantity")
    private String quantity = "0"; // Default value

    // Added so quantity and price can be shown as "50 kg" / "Rs. 20/kg"
    // instead of a bare number. Defaults to "kg" for older rows saved before
    // this column existed.
    @Column(name = "unit")
    private String unit = "kg";

    @Column(name = "producer_location")
    private String location;

    @Column(name = "producer_state")
    private String state; // Default value will be null if not provided

    // LONGTEXT, not the default VARCHAR(255): an uploaded image is stored as a
    // base64 data URI here, which is far longer than 255 characters and would
    // otherwise be silently truncated by MySQL on save.
    @Column(name = "product_image", columnDefinition = "LONGTEXT")
    private String image;

    @Column(name = "image2", columnDefinition = "LONGTEXT")
    private String image2;

    @Column(name = "request")
    private Integer request = 1; // Default value

    @Column(name = "producer_contact", nullable = false)
    private String contact;

    @Column(name = "product_Date", nullable = false)
    private String date;

    // The old @ManyToOne Farmer mapping was removed: it was never populated
    // anywhere in the codebase, so product.farmer was always null in the JSPs
    // while creating a redundant farmer_id foreign key column. The farmerId
    // field below is the one the whole application actually uses.

    @Column(name = "product_farmer_id", nullable = false)
    private Integer farmerId = -1;

    @Column(name = "p_description", nullable = true)
    private String description;

    // Getters and setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return (unit == null || unit.isBlank()) ? "kg" : unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getImage2() {
        return image2;
    }

    public void setImage2(String image2) {
        this.image2 = image2;
    }

    public Integer getRequest() {
        return request;
    }

    public void setRequest(Integer request) {
        this.request = request;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public Integer getFarmerId() {
        return farmerId;
    }

    public void setFarmerId(Integer farmerId) {
        this.farmerId = farmerId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // ---------------------------------------------------------------------
    // price and quantity are stored as String in this schema. These helpers
    // parse them safely so ordering, totals and stock checks cannot blow up
    // on an empty or malformed value.
    // ---------------------------------------------------------------------

    @Transient
    public java.math.BigDecimal getPriceValue() {
        if (price == null) {
            return java.math.BigDecimal.ZERO;
        }
        try {
            return new java.math.BigDecimal(price.replaceAll("[^0-9.]", "").trim());
        } catch (Exception e) {
            return java.math.BigDecimal.ZERO;
        }
    }

    @Transient
    public int getQuantityValue() {
        if (quantity == null) {
            return 0;
        }
        try {
            return Integer.parseInt(quantity.replaceAll("[^0-9]", "").trim());
        } catch (Exception e) {
            return 0;
        }
    }

    @Transient
    public boolean isInStock() {
        return getQuantityValue() > 0;
    }

    /** e.g. "Rs. 50/kg" - used everywhere the price is shown to a buyer. */
    @Transient
    public String getDisplayPrice() {
        return "Rs. " + (price == null || price.isBlank() ? "0" : price) + "/" + getUnit();
    }

    /** e.g. "100 kg" - used everywhere remaining stock is shown. */
    @Transient
    public String getDisplayQuantity() {
        return (quantity == null || quantity.isBlank() ? "0" : quantity) + " " + getUnit();
    }

    @Override
    public String toString() {
        return "Product[id=" + id + ", name=" + name + ", price=" + price
                + ", qty=" + quantity + ", farmerId=" + farmerId + "]";
    }
}
