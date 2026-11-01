USE book_management;

DROP TRIGGER IF EXISTS trg_loan_after_insert;
DROP TRIGGER IF EXISTS trg_loan_after_update;

DELIMITER $$

-- Decrease inventory when a new active loan is created.
CREATE TRIGGER trg_loan_after_insert
AFTER INSERT ON loans
FOR EACH ROW
BEGIN
    IF NEW.status = 'ISSUED' THEN
        UPDATE books
        SET available_copies = available_copies - 1
        WHERE book_id = NEW.book_id;
    END IF;
END$$

-- Restore inventory when an issued loan is returned.
CREATE TRIGGER trg_loan_after_update
AFTER UPDATE ON loans
FOR EACH ROW
BEGIN
    IF OLD.status = 'ISSUED' AND NEW.status = 'RETURNED' THEN
        UPDATE books
        SET available_copies = available_copies + 1
        WHERE book_id = OLD.book_id;
    END IF;
END$$

DELIMITER ;
