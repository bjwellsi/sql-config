# SQL Scripts and Connection Profiles

This directory contains shared SQL scripts, per-database tools, and connection profiles for local and remote MSSQL/PostgreSQL instances. It's designed to support a Neovim-based SQL development workflow using `sqlcmd`, `psql`, and shell-based execution.

---

## 📁 Folder Structure

```
~/.config/sql/
├── connections/              # .env-style connection profiles (DB-agnostic)
│   ├── work-mssql.env
│   ├── prod-pg.env
│   └── ...
├── scripts/                  # SQL scripts, grouped by dialect
│   ├── mssql/
│   │   ├── global/           # Reusable across any MSSQL project
│   │   └── mycompany/        # Org-specific MSSQL scripts
│   └── postgres/
│       ├── global/
│       └── internaltools/
```

---

## 🔌 Connection Profiles

All connection profiles are stored in `connections/` as `.env` files. Each file should contain the following format:

```
DB_TYPE=mssql
DB_HOST=10.0.10.2
DB_PORT=1433
DB_USER=yourusername
DB_PASS=yourpassword
DB_NAME=yourdb
```

These are consumed by Neovim commands like `:msConnect` or `:pgConnect` to build CLI commands dynamically.

---

## 📜 Script Usage

- Global scripts are reusable queries, utility views, or diagnostic queries.
- Org-specific scripts live in dialect/env folders (e.g., `scripts/mssql/mycompany/`) and are tailored to schema or business logic.
- Scripts are executed manually or via Neovim aliases like:
  - `:msRun` → run MSSQL `.sql` file via `sqlcmd`
  - `:pgRun` → run PostgreSQL `.sql` file via `psql`
  - `:msShell`, `:pgShell` → open a connected terminal session

---

## 🧠 Best Practices

- Keep project-specific scratch SQL in the relevant `~/Projects/YourApp/sql/` directory.
- Use this config for shared logic, utility queries, and reusable tooling.
- Avoid storing sensitive credentials in version-controlled `.env` files.

---

## 🔐 Security Note

Avoid checking in `.env` files with passwords unless they are encrypted or managed separately. Use a `.gitignore` if this directory is version-controlled:

```
/connections/*.env
```
