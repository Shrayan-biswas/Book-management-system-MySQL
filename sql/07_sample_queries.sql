USE book_management;

-- 1. View all books with author, category, and stock.
SELECT
    b.book_id,
    b.title,
    GROUP_CONCAT(a.author_name ORDER BY a.author_name SEPARATOR ', ') AS authors,
    c.category_name,
    b.total_copies,
    b.available_copies
FROM books AS b
LEFT JOIN book_authors AS ba ON ba.book_id = b.book_id
LEFT JOIN authors AS a ON a.author_id = ba.author_id
LEFT JOIN categories AS c ON c.category_id = b.category_id
GROUP BY
    b.book_id, b.title, c.category_name, b.total_copies, b.available_copies
ORDER BY b.title;

-- 2. Search for a title (change the search term as needed).
SELECT book_id, title, isbn
FROM books
WHERE title LIKE '%clean%';

-- 3. List active members.
SELECT member_id, full_name, email
FROM members
WHERE status = 'ACTIVE'
ORDER BY full_name;

-- 4. Inventory summary.
SELECT * FROM book_inventory_summary ORDER BY title;

-- 5. Books currently issued.
SELECT * FROM current_issued_books ORDER BY due_date;

-- 6. Overdue books.
SELECT * FROM overdue_books ORDER BY days_overdue DESC;

-- 7. Most borrowed books.
SELECT
    b.title,
    COUNT(l.loan_id) AS times_borrowed
FROM books AS b
LEFT JOIN loans AS l ON l.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC, b.title;

-- 8. Total books by category.
SELECT
    c.category_name,
    COUNT(b.book_id) AS title_count,
    COALESCE(SUM(b.total_copies), 0) AS physical_copies
FROM categories AS c
LEFT JOIN books AS b ON b.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY title_count DESC;

-- 9. Issue a book to an active member (uncomment to execute).
-- CALL issue_book(1, 1, 14);

-- 10. Return a loan (replace 1 with an existing loan_id).
-- CALL return_book(1);
