USE book_management;

INSERT INTO authors (author_name, country) VALUES
('George Orwell', 'United Kingdom'),
('J. K. Rowling', 'United Kingdom'),
('Yuval Noah Harari', 'Israel'),
('Robert C. Martin', 'United States'),
('Paulo Coelho', 'Brazil'),
('Agatha Christie', 'United Kingdom');

INSERT INTO publishers (publisher_name, city, country) VALUES
('Penguin Random House', 'New York', 'United States'),
('Bloomsbury Publishing', 'London', 'United Kingdom'),
('HarperCollins', 'New York', 'United States'),
('Prentice Hall', 'New Jersey', 'United States');

INSERT INTO categories (category_name, description) VALUES
('Fiction', 'Fictional literature and novels'),
('Fantasy', 'Fantasy and speculative fiction'),
('Non-Fiction', 'History, science, and general non-fiction'),
('Technology', 'Programming and software engineering'),
('Mystery', 'Mystery and detective fiction');

INSERT INTO books
(isbn, title, publisher_id, category_id, publication_year, price, total_copies, available_copies)
VALUES
('9780451524935', '1984', 1, 1, 1949, 399.00, 5, 5),
('9780747532743', 'Harry Potter and the Philosopher''s Stone', 2, 2, 1997, 499.00, 4, 4),
('9780062316097', 'Sapiens', 3, 3, 2011, 599.00, 3, 3),
('9780132350884', 'Clean Code', 4, 4, 2008, 799.00, 3, 3),
('9780061122415', 'The Alchemist', 3, 1, 1988, 299.00, 4, 4),
('9780007527502', 'Murder on the Orient Express', 3, 5, 1934, 349.00, 2, 2);

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6);

INSERT INTO members (full_name, email, phone, address, membership_date, status) VALUES
('Aarav Sharma', 'aarav@example.com', '9000000001', 'Kolkata, India', '2025-01-10', 'ACTIVE'),
('Maya Sen', 'maya@example.com', '9000000002', 'Howrah, India', '2025-02-15', 'ACTIVE'),
('Rohan Das', 'rohan@example.com', '9000000003', 'Salt Lake, Kolkata', '2025-03-20', 'ACTIVE'),
('Isha Roy', 'isha@example.com', '9000000004', 'New Town, Kolkata', '2025-04-05', 'INACTIVE');

-- Add a couple of historical loans for reporting examples.
-- Inventory is adjusted by the trigger when this file is run after triggers.
-- These are intentionally not inserted here; use issue_book() after setup
-- if you want live loan examples, or run the sample procedure calls.
