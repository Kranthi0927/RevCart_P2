package com.revcart.auth.service;

import com.revcart.auth.entity.User;
import com.revcart.auth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Random;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private JavaMailSender mailSender;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public String sendVerificationOTP(String email) {
        String otp = generateOTP();
        User user = userRepository.findByEmail(email).orElseThrow();
        user.setVerificationOtp(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(10));
        userRepository.save(user);
        
        sendEmail(email, "Email Verification OTP", "Your OTP is: " + otp);
        return otp;
    }
    
    public boolean verifyEmail(String email, String otp) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null && otp.equals(user.getVerificationOtp()) && 
            user.getOtpExpiry().isAfter(LocalDateTime.now())) {
            user.setEmailVerified(true);
            user.setVerificationOtp(null);
            user.setOtpExpiry(null);
            userRepository.save(user);
            return true;
        }
        return false;
    }
    
    public String sendPasswordResetOTP(String email) {
        String otp = generateOTP();
        User user = userRepository.findByEmail(email).orElseThrow(() -> 
            new RuntimeException("User not found with email: " + email));
        user.setVerificationOtp(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(10));
        userRepository.save(user);
        
        String emailBody = "Dear User,\n\n" +
                          "Your password reset OTP is: " + otp + "\n\n" +
                          "This OTP is valid for 10 minutes.\n\n" +
                          "If you didn't request this, please ignore this email.\n\n" +
                          "Best regards,\nRevCart Team";
        sendEmail(email, "RevCart - Password Reset OTP", emailBody);
        return otp;
    }
    
    public boolean resetPassword(String email, String otp, String newPassword) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null && otp.equals(user.getVerificationOtp()) && 
            user.getOtpExpiry().isAfter(LocalDateTime.now())) {
            user.setPassword(passwordEncoder.encode(newPassword));
            user.setVerificationOtp(null);
            user.setOtpExpiry(null);
            userRepository.save(user);
            return true;
        }
        return false;
    }
    
    public User updateProfile(Long userId, User updatedUser) {
        User user = userRepository.findById(userId).orElseThrow();
        user.setName(updatedUser.getName());
        user.setPhone(updatedUser.getPhone());
        user.setAddress(updatedUser.getAddress());
        return userRepository.save(user);
    }
    
    private String generateOTP() {
        return String.valueOf(100000 + new Random().nextInt(900000));
    }
    
    private void sendEmail(String to, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("kranthikiran0927@gmail.com");
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            mailSender.send(message);
            System.out.println("✅ Email sent successfully to: " + to);
        } catch (Exception e) {
            System.err.println("❌ Failed to send email to " + to + ": " + e.getMessage());
            throw new RuntimeException("Failed to send email. Please try again.");
        }
    }
}