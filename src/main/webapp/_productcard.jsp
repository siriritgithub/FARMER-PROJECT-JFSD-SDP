<%-- Shared product-card styling. Every product listing page (farmer/admin/user)
     includes this once, then loops products through the .pc-card markup below. --%>
<style>
    .pc-toolbar {
        display: flex; gap: 12px; align-items: center; margin-bottom: 22px; flex-wrap: wrap;
    }
    .pc-toolbar input[type=text] {
        flex: 1; min-width: 220px; padding: 12px 16px; border: 1.5px solid var(--border);
        border-radius: 10px; font-size: .95rem; background: #fff;
    }
    .pc-toolbar select {
        padding: 12px 14px; border: 1.5px solid var(--border); border-radius: 10px;
        font-size: .9rem; background: #fff;
    }
    .pc-grid {
        display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 22px;
    }
    .pc-card {
        background: var(--card); border: 1px solid var(--border); border-radius: var(--radius);
        overflow: hidden; box-shadow: var(--shadow); display: flex; flex-direction: column;
    }
    .pc-image {
        width: 100%; height: 170px; object-fit: cover; background: #eef2ec;
    }
    .pc-image.placeholder {
        display: flex; align-items: center; justify-content: center; font-size: 2.4rem;
    }
    .pc-body { padding: 18px 20px; flex: 1; display: flex; flex-direction: column; }
    .pc-top { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; }
    .pc-name { font-size: 1.15rem; font-weight: 700; margin: 0; color: var(--ink); }
    .pc-tagline { color: var(--muted); font-size: .85rem; margin: 4px 0 12px; }
    .pc-badge {
        font-size: .72rem; font-weight: 700; padding: 4px 10px; border-radius: 999px;
        white-space: nowrap;
    }
    .pc-badge.in-stock { background: #e8f5e9; color: #1b5e20; }
    .pc-badge.out-stock { background: #fdecea; color: #b71c1c; }
    .pc-badge.pending { background: #fff3e0; color: #e65100; }
    .pc-meta { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 14px; margin-bottom: 16px; }
    .pc-meta-item { font-size: .85rem; }
    .pc-meta-item .k { color: var(--muted); display: block; font-size: .72rem;
                        text-transform: uppercase; letter-spacing: .03em; }
    .pc-meta-item .v { font-weight: 600; color: var(--ink); }
    .pc-actions { display: flex; gap: 8px; margin-top: auto; flex-wrap: wrap; }
    .pc-actions form { flex: 1; margin: 0; }
    .pc-btn {
        flex: 1; padding: 9px 10px; border-radius: 8px; border: 1.5px solid var(--border);
        background: #fff; color: var(--ink); font-size: .82rem; font-weight: 600;
        cursor: pointer; text-align: center; text-decoration: none; display: inline-block;
        width: 100%;
    }
    .pc-btn.primary { background: var(--brand-light); color: #fff; border-color: var(--brand-light); }
    .pc-btn.primary:hover { background: var(--brand); }
    .pc-btn.danger { color: var(--danger); border-color: #f3c6c2; }
    .pc-btn.danger:hover { background: #fdecea; }
    .pc-btn.wish { border-color: var(--accent); color: #b5730f; }
    .pc-btn.wish:hover { background: #fff6ea; }
    .pc-empty { text-align: center; padding: 60px 20px; color: var(--muted); }
    .pc-empty .icon { font-size: 2.6rem; margin-bottom: 10px; }
</style>
<script>
    // Client-side search/filter shared by every product-card page. Each page
    // gives its cards a data-search attribute containing the searchable text;
    // typing in #pc-search hides cards that don't match.
    function pcFilter() {
        var q = (document.getElementById('pc-search').value || '').toLowerCase().trim();
        var cards = document.querySelectorAll('.pc-card');
        var visible = 0;
        cards.forEach(function (card) {
            var haystack = (card.getAttribute('data-search') || '').toLowerCase();
            var show = haystack.indexOf(q) !== -1;
            card.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        var emptyEl = document.getElementById('pc-no-results');
        if (emptyEl) {
            emptyEl.style.display = (visible === 0 && cards.length > 0) ? 'block' : 'none';
        }
    }
</script>
