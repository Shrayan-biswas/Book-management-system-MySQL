# Database Design

## Entity relationship diagram

```mermaid
erDiagram
    PUBLISHERS ||--o{ BOOKS : publishes
    CATEGORIES ||--o{ BOOKS : classifies
    BOOKS ||--o{ BOOK_AUTHORS : has
    AUTHORS ||--o{ BOOK_AUTHORS : writes
    MEMBERS ||--o{ LOANS : borrows
    BOOKS ||--o{ LOANS : appears_in

    PUBLISHERS {
        int publisher_id PK
        varchar publisher_name
        varchar city
        varchar country
    }
    CATEGORIES {
        int category_id PK
        varchar category_name
        varchar description
    }
    BOOKS {
        int book_id PK
        varchar isbn UK
        varchar title
        int publisher_id FK
        int category_id FK
        int total_copies
        int available_copies
    }
    AUTHORS {
        int author_id PK
        varchar author_name
        varchar country
    }
    BOOK_AUTHORS {
        int book_id PK, FK
        int author_id PK, FK
    }
    MEMBERS {
        int member_id PK
        varchar full_name
        varchar email UK
        enum status
    }
    LOANS {
        int loan_id PK
        int member_id FK
        int book_id FK
        date issue_date
        date due_date
        date return_date
        enum status
    }
```

## Design decisions

- `book_authors` implements the many-to-many relationship between books and authors.
- `loans` stores each borrowing event, preserving borrowing history.
- `books.available_copies` is maintained by triggers when a loan is issued or returned.
- Foreign keys protect relationships and prevent deleting members or books that have loan history.
- Views simplify common reporting tasks.
- Stored procedures centralize issue and return operations and validate basic business rules.

## Inventory rule

When an `ISSUED` loan is inserted, the `AFTER INSERT` trigger decreases `available_copies` by one. When an issued loan changes to `RETURNED`, the `AFTER UPDATE` trigger increases it by one.

For normal use, issue and return books through the stored procedures rather than inserting or changing loan rows manually.
