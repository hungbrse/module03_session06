CREATE DATABASE session06_ex3;
use session06_ex3;

CREATE TABLE users(
id int AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
myMoney DOUBLE,
address VARCHAR(255),
phone VARCHAR(11),
dateOfBirth DATE,
status bit
);


CREATE TABLE transfer(
sender_id int AUTO_INCREMENT PRIMARY KEY,
receiver_id int,FOREIGN KEY(receiver_id) REFERENCES users(id),
money DOUBLE,
transfer_date DATETIME
);


INSERT INTO users (name, myMoney, address, phone, dateOfBirth, status) VALUES
('Nguyen Van A', 5000.00, '123 Street, City', '0123456789', '1990-01-01', 1),
('Tran Thi B', 3000.50, '456 Avenue, City', '0987654321', '1985-05-12', 1),
('Le Van C', 1000.75, '789 Boulevard, City', '0912345678', '2000-10-20', 0);

CREATE TABLE transfer (
    sender_id INT AUTO_INCREMENT PRIMARY KEY,
    receiver_id INT,
    money DOUBLE,
    transfer_date DATETIME,
    FOREIGN KEY (receiver_id) REFERENCES users(id)
);

INSERT INTO transfer ( receiver_id, money, transfer_date) VALUES
( 2, 1000.00, '2024-09-30 10:00:00'),
( 1, 500.50, '2024-09-30 11:00:00'),
( 3, 1500.25, '2024-09-30 12:00:00');

DELIMITER //

CREATE PROCEDURE transfer_money(
    IN sender_id INT,
    IN receiver_id INT,
    IN transfer_amount DOUBLE
)
BEGIN
    DECLARE sender_balance DOUBLE;

    START TRANSACTION;

    SELECT myMoney INTO sender_balance FROM users WHERE id = sender_id;

    IF transfer_amount > sender_balance THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không đủ tiền trong tài khoản!';
    ELSE
        UPDATE users SET myMoney = myMoney - transfer_amount WHERE id = sender_id;

        UPDATE users SET myMoney = myMoney + transfer_amount WHERE id = receiver_id;

        INSERT INTO transfer (sender_id, receiver_id, money, transfer_date)
        VALUES (sender_id, receiver_id, transfer_amount, NOW());

        COMMIT;
    END IF;
END //

DELIMITER ;

CALL transfer_money(1, 2, 6000.00); 
