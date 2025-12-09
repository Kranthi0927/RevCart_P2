# Quick Start Guide - Microfrontend Architecture

## ✅ Prerequisites Installed
- Node.js & npm ✅
- Angular CLI ✅
- Java & Maven ✅
- Consul ✅
- MongoDB ✅
- MySQL ✅

## 🚀 One-Command Start

### Option 1: Start Everything (Recommended)

```bash
cd C:\Users\binnu\Downloads\Revcart\Revcart\Revcart
START-EVERYTHING.bat
```

This will:
1. Install all MFE dependencies
2. Start all 6 frontend apps
3. Open in separate terminals

### Option 2: Manual Start

**Step 1: Install MFE Dependencies (First Time Only)**
```bash
cd mfe-apps
SETUP-AND-RUN.bat
```

**Step 2: Start All Frontends**
```bash
cd mfe-apps
START-ALL-MFES.bat
```

## 🎯 What Gets Started

### Frontend (6 Apps):
- Shell App: http://localhost:4200
- Auth MFE: http://localhost:4201
- Products MFE: http://localhost:4202
- Cart MFE: http://localhost:4203
- Admin MFE: http://localhost:4204
- Orders MFE: http://localhost:4205

### Backend (Already Running):
- Consul: http://localhost:8500
- API Gateway: http://localhost:8080
- Auth Service: 8081
- User Service: 8082
- Product Service: 8083
- Cart Service: 8084
- Order Service: 8085
- Notification Service: 8087

## 📱 Access Application

Open browser: **http://localhost:4200**

## 🔍 Verify Everything Works

1. **Check Shell App**: http://localhost:4200
2. **Navigate to Products**: Click "Products" in nav
3. **Navigate to Cart**: Click "Cart" in nav
4. **Navigate to Auth**: Click "Login" in nav
5. **Check Console**: No errors should appear

## 🐛 If Something Fails

**Port already in use:**
```bash
# Find and kill process
netstat -ano | findstr :4200
taskkill /PID <PID> /F
```

**MFE not loading:**
```bash
# Restart specific MFE
cd mfe-apps\auth-mfe
npm start
```

**Module Federation error:**
```bash
# Clear cache and reinstall
cd mfe-apps\auth-mfe
rmdir /s /q node_modules
npm install
```

## ✅ Success Indicators

- 6 terminal windows open (Shell + 5 MFEs)
- No compilation errors
- Browser shows Shell app at :4200
- Navigation works between pages
- No console errors

## 📊 Architecture Summary

```
Browser (4200)
    ↓
Shell App (Navigation)
    ↓
Loads Remote MFEs (4201-4205)
    ↓
API Gateway (8080)
    ↓
Microservices (8081-8087)
```

## 🎉 You're Done!

Your microfrontend architecture is running!

**Next:** Test navigation and API calls.
