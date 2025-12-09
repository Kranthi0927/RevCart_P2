# 📧 Email Configuration Guide for RevCart

## Current Configuration

The forgot password feature now sends OTP via email. Email is already configured in `auth-service`.

### Email Settings (application.properties)
```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=kranthikiran0927@gmail.com
spring.mail.password=cmuy atlf wfnt gxgd
```

## ⚠️ Important: Update Email Credentials

For production, you should update the email credentials:

### Option 1: Use Your Gmail Account

1. **Enable 2-Factor Authentication** on your Gmail account
2. **Generate App Password**:
   - Go to Google Account Settings
   - Security → 2-Step Verification → App Passwords
   - Generate password for "Mail"
   - Copy the 16-character password

3. **Update application.properties**:
```properties
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password
```

### Option 2: Use AWS SES (Production Recommended)

```properties
spring.mail.host=email-smtp.us-east-1.amazonaws.com
spring.mail.port=587
spring.mail.username=YOUR_AWS_SMTP_USERNAME
spring.mail.password=YOUR_AWS_SMTP_PASSWORD
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

### Option 3: Use SendGrid

```properties
spring.mail.host=smtp.sendgrid.net
spring.mail.port=587
spring.mail.username=apikey
spring.mail.password=YOUR_SENDGRID_API_KEY
```

## 🧪 Testing Email

### Test Locally

1. Start auth-service:
```bash
cd microservices/auth-service
mvn spring-boot:run
```

2. Test forgot password endpoint:
```bash
curl -X POST http://localhost:8081/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'
```

3. Check your email inbox for OTP

## 📝 Email Template

The OTP email includes:
- 6-digit OTP code
- 10-minute validity
- Professional formatting
- RevCart branding

## 🔒 Security Features

✅ OTP expires after 10 minutes
✅ OTP is hashed in database
✅ OTP is NOT returned in API response
✅ One-time use only
✅ Email validation before sending

## 🎨 Forgot Password UI Features

✅ Professional glassmorphism design
✅ Modal popup for OTP entry
✅ Real-time validation
✅ Loading states
✅ Error/success messages
✅ Responsive design
✅ Password confirmation

## 🚀 How It Works

1. User enters email on forgot password page
2. Backend generates 6-digit OTP
3. OTP saved to database with 10-min expiry
4. Email sent to user with OTP
5. Modal popup appears for OTP entry
6. User enters OTP + new password
7. Backend verifies OTP and updates password
8. User redirected to login

## 📊 Flow Diagram

```
User → Enter Email → Click "Send OTP"
  ↓
Backend → Generate OTP → Save to DB → Send Email
  ↓
User → Receives Email → Opens Modal → Enters OTP + Password
  ↓
Backend → Verify OTP → Update Password → Success
  ↓
User → Redirected to Login
```

## 🐛 Troubleshooting

### Email Not Sending?

1. **Check Gmail Settings**:
   - 2FA enabled?
   - App password generated?
   - Less secure apps disabled?

2. **Check Firewall**:
   - Port 587 open?
   - SMTP not blocked?

3. **Check Logs**:
```bash
# View auth-service logs
tail -f microservices/auth-service/logs/application.log
```

4. **Test SMTP Connection**:
```bash
telnet smtp.gmail.com 587
```

### OTP Not Working?

1. **Check OTP Expiry**: Valid for 10 minutes only
2. **Check Email**: Correct email entered?
3. **Check Database**: OTP saved in users table?

```sql
SELECT email, verification_otp, otp_expiry 
FROM users 
WHERE email = 'test@example.com';
```

## 📧 Email Content Example

```
Subject: RevCart - Password Reset OTP

Dear User,

Your password reset OTP is: 123456

This OTP is valid for 10 minutes.

If you didn't request this, please ignore this email.

Best regards,
RevCart Team
```

## 🔐 Production Recommendations

1. **Use AWS SES or SendGrid** for reliability
2. **Enable email logging** for audit trail
3. **Add rate limiting** to prevent spam
4. **Use HTML email templates** for better UX
5. **Add email verification** before password reset
6. **Implement CAPTCHA** to prevent bots
7. **Add SMS OTP** as backup option

## ✅ Completed Features

✅ Professional forgot password page
✅ Modal popup for OTP entry
✅ Email OTP delivery
✅ OTP verification
✅ Password reset
✅ Error handling
✅ Loading states
✅ Responsive design
✅ Security best practices

---

**Status**: Ready to use! Just update email credentials for production.
