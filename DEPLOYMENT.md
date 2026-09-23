# FarmConnect — Run & Deploy Guide

Spring Boot 3.3 + JSP + MySQL. Three roles: Admin, Farmer, User.

---

## ⚠️ Do this first

The original repository had a live Railway MySQL root password and a Gmail app
password committed in `src/main/resources/application.properties`. Those files
are in your git history, so deleting the lines is **not** enough.

1. Revoke the Gmail app password at <https://myaccount.google.com/apppasswords>
2. Reset the Railway database password in the Railway dashboard
3. Only then use the new credentials as environment variables

Nothing secret lives in the repository any more — `application.properties` now
reads everything from `${ENV_VAR:default}`.

---

## 1. Run it locally

### Option A — Docker (easiest, includes MySQL)

```bash
docker compose up --build
```

Open <http://localhost:9091/home>.

### Option B — Maven against your own MySQL

```bash
# Windows PowerShell
$env:DB_URL="jdbc:mysql://localhost:3306/farmconnect?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
$env:DB_USERNAME="root"
$env:DB_PASSWORD="your_password"
$env:ADMIN_PASSWORD="ChangeMe@123"
./mvnw spring-boot:run
```

```bash
# macOS / Linux
export DB_URL="jdbc:mysql://localhost:3306/farmconnect?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
export DB_USERNAME=root
export DB_PASSWORD=your_password
export ADMIN_PASSWORD='ChangeMe@123'
./mvnw spring-boot:run
```

### Option C — build the WAR and run it

```bash
./mvnw clean package
java -jar target/farmconnect.war
```

The same WAR can also be dropped into a standalone Tomcat 10+ `webapps/` folder.
(Tomcat 9 or below will **not** work — this is a Jakarta EE 10 application.)

---

## 2. First login

On first startup the app creates one admin account from your environment
variables and logs a banner to the console:

```
=================================================================
  Seeded initial admin account
  username: admin
=================================================================
```

Go to `/adminlogin`, sign in, then change the password at
**Profile** in the sidebar.

Farmers register at `/register` and users at `/userregister`. Both start
unapproved — the admin approves them under **Approve Farmers** / **Approve Users**.

---

## 3. Environment variables

| Variable | Required | Default | Notes |
|---|---|---|---|
| `DB_URL` | yes | localhost | Full JDBC URL |
| `DB_USERNAME` | yes | `root` | |
| `DB_PASSWORD` | yes | *(empty)* | |
| `ADMIN_USERNAME` | no | `admin` | Seed admin, first boot only |
| `ADMIN_PASSWORD` | **yes in prod** | `Admin@123` | Change this |
| `ADMIN_EMAIL` | no | `admin@farmconnect.local` | |
| `MAIL_ENABLED` | no | `false` | App runs fine with mail off |
| `MAIL_USERNAME` | if mail on | | Gmail address |
| `MAIL_PASSWORD` | if mail on | | Gmail **app password**, not your login password |
| `PORT` | no | `9091` | Injected by Render/Railway |
| `DDL_AUTO` | no | `update` | Use `validate` once the schema is stable |
| `SHOW_SQL` | no | `false` | |

### About `MAIL_ENABLED`

With mail off, emails are written to the log instead of sent, and every feature
still works. Password-reset codes appear in the console — fine for local testing
and demos, but turn mail on before real users touch it, or nobody can reset a
password.

---

## 4. Deploy to Render

1. Push this repo to GitHub (confirm `.env` is **not** committed).
2. Render → **New +** → **Blueprint** → select the repo. It reads `render.yaml`.
3. Fill in the prompted environment variables (`DB_URL`, `DB_PASSWORD`, `ADMIN_PASSWORD`, …).
4. Deploy. First build takes ~5 minutes.

Health check is `/home`.

### Database

Render's free tier has no MySQL, so keep using Railway (or PlanetScale / Aiven).
In Railway, open your MySQL service → **Variables** → **Connect** and build the URL:

```
jdbc:mysql://<host>:<port>/<database>?useSSL=true&allowPublicKeyRetrieval=true&serverTimezone=UTC
```

Put the username and password in `DB_USERNAME` / `DB_PASSWORD` — **not** inside
the URL the way the old config did.

## 4b. Deploy to Railway instead

Railway detects the `Dockerfile` automatically.

1. **New Project** → **Deploy from GitHub repo**
2. Add a **MySQL** service to the same project
3. In the app service → **Variables**, set `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`,
   `ADMIN_PASSWORD`. Railway sets `PORT` for you.
4. **Settings** → **Generate Domain**

---

## 5. Free-tier cold starts

On a free plan the instance sleeps after inactivity and the first request can
take 40–60 seconds while the JVM boots. That is the platform, not a bug. If
you're demoing this live, load the page a minute beforehand.

Also note `DB_POOL_SIZE` defaults to 5 — free MySQL tiers cap concurrent
connections aggressively, and the default Hikari pool of 10 can exhaust them.

---

## 6. Known limitations

Things deliberately left as-is, so you know where the edges are:

- **No CSRF tokens.** Adding them means editing every form in ~35 JSPs. The real
  fix is to adopt Spring Security properly rather than bolt on a filter.
- **OTP codes are stored in memory.** Fine for one instance; they'd break across
  multiple replicas. Move to the database or Redis if you scale out.
- **`price` and `quantity` are `VARCHAR` columns.** Changing them to `DECIMAL`
  and `INT` is the right call, but `ddl-auto=update` won't alter existing column
  types, so it needs a migration. `Product.getPriceValue()` /
  `getQuantityValue()` parse them safely in the meantime.
- **Payment is simulated.** The card modal collects details and discards them —
  nothing is charged and no card data is stored (which is the safe behaviour).
- **`ddl-auto=update`** is convenient but never drops or narrows columns. For a
  graded submission it's fine; for anything long-lived, switch to Flyway.

---

## 7. Troubleshooting

**JSPs show a blank page or 404**
Check `pom.xml` still says `<packaging>war</packaging>`. With `jar`, the
`src/main/webapp` folder is not packaged at all.

**`Unable to find taglib "c"`**
A JSP is using the old `http://java.sun.com/jsp/jstl/core` URI. It must be
`jakarta.tags.core` on Jakarta EE 10.

**`Communications link failure` on startup**
Wrong `DB_URL`/credentials, or the database host isn't reachable from where the
app runs. Confirm the Railway/PlanetScale instance allows external connections.

**Admin login fails on a brand-new database**
Look for the seed banner in the startup logs. If `admin_table` already had a row,
the seeder skips — reset that row's password or clear the table.

**Everything logs in but pages redirect to login**
Your session isn't sticking. Check that the browser accepts cookies and that any
proxy in front of the app forwards them.
