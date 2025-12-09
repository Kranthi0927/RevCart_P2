USE revcart_auth;

-- Make kranthikiran0927@gmail.com an admin
UPDATE users SET role = 'ADMIN' WHERE email = 'kranthikiran0927@gmail.com';

-- Verify the change
SELECT email, role FROM users WHERE email = 'kranthikiran0927@gmail.com';
