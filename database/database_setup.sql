CREATE DATABASE IF NOT EXISTS momo_db;
USE momo_db;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transaction_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(12,2) CHECK (amount >= 0),
    transaction_time DATETIME NOT NULL,
    status ENUM('SUCCESS','FAILED','PENDING') DEFAULT 'SUCCESS',
    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id),
    INDEX idx_transaction_time (transaction_time),
    INDEX idx_sender (sender_id),
    INDEX idx_receiver (receiver_id)
);

INSERT INTO users (name, phone_number) VALUES
('Alice Johnson', '250700111111'),
('Bob Smith', '250700222222'),
('Carol White', '250700333333'),
('David Brown', '250700444444'),
('Eve Adams', '250700555555');

INSERT INTO transaction_categories (category_name, description) VALUES
('Deposit', 'Money deposited into wallet'),
('Withdrawal', 'Money withdrawn from wallet'),
('Transfer', 'Money sent to another user'),
('Payment', 'Payment for goods or services'),
('Airtime', 'Purchase of mobile airtime');

INSERT INTO transactions (sender_id, receiver_id, category_id, amount, transaction_time, status) VALUES
(1, 2, 3, 1500.00, '2025-09-10 10:15:00', 'SUCCESS'),
(2, 3, 4, 500.00, '2025-09-10 11:00:00', 'SUCCESS'),
(3, 1, 1, 2000.00, '2025-09-11 09:45:00', 'SUCCESS'),
(4, 5, 5, 100.00, '2025-09-11 14:30:00', 'PENDING'),
(5, 2, 2, 800.00, '2025-09-12 16:00:00', 'FAILED');
