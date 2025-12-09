-- Update products with categories, brands, and ratings

-- Vegetables
UPDATE products SET category = 'Fruits & Vegetables', brand = 'Fresh Farm', rating = 4.5 WHERE name IN ('Beetroot', 'Cucumber', 'Cabbage', 'Carrots', 'Spinach', 'Onions', 'Potatoes', 'Tomatoes');

-- Electronics
UPDATE products SET category = 'Electronics', brand = 'TechBrand', rating = 4.7 WHERE name IN ('laptop', 'SmartPhone');

-- Set default values for any remaining null fields
UPDATE products SET category = 'General' WHERE category IS NULL;
UPDATE products SET brand = 'Generic' WHERE brand IS NULL;
UPDATE products SET rating = 4.0 WHERE rating IS NULL;
UPDATE products SET active = true WHERE active IS NULL;
UPDATE products SET current_stock = stock WHERE current_stock IS NULL;
UPDATE products SET initial_stock = stock WHERE initial_stock IS NULL;
