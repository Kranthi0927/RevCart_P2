-- Fix broken product images
USE revcart_product;

-- Update Salted Peanuts
UPDATE products SET image_url = 'https://m.media-amazon.com/images/I/81xnWVLhOyL._SL1500_.jpg' WHERE name LIKE '%Salted Peanuts%' OR name LIKE '%salted peanuts%';

-- Update Popcorn
UPDATE products SET image_url = 'https://m.media-amazon.com/images/I/81QpkRbBvyL._SL1500_.jpg' WHERE name LIKE '%Popcorn%' OR name LIKE '%popcorn%';

-- Update Salted Cashews
UPDATE products SET image_url = 'https://m.media-amazon.com/images/I/81J7eXQGZyL._SL1500_.jpg' WHERE name LIKE '%Salted Cashews%' OR name LIKE '%salted cashews%' OR name LIKE '%Cashews%';

-- Update Rusk
UPDATE products SET image_url = 'https://m.media-amazon.com/images/I/71vqHWKJOyL._SL1500_.jpg' WHERE name LIKE '%Rusk%' OR name LIKE '%rusk%';

-- Update Rohu Fish
UPDATE products SET image_url = 'https://m.media-amazon.com/images/I/71KqVZ8XJSL._SL1500_.jpg' WHERE name LIKE '%Rohu%' OR name LIKE '%rohu%';

-- Update Smoked Salmon
UPDATE products SET image_url = 'https://m.media-amazon.com/images/I/81rqVvhN8LL._SL1500_.jpg' WHERE name LIKE '%Smoked Salmon%' OR name LIKE '%smoked salmon%' OR name LIKE '%Salmon%';

-- Update Shrimp
UPDATE products SET image_url = 'https://m.media-amazon.com/images/I/71xZnZWLjyL._SL1500_.jpg' WHERE name LIKE '%Shrimp%' OR name LIKE '%shrimp%';

-- Update Skim Milk
UPDATE products SET image_url = 'https://m.media-amazon.com/images/I/61hL3AWJdyL._SL1500_.jpg' WHERE name LIKE '%Skim Milk%' OR name LIKE '%skim milk%' OR name LIKE '%Milk%';

-- Verify updates
SELECT id, name, image_url FROM products WHERE name LIKE '%Peanuts%' OR name LIKE '%Popcorn%' OR name LIKE '%Cashews%' OR name LIKE '%Rusk%' OR name LIKE '%Fish%' OR name LIKE '%Salmon%' OR name LIKE '%Shrimp%' OR name LIKE '%Milk%';
