# 📚 Book Management System (MySQL)

A relational database project for managing a library's books, authors, categories, members, and borrowing activity. Built with **MySQL 8.0+** and designed to demonstrate practical SQL skills including database design, relationships, constraints, joins, aggregate queries, views, stored procedures, and triggers.

## ✨ Features

- Manage books, authors, publishers, and categories.
- Maintain library member records.
- Track book inventory and available copies.
- Issue books to members and record due dates.
- Process book returns and update inventory automatically.
- Identify currently issued and overdue books.
- Generate inventory and borrowing reports.
- Enforce data integrity with primary keys, foreign keys, unique constraints, and checks.

## 🧰 Tech Stack

- **Database:** MySQL 8.0+
- **Language:** SQL
- **Recommended client:** MySQL Workbench or MySQL command-line client

## 📁 Project Structure

```text
book-management-system/
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_schema.sql
│   ├── 03_seed_data.sql
│   ├── 04_views.sql
│   ├── 05_triggers.sql
│   ├── 06_stored_procedures.sql
│   └── 07_sample_queries.sql
├── docs/
│   └── DATABASE_DESIGN.md
├── .gitignore
└── README.md
```

## 🚀 Getting Started

### Requirements

- MySQL Server 8.0 or newer
- MySQL Workbench (optional, recommended for visual query execution)

### 1. Clone the repository

```bash
git clone https://github.com/YOUR-USERNAME/book-management-system.git
cd book-management-system
```

### 2. Run the SQL files in order

Open MySQL Workbench, connect to your local MySQL server, and execute these files in sequence:

1. `sql/01_create_database.sql`
2. `sql/02_schema.sql`
3. `sql/03_seed_data.sql`
4. `sql/04_views.sql`
5. `sql/05_triggers.sql`
6. `sql/06_stored_procedures.sql`
7. `sql/07_sample_queries.sql`

Alternatively, from a terminal in the project directory:

```bash
mysql -u root -p < sql/01_create_database.sql
mysql -u root -p < sql/02_schema.sql
mysql -u root -p < sql/03_seed_data.sql
mysql -u root -p < sql/04_views.sql
mysql -u root -p < sql/05_triggers.sql
mysql -u root -p < sql/06_stored_procedures.sql
mysql -u root -p < sql/07_sample_queries.sql
```

Enter your MySQL password when prompted. If you use a different MySQL username, replace `root`.

> `07_sample_queries.sql` contains examples to run and inspect. It is not required for creating the database objects.

## 🗃️ Database Design

The database uses a normalized relational structure:

| Table | Purpose |
|---|---|
| `authors` | Stores author details |
| `publishers` | Stores publisher details |
| `categories` | Classifies books by genre |
| `books` | Stores book metadata and inventory |
| `book_authors` | Resolves the many-to-many book/author relationship |
| `members` | Stores library member details |
| `loans` | Records book issues and returns |

### Relationships

- A publisher can publish many books.
- A category can contain many books.
- A book can have multiple authors, and an author can write multiple books.
- A member can have multiple loan records.
- A book can appear in multiple loan records over time.

See [`docs/DATABASE_DESIGN.md`](docs/DATABASE_DESIGN.md) for the ER diagram and design notes.

## 🧪 Example SQL Operations

### List all books with author and category

```sql
SELECT
    b.title,
    GROUP_CONCAT(a.author_name ORDER BY a.author_name SEPARATOR ', ') AS authors,
    c.category_name,
    b.available_copies
FROM books AS b
LEFT JOIN book_authors AS ba ON ba.book_id = b.book_id
LEFT JOIN authors AS a ON a.author_id = ba.author_id
LEFT JOIN categories AS c ON c.category_id = b.category_id
GROUP BY b.book_id, b.title, c.category_name, b.available_copies
ORDER BY b.title;
```

### Find overdue books

```sql
SELECT *
FROM overdue_books
ORDER BY due_date;
```

### Issue a book

```sql
CALL issue_book(1, 1, 14);
```

The arguments are `member_id`, `book_id`, and loan duration in days. The procedure creates a loan and the trigger decreases the available-copy count.

### Return a book

```sql
CALL return_book(1);
```

The argument is the `loan_id`. The procedure marks the loan as returned and the trigger increases the available-copy count.

## 🧠 SQL Concepts Demonstrated

- DDL: `CREATE DATABASE`, `CREATE TABLE`, `CREATE VIEW`
- DML: `INSERT`, `UPDATE`, `DELETE`
- Querying: `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`
- Joins: `INNER JOIN`, `LEFT JOIN`
- Aggregation: `COUNT`, `SUM`, `AVG`, `GROUP_CONCAT`
- Constraints: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`
- Programmability: stored procedures and triggers
- Reporting: views for active loans, overdue loans, and inventory summaries

## 🔧 Possible Enhancements

- Add late-fee calculation and payment tracking.
- Add role-based access for librarians and administrators.
- Add a reservation queue for unavailable books.
- Build a Python or Streamlit front end.
- Add automated database backups and audit logs.

## 👨‍💻 Author

**Shrayan Biswas**  
BSc Information Technology | Information Security

[GitHub](https://github.com/Shrayan-biswas)

---

⭐ If you find this project useful, consider giving the repository a star.

## 📌 Notes

This is an educational database project. The sample data is fictional. The SQL scripts target MySQL 8.0+ and are intended to be run in the order listed above.
