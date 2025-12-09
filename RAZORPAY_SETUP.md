# Razorpay Integration Setup Guide

## Step 1: Get Razorpay API Keys

1. Go to https://razorpay.com/
2. Sign up / Login
3. Navigate to **Settings** → **API Keys**
4. Click **Generate Test Key** (for testing)
5. Copy **Key ID** (starts with `rzp_test_`)
6. Copy **Key Secret**

## Step 2: Update Configuration

Edit: `microservices/payment-service/src/main/resources/application.properties`

Replace these lines:
```properties
razorpay.key-id=rzp_test_YOUR_KEY_ID
razorpay.key-secret=YOUR_KEY_SECRET
```

With your actual keys from Razorpay dashboard.

## Step 3: Restart Payment Service

```bash
cd microservices/payment-service
mvn clean install
mvn spring-boot:run
```

## Step 4: Test Razorpay Integration

### Create Razorpay Order:
```bash
curl -X POST http://localhost:8080/api/payments/razorpay/create-order \
  -H "Content-Type: application/json" \
  -d '{
    "orderId": 1,
    "amount": 500.00,
    "currency": "INR"
  }'
```

Response:
```json
{
  "razorpayOrderId": "order_xxxxx",
  "razorpayKeyId": "rzp_test_xxxxx",
  "amount": 500.0,
  "currency": "INR",
  "orderId": 1
}
```

## Step 5: Frontend Integration (Next Steps)

### Install Razorpay Checkout in Angular:

```bash
cd revcart-frontend
npm install --save @types/razorpay
```

### Add Razorpay Script to index.html:

```html
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
```

### Create Payment Service in Angular:

```typescript
// payment.service.ts
createRazorpayOrder(orderId: number, amount: number) {
  return this.http.post(`${environment.apiUrl}/payments/razorpay/create-order`, {
    orderId,
    amount,
    currency: 'INR'
  });
}

verifyPayment(verification: any) {
  return this.http.post(`${environment.apiUrl}/payments/razorpay/verify`, verification);
}
```

### Integrate in Checkout Component:

```typescript
payWithRazorpay() {
  this.paymentService.createRazorpayOrder(this.orderId, this.totalAmount)
    .subscribe((response: any) => {
      const options = {
        key: response.razorpayKeyId,
        amount: response.amount * 100,
        currency: response.currency,
        name: 'RevCart',
        description: 'Order Payment',
        order_id: response.razorpayOrderId,
        handler: (paymentResponse: any) => {
          this.verifyPayment({
            razorpayOrderId: response.razorpayOrderId,
            razorpayPaymentId: paymentResponse.razorpay_payment_id,
            razorpaySignature: paymentResponse.razorpay_signature,
            orderId: this.orderId
          });
        }
      };
      
      const rzp = new (window as any).Razorpay(options);
      rzp.open();
    });
}
```

## Test Cards (Razorpay Test Mode)

- **Success:** 4111 1111 1111 1111
- **CVV:** Any 3 digits
- **Expiry:** Any future date

## API Endpoints

- **Create Order:** `POST /api/payments/razorpay/create-order`
- **Verify Payment:** `POST /api/payments/razorpay/verify`

## Important Notes

- Use **Test Keys** for development
- Switch to **Live Keys** for production
- Never expose keys in frontend code
- Always verify payment signature on backend
