-- ========================================
-- Safe Migration - Only migrate existing tables
-- ========================================

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data
DELETE FROM revcart_auth.users;
DELETE FROM revcart_users.users;
DELETE FROM revcart_products.products;
DELETE FROM revcart_orders.order_items;
DELETE FROM revcart_orders.orders;

SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

-- Migrate Users to revcart_auth
INSERT INTO revcart_auth.users (id, name, email, password, role, phone, address, email_verified, created_at)
SELECT id, name, email, password, role, phone, address, 
       COALESCE(email_verified, 0), 
       COALESCE(created_at, NOW())
FROM revcart_db.users;

-- Migrate Products
INSERT IGNORE INTO revcart_products.products (id, name, description, price, stock, image_url, created_at)
SELECT id, name, description, price, stock, image_url, 
       COALESCE(created_at, NOW())
FROM revcart_db.products;

-- Verification
SELECT 'Migration Complete!' as status;
SELECT 'revcart_auth.users' as table_name, COUNT(*) as count FROM revcart_auth.users
UNION ALL
SELECT 'revcart_products.products', COUNT(*) FROM revcart_products.products;

SELECT '✅ Users and Products migrated successfully!' as result;
