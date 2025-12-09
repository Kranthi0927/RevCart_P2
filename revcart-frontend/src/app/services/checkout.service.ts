import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { ProductService } from './product.service';
import { CartItem } from './cart.service';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CheckoutService {

  constructor(
    private productService: ProductService,
    private http: HttpClient
  ) {}

  processOrder(cartItems: CartItem[]): Observable<{ success: boolean; message?: string }> {
    return of({ success: true });
  }
  
  saveOrder(orderData: any): Observable<any> {
    return this.http.post(`${environment.apiUrl}/orders`, orderData);
  }
  
  getUserOrders(): Observable<any[]> {
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    const headers = { 'userId': user.id?.toString() || '0' };
    return this.http.get<any[]>(`${environment.apiUrl}/orders/user`, { headers });
  }
  
  getAllOrders(): Observable<any[]> {
    return this.http.get<any[]>(`${environment.apiUrl}/orders/admin`);
  }
}