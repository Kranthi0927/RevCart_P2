# Microfrontend Architecture - Complete Setup

## Current Status
✅ API Gateway configured (Port 8080)
✅ All microservices running
✅ CORS configured for microfrontends (Ports 4200-4205)

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                  Shell App (4200)                       │
│              Main Container/Host                        │
└─────────────────────────────────────────────────────────┘
         │         │         │         │         │
    ┌────┴───┐ ┌──┴───┐ ┌───┴───┐ ┌───┴───┐ ┌──┴────┐
    │ Auth   │ │Prod  │ │ Cart  │ │Admin  │ │Orders │
    │ 4201   │ │4202  │ │ 4203  │ │ 4204  │ │ 4205  │
    └────────┘ └──────┘ └───────┘ └───────┘ └───────┘
                         │
                    ┌────┴────┐
                    │ Gateway │
                    │  8080   │
                    └────┬────┘
         ┌──────┬────┬───┴───┬────┬──────┐
         │Auth  │User│Product│Cart│Order │...
         │8081  │8082│ 8083  │8084│ 8085 │
         └──────┴────┴───────┴────┴──────┘
```

## Quick Start (Simplified Approach)

### Option 1: Module Federation with Existing App

Instead of creating separate apps, convert existing components to modules:

1. **Update Shell (revcart-frontend)**

```bash
cd revcart-frontend
npm install @angular-architects/module-federation --save-dev
```

2. **Update angular.json** to use webpack:

```json
"architect": {
  "build": {
    "builder": "@angular-architects/module-federation:build",
    "options": {
      "extraWebpackConfig": "webpack.config.js"
    }
  },
  "serve": {
    "builder": "@angular-architects/module-federation:dev-server"
  }
}
```

3. **Create Feature Modules**

```bash
cd src/app
ng g m auth --routing
ng g m products --routing
ng g m cart --routing
ng g m admin --routing
ng g m orders --routing
```

4. **Move Components to Modules**
- Move `components/auth/*` → `auth/`
- Move `components/products/*` → `products/`
- Move `components/cart/*` + `checkout/*` → `cart/`
- Move `components/admin/*` → `admin/`
- Move `components/orders/*` → `orders/`

### Option 2: Separate Microfrontend Apps (Full Isolation)

Run this script to create all MFEs:

```bash
cd C:\Users\binnu\Downloads\Revcart\Revcart\Revcart
mkdir mfe-apps && cd mfe-apps

# Create each MFE
ng new auth-mfe --routing --style=css --skip-git
ng new products-mfe --routing --style=css --skip-git
ng new cart-mfe --routing --style=css --skip-git
ng new admin-mfe --routing --style=css --skip-git
ng new orders-mfe --routing --style=css --skip-git

# Install Module Federation in each
cd auth-mfe && npm install @angular-architects/module-federation --save-dev && cd ..
cd products-mfe && npm install @angular-architects/module-federation --save-dev && cd ..
cd cart-mfe && npm install @angular-architects/module-federation --save-dev && cd ..
cd admin-mfe && npm install @angular-architects/module-federation --save-dev && cd ..
cd orders-mfe && npm install @angular-architects/module-federation --save-dev && cd ..
```

## Environment Configuration (All MFEs)

Create `src/environments/environment.ts` in each MFE:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api'
};
```

## Running Everything

### Start Backend Services:
```bash
# Terminal 1 - Consul
consul agent -dev

# Terminal 2 - API Gateway
cd microservices\api-gateway
mvn spring-boot:run

# Terminal 3-8 - All Microservices
cd microservices\auth-service && mvn spring-boot:run
cd microservices\user-service && mvn spring-boot:run
cd microservices\product-service && mvn spring-boot:run
cd microservices\cart-service && mvn spring-boot:run
cd microservices\order-service && mvn spring-boot:run
cd microservices\notification-service && mvn spring-boot:run
```

### Start Frontend (Current Monolith):
```bash
cd revcart-frontend
npm start
# Access: http://localhost:4200
```

### OR Start Microfrontends (If created):
```bash
# Shell
cd revcart-frontend && npm start

# Auth MFE
cd mfe-apps\auth-mfe && ng serve --port 4201

# Products MFE
cd mfe-apps\products-mfe && ng serve --port 4202

# Cart MFE
cd mfe-apps\cart-mfe && ng serve --port 4203

# Admin MFE
cd mfe-apps\admin-mfe && ng serve --port 4204

# Orders MFE
cd mfe-apps\orders-mfe && ng serve --port 4205
```

## Recommendation

**Start with Option 1** (Module Federation with existing app):
- Faster to implement
- Less complexity
- Easier to maintain
- Can migrate to separate apps later

**Use Option 2** when:
- Teams need complete independence
- Different deployment schedules required
- Separate CI/CD pipelines needed

## Next Steps

1. Keep current monolithic frontend working ✅
2. API Gateway is already configured ✅
3. All services connect through Gateway ✅
4. Migrate to microfrontends gradually (optional)

Your system is already working with microservices backend + API Gateway!
