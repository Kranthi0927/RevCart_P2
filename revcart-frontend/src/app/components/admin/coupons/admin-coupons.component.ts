import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { CouponService } from '../../../services/coupon.service';
import { Coupon } from '../../../models/coupon.model';

@Component({
  selector: 'app-admin-coupons',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-coupons.component.html',
  styleUrls: ['./admin-coupons.component.css']
})
export class AdminCouponsComponent implements OnInit {
  coupons: Coupon[] = [];
  showForm = false;
  editMode = false;
  currentCoupon: Coupon = this.getEmptyCoupon();

  constructor(private couponService: CouponService) {}

  ngOnInit() {
    this.loadCoupons();
  }

  loadCoupons() {
    this.couponService.getAllCoupons().subscribe({
      next: (data) => this.coupons = data,
      error: (err) => console.error('Error loading coupons:', err)
    });
  }

  getEmptyCoupon(): Coupon {
    return {
      code: '',
      description: '',
      discountType: 'PERCENTAGE',
      discountValue: 0,
      active: true
    };
  }

  openCreateForm() {
    this.editMode = false;
    this.currentCoupon = this.getEmptyCoupon();
    this.showForm = true;
  }

  openEditForm(coupon: Coupon) {
    this.editMode = true;
    this.currentCoupon = { ...coupon };
    this.showForm = true;
  }

  closeForm() {
    this.showForm = false;
    this.currentCoupon = this.getEmptyCoupon();
  }

  saveCoupon() {
    if (this.editMode && this.currentCoupon.id) {
      this.couponService.updateCoupon(this.currentCoupon.id, this.currentCoupon).subscribe({
        next: () => {
          this.loadCoupons();
          this.closeForm();
          alert('Coupon updated successfully');
        },
        error: (err) => alert('Error updating coupon: ' + err.error.message)
      });
    } else {
      this.couponService.createCoupon(this.currentCoupon).subscribe({
        next: () => {
          this.loadCoupons();
          this.closeForm();
          alert('Coupon created successfully');
        },
        error: (err) => alert('Error creating coupon: ' + err.error.message)
      });
    }
  }

  deleteCoupon(id: number) {
    if (confirm('Are you sure you want to delete this coupon?')) {
      this.couponService.deleteCoupon(id).subscribe({
        next: () => {
          this.loadCoupons();
          alert('Coupon deleted successfully');
        },
        error: (err) => alert('Error deleting coupon: ' + err.error.message)
      });
    }
  }

  toggleStatus(coupon: Coupon) {
    coupon.active = !coupon.active;
    if (coupon.id) {
      this.couponService.updateCoupon(coupon.id, coupon).subscribe({
        next: () => alert('Coupon status updated'),
        error: (err) => alert('Error updating status: ' + err.error.message)
      });
    }
  }
}
