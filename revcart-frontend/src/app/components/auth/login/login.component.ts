import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { AuthService, LoginRequest } from '../../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  loginData: LoginRequest = {
    email: '',
    password: ''
  };
  
  loading = false;
  
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}
  
  onLogin() {
    if (!this.loginData.email || !this.loginData.password) {
      alert('Please fill in all fields');
      return;
    }
    
    this.loading = true;
    
    this.authService.login(this.loginData).subscribe({
      next: (response) => {
        this.loading = false;
        alert('Login successful!');
        this.router.navigate(['/home']);
      },
      error: (error) => {
        this.loading = false;
        console.error('Login failed:', error);
        if (error.status === 401 || error.status === 403) {
          alert('Invalid credentials');
        } else if (error.status === 0) {
          alert('Cannot connect to server');
        } else {
          alert('Invalid credentials');
        }
      }
    });
  }
}