-- ========================================
-- Data Migration from revcart_db to Microservices DBs
-- ========================================

-- 1. Migrate Users to revcart_auth
-- ========================================
INSERT INTO revcart_auth.users (id, name, email, password, role, phone, address, email_verified, created_at)
SELECT id, name, email, password, role, phone, address, email_verified, created_at
FROM revcart_db.users;

-- 2. Migrate Users to revcart_users (for user-service)
-- ========================================
INSERT INTO revcart_users.users (id, name, email, phone, address, created_at)
SELECT id, name, email, phone, address, created_at
FROM revcart_db.users;

-- 3. Migrate Categories to revcart_products
-- ========================================
INSERT INTO revcart_products.categories (id, name, description, image_url, created_at)
SELECT id, name, description, image_url, created_at
FROM revcart_db.categories;

-- 4. Migrate Products to revcart_products
-- ========================================
INSERT INTO revcart_products.products (id, name, description, price, stock, category_id, image_url, created_at, updated_at)
SELECT id, name, description, price, stock, category_id, image_url, created_at, updated_at
FROM revcart_db.products;

-- 5. Migrate Orders to revcart_orders
-- ========================================
INSERT INTO revcart_orders.orders (id, user_id, total_amount, status, shipping_address, payment_method, created_at, updated_at)
SELECT id, user_id, total_amount, status, shipping_address, payment_method, created_at, updated_at
FROM revcart_db.orders;

-- 6. Migrate Order Items to revcart_orders
-- ========================================
INSERT INTO revcart_orders.order_items (id, order_id, product_id, quantity, price, created_at)
SELECT id, order_id, product_id, quantity, price, created_at
FROM revcart_db.order_items;

-- 7. Migrate Payments to revcart_payments
-- ========================================
INSERT INTO revcart_payments.payments (id, order_id, amount, payment_method, status, transaction_id, created_at)
SELECT id, order_id, amount, payment_method, status, transaction_id, created_at
FROM revcart_db.payments
WHERE EXISTS (SELECT 1 FROM revcart_db.payments);

-- 8. Migrate Delivery data to revcart_delivery
-- ========================================
INSERT INTO revcart_delivery.deliveries (id, order_id, delivery_agent_id, status, tracking_number, created_at, updated_at)
SELECT id, order_id, delivery_agent_id, status, tracking_number, created_at, updated_at
FROM revcart_db.deliveries
WHERE EXISTS (SELECT 1 FROM revcart_db.deliveries);

-- ========================================
-- Verification Queries
-- ========================================

-- Check counts
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
