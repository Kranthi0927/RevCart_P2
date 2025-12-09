-- ========================================
-- Clear existing data and migrate
-- ========================================

-- 1. Clear all microservices databases
-- ========================================
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE revcart_auth.users;
TRUNCATE TABLE revcart_users.users;
TRUNCATE TABLE revcart_products.products;
TRUNCATE TABLE revcart_products.categories;
TRUNCATE TABLE revcart_orders.order_items;
TRUNCATE TABLE revcart_orders.orders;

SET FOREIGN_KEY_CHECKS = 1;

-- 2. Migrate Users to revcart_auth
-- ========================================
INSERT INTO revcart_auth.users (id, name, email, password, role, phone, address, email_verified, created_at)
SELECT id, name, email, password, role, phone, address, email_verified, created_at
FROM revcart_db.users;

-- 3. Migrate Users to revcart_users
-- ========================================
INSERT INTO revcart_users.users (id, name, email, phone, address, created_at)
SELECT id, name, email, phone, address, created_at
FROM revcart_db.users;

-- 4. Migrate Categories
-- ========================================
INSERT INTO revcart_products.categories (id, name, description, image_url, created_at)
SELECT id, name, description, image_url, created_at
FROM revcart_db.categories;

-- 5. Migrate Products
-- ========================================
INSERT INTO revcart_products.products (id, name, description, price, stock, category_id, image_url, created_at, updated_at)
SELECT id, name, description, price, stock, category_id, image_url, created_at, updated_at
FROM revcart_db.products;

-- 6. Migrate Orders
-- ========================================
INSERT INTO revcart_orders.orders (id, user_id, total_amount, status, shipping_address, payment_method, created_at, updated_at)
SELECT id, user_id, total_amount, status, shipping_address, payment_method, created_at, updated_at
FROM revcart_db.orders;

-- 7. Migrate Order Items
-- ========================================
INSERT INTO revcart_orders.order_items (id, order_id, product_id, quantity, price, created_at)
SELECT id, order_id, product_id, quantity, price, created_at
FROM revcart_db.order_items;

-- ========================================
-- Verification
-- ========================================
SELECT 'revcart_auth.users' as table_name, COUNT(*) as count FROM revcart_auth.users
UNION ALL
SELECT 'revcart_users.users', COUNT(*) FROM revcart_users.users
UNION ALL
SELECT 'revcart_products.categories', COUNT(*) FROM revcart_products.categories
UNION ALL
SELECT 'revcart_products.products', COUNT(*) FROM revcart_products.products
UNION ALL
SELECT 'revcart_orders.orders', COUNT(*) FROM revcart_orders.orders
UNION ALL
SELECT 'revcart_orders.order_items', COUNT(*) FROM revcart_orders.order_items;
