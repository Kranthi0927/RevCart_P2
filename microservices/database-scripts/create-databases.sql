-- Create databases for each microservice
CREATE DATABASE IF NOT EXISTS user_db;
CREATE DATABASE IF NOT EXISTS product_db;
CREATE DATABASE IF NOT EXISTS order_db;
CREATE DATABASE IF NOT EXISTS payment_db;
CREATE DATABASE IF NOT EXISTS delivery_db;

-- Create users for each service (optional, for better security)
CREATE USER IF NOT EXISTS 'user_service'@'%' IDENTIFIED BY 'user_password';
CREATE USER IF NOT EXISTS 'product_service'@'%' IDENTIFIED BY 'product_password';
CREATE USER IF NOT EXISTS 'order_service'@'%' IDENTIFIED BY 'order_password';
CREATE USER IF NOT EXISTS 'payment_service'@'%' IDENTIFIED BY 'payment_password';
CREATE USER IF NOT EXISTS 'delivery_service'@'%' IDENTIFIED BY 'delivery_password';

-- Grant permissions
GRANT ALL PRIVILEGES ON user_db.* TO 'user_service'@'%';
GRANT ALL PRIVILEGES ON product_db.* TO 'product_service'@'%';
GRANT ALL PRIVILEGES ON order_db.* TO 'order_service'@'%';
GRANT ALL PRIVILEGES ON payment_db.* TO 'payment_service'@'%';
GRANT ALL PRIVILEGES ON delivery_db.* TO 'delivery_service'@'%';

FLUSH PRIVILEGES;