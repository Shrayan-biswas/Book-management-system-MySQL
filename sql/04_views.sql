USE book_management;

CREATE OR REPLACE VIEW book_inventory_summary AS
SELECT
    b.book_id,
    b.isbn,
    b.title,
    COALESCE(c.category_name, 'Uncategorised') AS category,
    b.total_copies,
    b.available_copies,
    (b.total_copies - b.available_copies) AS borrowed_copies
FROM books AS b
LEFT JOIN categories AS c ON c.category_id = b.category_id;

CREATE OR REPLACE VIEW current_issued_books AS
SELECT
    l.loan_id,
    m.member_id,
    m.full_name AS member_name,
    m.email,
    b.book_id,
    b.title AS book_title,
    l.issue_date,
    l.due_date,
    DATEDIFF(l.due_date, CURRENT_DATE) AS days_until_due
FROM loans AS l
JOIN members AS m ON m.member_id = l.member_id
JOIN books AS b ON b.book_id = l.book_id
WHERE l.status = 'ISSUED';

CREATE OR REPLACE VIEW overdue_books AS
SELECT
    loan_id,
    member_id,
    member_name,
    email,
    book_id,
    book_title,
    issue_date,
    due_date,
    DATEDIFF(CURRENT_DATE, due_date) AS days_overdue
FROM current_issued_books
WHERE due_date < CURRENT_DATE;
