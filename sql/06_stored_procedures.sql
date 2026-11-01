USE book_management;

DROP PROCEDURE IF EXISTS issue_book;
DROP PROCEDURE IF EXISTS return_book;

DELIMITER $$

CREATE PROCEDURE issue_book(
    IN p_member_id INT,
    IN p_book_id INT,
    IN p_loan_days INT
)
BEGIN
    DECLARE v_member_status VARCHAR(10);
    DECLARE v_available INT;
    DECLARE v_member_exists INT DEFAULT 0;
    DECLARE v_book_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_loan_days IS NULL OR p_loan_days < 1 OR p_loan_days > 90 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Loan duration must be between 1 and 90 days';
    END IF;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_member_exists
    FROM members
    WHERE member_id = p_member_id;

    IF v_member_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Member does not exist';
    END IF;

    SELECT status INTO v_member_status
    FROM members
    WHERE member_id = p_member_id
    FOR UPDATE;

    IF v_member_status <> 'ACTIVE' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only active members can borrow books';
    END IF;

    SELECT COUNT(*) INTO v_book_exists
    FROM books
    WHERE book_id = p_book_id;

    IF v_book_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Book does not exist';
    END IF;

    SELECT available_copies INTO v_available
    FROM books
    WHERE book_id = p_book_id
    FOR UPDATE;

    IF v_available < 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No available copies of this book';
    END IF;

    INSERT INTO loans (member_id, book_id, issue_date, due_date, status)
    VALUES (
        p_member_id,
        p_book_id,
        CURRENT_DATE,
        DATE_ADD(CURRENT_DATE, INTERVAL p_loan_days DAY),
        'ISSUED'
    );

    COMMIT;

    SELECT 'Book issued successfully' AS message, LAST_INSERT_ID() AS loan_id;
END$$

CREATE PROCEDURE return_book(IN p_loan_id INT)
BEGIN
    DECLARE v_status VARCHAR(10);
    DECLARE v_loan_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_loan_exists
    FROM loans
    WHERE loan_id = p_loan_id;

    IF v_loan_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Loan record does not exist';
    END IF;

    SELECT status INTO v_status
    FROM loans
    WHERE loan_id = p_loan_id
    FOR UPDATE;

    IF v_status = 'RETURNED' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'This book has already been returned';
    END IF;

    UPDATE loans
    SET status = 'RETURNED',
        return_date = CURRENT_DATE
    WHERE loan_id = p_loan_id;

    COMMIT;

    SELECT 'Book returned successfully' AS message;
END$$

DELIMITER ;
