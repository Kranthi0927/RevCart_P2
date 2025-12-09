# Data Migration Guide

## Overview
Migrate data from monolithic `revcart_db` to microservices databases.

## Migration Mapping

| Old Database | New Database | Tables |
|--------------|--------------|--------|
| revcart_db | revcart_auth | users (auth data) |
| revcart_db | revcart_users | users (profile data) |
| revcart_db | revcart_products | products, categories |
| revcart_db | revcart_orders | orders, order_items |
| revcart_db | revcart_payments | payments |
| revcart_db | revcart_delivery | deliveries |

## Steps to Migrate

### Method 1: Using MySQL Workbench (Recommended)

1. Open MySQL Workbench
2. Connect to your MySQL server
3. Open file: `migrate-data.sql`
4. Click Execute (⚡ icon)
5. Check results

### Method 2: Using Command Line

```bash
cd c:\Users\binnu\Downloads\Revcart\Revcart\Revcart\microservices\data-migration
mysql -u root -p < migrate-data.sql
```

### Method 3: Using Batch Script

```bash
cd c:\Users\binnu\Downloads\Revcart\Revcart\Revcart\microservices\data-migration
migrate-data.bat
```

## Verify Migration

```sql
-- Check user count
SELECT COUNT(*) FROM revcart_auth.users;
SELECT COUNT(*) FROM revcart_users.users;

-- Check product count
SELECT COUNT(*) FROM revcart_products.products;
SELECT COUNT(*) FROM revcart_products.categories;

-- Check order count
SELECT COUNT(*) FROM revcart_orders.orders;
SELECT COUNT(*) FROM revcart_orders.order_items;
```

## Important Notes

1. **Backup First**: Always backup your data before migration
2. **Stop Services**: Stop all microservices before migration
3. **Check Schema**: Ensure all microservice databases exist
4. **Password Encryption**: Old passwords should be BCrypt encrypted
5. **Foreign Keys**: Migration maintains referential integrity

## Troubleshooting

### Error: Table doesn't exist
- Make sure all microservices have run at least once to create tables
- Check if databases exist: `SHOW DATABASES;`

### Error: Duplicate entry
- Clear target databases first:
```sql
TRUNCATE TABLE revcart_auth.users;
TRUNCATE TABLE revcart_products.products;
```

### Error: Foreign key constraint
- Migrate in order: users → categories → products → orders → order_items

## Rollback

If migration fails, restore from backup:
```sql
-- Restore original database
mysql -u root -p revcart_db < backup.sql
```
