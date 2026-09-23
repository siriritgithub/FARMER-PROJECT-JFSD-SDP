<%-- Shared look and feel for the pages added or rebuilt during the fix pass. --%>
<style>
    :root {
        --green: #2e7d32;
        --green-light: #4CAF50;
        --ink: #1f2933;
        --muted: #6b7280;
        --bg: #f4f6f4;
        --card: #ffffff;
        --border: #e3e8e3;
        --danger: #c62828;
    }
    * { box-sizing: border-box; }
    body {
        font-family: -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
        background: var(--bg);
        color: var(--ink);
        margin: 0;
        padding: 0;
    }
    .page { max-width: 1040px; margin: 32px auto; padding: 0 20px; }
    .card {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 28px;
        box-shadow: 0 1px 3px rgba(0,0,0,.06);
    }
    h1, h2 { margin-top: 0; color: var(--green); }
    table { width: 100%; border-collapse: collapse; margin-top: 16px; }
    th, td { padding: 12px 14px; text-align: left; border-bottom: 1px solid var(--border); }
    th { background: #f0f4f0; font-size: 13px; text-transform: uppercase;
         letter-spacing: .04em; color: var(--muted); }
    tr:last-child td { border-bottom: none; }
    .btn {
        display: inline-block; padding: 11px 20px; border-radius: 8px;
        border: none; cursor: pointer; font-size: 15px; text-decoration: none;
        background: var(--green-light); color: #fff;
    }
    .btn:hover { background: var(--green); }
    .btn.secondary { background: #e8ece8; color: var(--ink); }
    .btn.danger { background: var(--danger); }
    .alert { padding: 13px 16px; border-radius: 8px; margin-bottom: 18px; font-size: 15px; }
    .alert.ok   { background: #e8f5e9; color: #1b5e20; border: 1px solid #c8e6c9; }
    .alert.err  { background: #ffebee; color: #b71c1c; border: 1px solid #ffcdd2; }
    .empty { padding: 40px; text-align: center; color: var(--muted); }
    .badge { padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
    .badge.open { background: #fff3e0; color: #e65100; }
    .badge.done { background: #e8f5e9; color: #1b5e20; }
    label { display: block; margin: 14px 0 6px; font-weight: 600; font-size: 14px; }
    input[type=text], input[type=email], input[type=password], textarea {
        width: 100%; padding: 11px 13px; border: 1px solid var(--border);
        border-radius: 8px; font-size: 15px; font-family: inherit;
    }
</style>
