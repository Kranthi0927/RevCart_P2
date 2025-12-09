-- Check if data exists
SELECT 'Products' as Table_Name, COUNT(*) as Count FROM revcart_product.products
UNION ALL
SELECT 'Orders', COUNT(*) FROM revcart_order.orders
UNION ALL
SELECT 'Users', COUNT(*) FROM revcart_auth.users;

-- Check total revenue
SELECT SUM(total_amount) as Total_Revenue FROM revcart_order.orders;
