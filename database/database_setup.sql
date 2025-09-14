DROP DATABASE IF EXISTS momo_db;
CREATE DATABASE momo_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE momo_db;

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS transaction_categories;
DROP TABLE IF EXISTS system_logs;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'PK: unique user id',
  phone VARCHAR(32) NOT NULL COMMENT 'E.164 or local phone number',
  name VARCHAR(150) DEFAULT NULL COMMENT 'Display name if available',
  email VARCHAR(255) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT NULL,
  UNIQUE KEY ux_users_phone (phone)
) ENGINE=InnoDB;

CREATE TABLE transaction_categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'PK: category id',
  code VARCHAR(64) NOT NULL COMMENT 'programmatic code (e.g., airtime, payment)',
  label VARCHAR(128) NOT NULL COMMENT 'human friendly name',
  description VARCHAR(255) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY ux_cat_code (code)
) ENGINE=InnoDB;

CREATE TABLE transactions (
  transaction_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'PK: internal transaction id',
  external_id VARCHAR(128) DEFAULT NULL COMMENT 'external id from SMS or provider',
  transaction_time DATETIME NOT NULL COMMENT 'when transaction occurred per SMS',
  amount DECIMAL(14,2) NOT NULL COMMENT 'amount in local currency',
  currency CHAR(3) NOT NULL DEFAULT 'RWF' COMMENT 'ISO currency code',
  status ENUM('PENDING','SUCCESS','FAILED','UNKNOWN') NOT NULL DEFAULT 'UNKNOWN',
  sender_id INT NOT NULL COMMENT 'FK -> users.user_id (sender)',
  receiver_id INT DEFAULT NULL COMMENT 'FK -> users.user_id (receiver/merchant)',
  channel VARCHAR(64) DEFAULT NULL COMMENT 'e.g., MoMo, AirtimeTopup',
  narrative VARCHAR(512) DEFAULT NULL COMMENT 'parsed message text summary',
  raw_xml TEXT DEFAULT NULL COMMENT 'original XML snippet for auditing',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT NULL,
  FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
  KEY idx_transactions_time (transaction_time),
  KEY idx_transactions_status (status),
  KEY idx_transactions_sender (sender_id),
  KEY idx_transactions_receiver (receiver_id)
) ENGINE=InnoDB;

CREATE TABLE transaction_category_map (
  map_id INT AUTO_INCREMENT PRIMARY KEY,
  transaction_id INT NOT NULL,
  category_id INT NOT NULL,
  confidence DECIMAL(4,2) DEFAULT 1.00 COMMENT '0.00-1.00 confidence score for auto-categorization',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id) ON DELETE RESTRICT,
  UNIQUE KEY ux_tx_cat (transaction_id, category_id)
) ENGINE=InnoDB;

CREATE TABLE system_logs (
  log_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'PK: log id',
  log_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  level ENUM('DEBUG','INFO','WARN','ERROR') NOT NULL DEFAULT 'INFO',
  component VARCHAR(128) DEFAULT NULL COMMENT 'e.g., etl.parse_xml',
  message TEXT NOT NULL,
  transaction_id INT DEFAULT NULL COMMENT 'optional FK to transactions for context',
  meta JSON DEFAULT NULL COMMENT 'optional structured metadata',
  FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE SET NULL
) ENGINE=InnoDB;

INSERT INTO users (phone, name) VALUES
  ('250780000001','Alice N'),
  ('250780000002','Bob K'),
  ('250780000003','Carol M'),
  ('250780000004','Driver D'),
  ('250780000005','Merchant X');

INSERT INTO transaction_categories (code, label, description) VALUES
  ('transfer','Transfer','Peer-to-peer transfer'),
  ('payment','Payment','Payment to merchant/service'),
  ('airtime','Airtime Topup','Airtime purchase/airtime top-up'),
  ('fee','Fee','Service fee, charge'),
  ('refund','Refund','Refund or reversal');

INSERT INTO transactions
(external_id, transaction_time, amount, currency, status, sender_id, receiver_id, channel, narrative, raw_xml)
VALUES
('ext-0001','2025-09-01 08:10:00', 2000.00,'RWF','SUCCESS', 1, 5, 'MoMo','Payment to Merchant X','<sms>...</sms>'),
('ext-0002','2025-09-01 09:05:00', 500.00,'RWF','SUCCESS', 2, 3, 'MoMo','Transfer to Carol','<sms>...</sms>'),
('ext-0003','2025-09-02 12:45:00', 1000.00,'RWF','FAILED', 3, NULL, 'MoMo','Failed airtime purchase','<sms>...</sms>'),
('ext-0004','2025-09-03 07:30:00', 150.00,'RWF','SUCCESS', 1, 4, 'MoMo','Driver payout','<sms>...</sms>'),
('ext-0005','2025-09-03 10:00:00', 2500.00,'RWF','PENDING', 2, 5, 'MoMo','Payment awaiting confirmation','<sms>...</sms>');

INSERT INTO transaction_category_map (transaction_id, category_id, confidence) VALUES
  (1, 2, 0.98),
  (1, 4, 0.30),
  (2, 1, 0.95),
  (3, 3, 0.90),
  (4, 1, 0.85),
  (5, 2, 0.70);

INSERT INTO system_logs (level, component, message, transaction_id, meta) VALUES
('INFO','etl.parse_xml','Parsed 5 transactions from momo.xml',NULL, JSON_OBJECT('file','momo.xml','rows',5)),
('ERROR','etl.clean_normalize','Failed to parse amount for external id ext-0006',NULL, JSON_OBJECT('external_id','ext-0006','raw_amount','N/A')),
('INFO','etl.categorize','Assigned categories to transaction 1',1, NULL),
('WARN','etl.load_db','Transaction ext-0005 inserted with status PENDING',5, JSON_OBJECT('note','manual_review')),
('DEBUG','etl','Starting ETL run',NULL, NULL);
