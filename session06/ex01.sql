CREATE DATABASE session06_ex01;
use session06_ex01;

CREATE TABLE users(
id int AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
address VARCHAR(255),
phone VARCHAR(11),
dateOfBirth DATE,
status bit 
);

CREATE TABLE product(
id int AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
price DOUBLE,
stock int,
status bit
);

CREATE TABLE shopping_cart(
id int PRIMARY KEY AUTO_INCREMENT,
user_id int ,FOREIGN KEY(user_id) REFERENCES users(id),
product_id int ,FOREIGN KEY(product_id) REFERENCES product(id),
quantity int ,
amount DOUBLE

);

-- Thêm dữ liệu vào bảng users
INSERT INTO users (name, address, phone, dateOfBirth, status)
VALUES 
('John Doe', '123 Elm Street', '0123456789', '1990-05-15', 1),
('Jane Smith', '456 Oak Avenue', '0987654321', '1985-08-25', 1),
('Alice Johnson', '789 Maple Road', '0112233445', '1992-11-05', 0);

-- Thêm dữ liệu vào bảng product
INSERT INTO product (name, price, stock, status)
VALUES 
('Laptop', 1500.00, 10, 1),
('Smartphone', 800.00, 20, 1),
('Headphones', 100.00, 50, 1);

-- Thêm dữ liệu vào bảng shopping_cart
INSERT INTO shopping_cart (user_id, product_id, quantity, amount)
VALUES 
(1, 1, 2, 3000.00),
(2, 2, 1, 800.00),
(3, 3, 5, 500.00);

DELIMITER $$

CREATE TRIGGER trg_update_amount_after_price_change
AFTER UPDATE ON product
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        UPDATE shopping_cart
        SET amount = NEW.price * quantity
        WHERE product_id = NEW.id;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_delete_shopping_cart_after_product_delete
AFTER DELETE ON product
FOR EACH ROW
BEGIN
    DELETE FROM shopping_cart
    WHERE product_id = OLD.id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_reduce_stock_after_add_to_cart
AFTER INSERT ON shopping_cart
FOR EACH ROW
BEGIN
    UPDATE product
    SET stock = stock - NEW.quantity
    WHERE id = NEW.product_id;
END$$

DELIMITER ;

