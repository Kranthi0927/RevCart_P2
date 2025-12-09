@echo off
echo Starting minimal infrastructure...

echo Starting Consul...
start "Consul" cmd /k "consul agent -dev -ui -bind=127.0.0.1 -client=127.0.0.1"

echo Starting MySQL (if installed locally)...
echo Please ensure MySQL is running on port 3306

echo Starting Redis (if installed locally)...
echo Please ensure Redis is running on port 6379

echo Minimal setup complete!
echo - Consul: http://localhost:8500
echo - MySQL: localhost:3306 (ensure it's running)
echo - Redis: localhost:6379 (ensure it's running)

pause