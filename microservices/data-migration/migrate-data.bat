@echo off
echo ========================================
echo Data Migration Script
echo ========================================
echo.
echo This will migrate data from revcart_db to microservices databases
echo.
pause

echo Running migration...
mysql -u root -p < migrate-data.sql

echo.
echo ========================================
echo Migration Complete!
echo ========================================
echo.
echo Verify the data:
mysql -u root -p -e "SELECT 'revcart_auth.users' as db, COUNT(*) as count FROM revcart_auth.users; SELECT 'revcart_products.products' as db, COUNT(*) as count FROM revcart_products.products;"
echo.
pause
