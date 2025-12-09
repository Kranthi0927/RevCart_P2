@echo off
cd ..

echo Creating Auth Microfrontend...
call ng new auth-mfe --routing --style=css --skip-git
cd auth-mfe
call npm install @angular-architects/module-federation --save-dev
cd ..

echo Creating Products Microfrontend...
call ng new products-mfe --routing --style=css --skip-git
cd products-mfe
call npm install @angular-architects/module-federation --save-dev
cd ..

echo Creating Cart Microfrontend...
call ng new cart-mfe --routing --style=css --skip-git
cd cart-mfe
call npm install @angular-architects/module-federation --save-dev
cd ..

echo Creating Admin Microfrontend...
call ng new admin-mfe --routing --style=css --skip-git
cd admin-mfe
call npm install @angular-architects/module-federation --save-dev
cd ..

echo Creating Orders Microfrontend...
call ng new orders-mfe --routing --style=css --skip-git
cd orders-mfe
call npm install @angular-architects/module-federation --save-dev
cd ..

echo All microfrontends created!
