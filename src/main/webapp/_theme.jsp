<%-- Shared design system for FarmGo. Included at the top of every page's <head>. --%>
<style>
    :root {
        --brand: #2e7d32;
        --brand-dark: #1b5e20;
        --brand-light: #4caf50;
        --accent: #f2a541;
        --ink: #1f2933;
        --muted: #64748b;
        --bg: #f6f8f4;
        --card: #ffffff;
        --border: #e2e8e0;
        --danger: #c62828;
        --radius: 14px;
        --shadow: 0 2px 10px rgba(20, 40, 20, 0.08);
        --shadow-lg: 0 10px 30px rgba(20, 40, 20, 0.14);
    }
    * { box-sizing: border-box; }
    html, body {
        margin: 0; padding: 0;
        font-family: 'Segoe UI', -apple-system, Roboto, Arial, sans-serif;
        background: var(--bg);
        color: var(--ink);
        scroll-behavior: smooth;
    }
    a { color: inherit; }
    img { max-width: 100%; }

    /* ---------- Top nav ---------- */
    .fg-nav {
        background: var(--brand-dark);
        position: sticky; top: 0; z-index: 100;
        box-shadow: 0 2px 8px rgba(0,0,0,.15);
    }
    .fg-nav .bar {
        max-width: 1180px; margin: 0 auto; padding: 0 24px;
        display: flex; align-items: center; justify-content: space-between;
        height: 62px;
    }
    .fg-nav .brand {
        color: #fff; font-size: 1.3rem; font-weight: 700;
        text-decoration: none; display: flex; align-items: center; gap: 8px;
    }
    .fg-nav .brand .leaf { font-size: 1.4rem; }
    .fg-nav .links { display: flex; gap: 4px; align-items: center; flex-wrap: wrap; }
    .fg-nav .links a {
        color: rgba(255,255,255,.85); text-decoration: none; font-size: .95rem;
        padding: 8px 14px; border-radius: 8px; transition: background .2s, color .2s;
        white-space: nowrap;
    }
    .fg-nav .links a:hover { background: rgba(255,255,255,.12); color: #fff; }
    .fg-nav .links a.cta {
        background: var(--accent); color: #1f2933; font-weight: 600;
    }
    .fg-nav .links a.cta:hover { background: #e0952f; }

    /* ---------- Sidebar (dashboards) ---------- */
    .fg-sidebar {
        width: 240px; position: fixed; top: 0; left: 0; height: 100vh;
        background: var(--brand-dark); padding-top: 20px; overflow-y: auto;
        box-shadow: 2px 0 10px rgba(0,0,0,.15);
    }
    .fg-sidebar .brand {
        color: #fff; font-weight: 700; font-size: 1.15rem;
        padding: 0 22px 18px; display: block; text-decoration: none;
        border-bottom: 1px solid rgba(255,255,255,.12); margin-bottom: 10px;
    }
    .fg-sidebar a {
        display: block; color: rgba(255,255,255,.85); text-decoration: none;
        padding: 12px 22px; font-size: .95rem; transition: background .2s, color .2s;
        border-left: 3px solid transparent;
    }
    .fg-sidebar a:hover {
        background: rgba(255,255,255,.08); color: #fff; border-left-color: var(--accent);
    }
    .fg-main { margin-left: 240px; padding: 32px; min-height: 100vh; }
    @media (max-width: 800px) {
        .fg-sidebar { width: 100%; height: auto; position: relative; }
        .fg-main { margin-left: 0; }
    }

    /* ---------- Hero ---------- */
    .fg-hero {
        background: linear-gradient(135deg, var(--brand-dark) 0%, var(--brand) 55%, var(--brand-light) 100%);
        color: #fff; text-align: center; padding: 90px 24px 110px;
        position: relative; overflow: hidden;
    }
    .fg-hero::before {
        content: ''; position: absolute; inset: 0; opacity: .12;
        background-image: radial-gradient(circle at 20% 30%, #fff 0, transparent 45%),
                           radial-gradient(circle at 80% 70%, #fff 0, transparent 40%);
    }
    .fg-hero .inner { position: relative; z-index: 1; max-width: 720px; margin: 0 auto; }
    .fg-hero h1 { font-size: 2.6rem; margin: 0 0 14px; font-weight: 800; letter-spacing: -.5px; }
    .fg-hero p { font-size: 1.15rem; opacity: .92; margin: 0 0 32px; }
    .fg-hero .btn-row { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; }

    /* ---------- Buttons ---------- */
    .btn {
        display: inline-block; padding: 13px 26px; border-radius: 10px;
        border: none; cursor: pointer; font-size: .95rem; font-weight: 600;
        text-decoration: none; background: var(--brand-light); color: #fff;
        transition: transform .15s, box-shadow .15s, background .15s;
    }
    .btn:hover { background: var(--brand); transform: translateY(-2px); box-shadow: var(--shadow-lg); }
    .btn.outline {
        background: rgba(255,255,255,.12); color: #fff; border: 1.5px solid rgba(255,255,255,.6);
    }
    .btn.outline:hover { background: rgba(255,255,255,.2); }
    .btn.accent { background: var(--accent); color: #1f2933; }
    .btn.accent:hover { background: #e0952f; }
    .btn.secondary { background: #eef2ec; color: var(--ink); }
    .btn.secondary:hover { background: #e2e8de; }
    .btn.danger { background: var(--danger); }
    .btn.block { display: block; width: 100%; text-align: center; }

    /* ---------- Cards / sections ---------- */
    .fg-section { max-width: 1180px; margin: 0 auto; padding: 56px 24px; }
    .fg-section h2 { text-align: center; font-size: 1.9rem; margin-bottom: 8px; }
    .fg-section .lead { text-align: center; color: var(--muted); margin-bottom: 40px; }
    .fg-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 22px; }
    .fg-card {
        background: var(--card); border: 1px solid var(--border); border-radius: var(--radius);
        padding: 28px 24px; text-align: center; box-shadow: var(--shadow);
        transition: transform .2s, box-shadow .2s; text-decoration: none; color: var(--ink);
        display: block; cursor: pointer;
    }
    .fg-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); }
    .fg-card .icon {
        width: 56px; height: 56px; border-radius: 50%; margin: 0 auto 16px;
        display: flex; align-items: center; justify-content: center;
        background: #eaf4ea; font-size: 1.6rem;
    }
    .fg-card h3 { margin: 0 0 8px; font-size: 1.15rem; }
    .fg-card p { margin: 0; color: var(--muted); font-size: .92rem; line-height: 1.5; }

    /* ---------- Auth forms ---------- */
    .fg-auth-wrap {
        min-height: calc(100vh - 62px); display: flex; align-items: center;
        justify-content: center; padding: 40px 20px;
        background: linear-gradient(160deg, var(--bg) 0%, #e7efe4 100%);
    }
    .fg-auth-card {
        background: var(--card); border-radius: var(--radius); box-shadow: var(--shadow-lg);
        padding: 40px 38px; max-width: 440px; width: 100%; border: 1px solid var(--border);
    }
    .fg-auth-card .icon-badge {
        width: 56px; height: 56px; border-radius: 50%; background: #eaf4ea;
        display: flex; align-items: center; justify-content: center; font-size: 1.6rem;
        margin: 0 auto 16px;
    }
    .fg-auth-card h2 { text-align: center; margin: 0 0 6px; font-size: 1.5rem; }
    .fg-auth-card .sub { text-align: center; color: var(--muted); font-size: .9rem; margin-bottom: 26px; }
    .fg-field { margin-bottom: 18px; }
    .fg-field label { display: block; font-size: .88rem; font-weight: 600; margin-bottom: 6px; color: var(--ink); }
    .fg-field input, .fg-field select, .fg-field textarea {
        width: 100%; padding: 12px 14px; border: 1.5px solid var(--border); border-radius: 9px;
        font-size: .95rem; font-family: inherit; transition: border-color .15s;
        background: #fbfcfa;
    }
    .fg-field input:focus, .fg-field select:focus, .fg-field textarea:focus {
        outline: none; border-color: var(--brand-light); background: #fff;
    }
    .fg-foot-link { text-align: center; margin-top: 18px; font-size: .9rem; color: var(--muted); }
    .fg-foot-link a { color: var(--brand); font-weight: 600; text-decoration: none; }

    /* ---------- Alerts ---------- */
    .fg-alert {
        padding: 13px 16px; border-radius: 9px; margin-bottom: 18px; font-size: .9rem;
        border: 1px solid transparent;
    }
    .fg-alert.ok { background: #e8f5e9; color: #1b5e20; border-color: #c8e6c9; }
    .fg-alert.err { background: #fdecea; color: #b71c1c; border-color: #f9c9c5; }

    /* ---------- Stat tiles (dashboards) ---------- */
    .fg-stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 18px; margin-bottom: 32px; }
    .fg-stat {
        background: var(--card); border: 1px solid var(--border); border-radius: var(--radius);
        padding: 22px; box-shadow: var(--shadow);
    }
    .fg-stat .label { font-size: .78rem; text-transform: uppercase; letter-spacing: .05em; color: var(--muted); }
    .fg-stat .value { font-size: 2rem; font-weight: 800; color: var(--brand); margin-top: 6px; }

    /* ---------- Footer ---------- */
    .fg-footer {
        background: var(--brand-dark); color: rgba(255,255,255,.75);
        text-align: center; padding: 26px; font-size: .85rem; margin-top: 40px;
    }
</style>
