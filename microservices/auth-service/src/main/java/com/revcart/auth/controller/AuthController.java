package com.revcart.auth.controller;

import com.revcart.auth.dto.JwtResponse;
import com.revcart.auth.dto.LoginRequest;
import com.revcart.auth.dto.SignupRequest;
import com.revcart.auth.entity.User;
import com.revcart.auth.repository.UserRepository;
import com.revcart.auth.security.JwtUtils;
import com.revcart.auth.security.UserPrincipal;
import com.revcart.auth.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {
    
    @Autowired
    AuthenticationManager authenticationManager;
    
    @Autowired
    UserRepository userRepository;
    
    @Autowired
    PasswordEncoder encoder;
    
    @Autowired
    JwtUtils jwtUtils;
    
    @Autowired
    UserService userService;
    
    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));
        
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);
        
        UserPrincipal userDetails = (UserPrincipal) authentication.getPrincipal();
        
        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getName(),
                userDetails.getEmail(),
                userRepository.findByEmail(userDetails.getEmail()).get().getRole()));
    }
    
    @PostMapping("/signup")
    @Transactional
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
        try {
            if (userRepository.existsByEmail(signUpRequest.getEmail())) {
                return ResponseEntity.badRequest()
                        .body(Map.of("message", "Error: Email is already in use!"));
            }
            
            User user = new User();
            user.setName(signUpRequest.getName());
            user.setEmail(signUpRequest.getEmail());
            user.setPassword(encoder.encode(signUpRequest.getPassword()));
            user.setPhone(signUpRequest.getPhone());
            user.setAddress(signUpRequest.getAddress());
            user.setRole(signUpRequest.getRole() != null ? signUpRequest.getRole() : User.Role.CUSTOMER);
            
            User savedUser = userRepository.save(user);
            
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(signUpRequest.getEmail(), signUpRequest.getPassword()));
            
            String jwt = jwtUtils.generateJwtToken(authentication);
            UserPrincipal userDetails = (UserPrincipal) authentication.getPrincipal();
            
            return ResponseEntity.ok(new JwtResponse(jwt,
                    userDetails.getId(),
                    userDetails.getName(),
                    userDetails.getEmail(),
                    savedUser.getRole()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Error creating user: " + e.getMessage()));
        }
    }
    
    @PostMapping("/send-verification-otp")
    public ResponseEntity<?> sendVerificationOTP(@RequestBody Map<String, String> request) {
        try {
            String otp = userService.sendVerificationOTP(request.get("email"));
            return ResponseEntity.ok(Map.of("message", "OTP sent successfully", "otp", otp));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Error sending OTP: " + e.getMessage()));
        }
    }
    
    @PostMapping("/verify-email")
    public ResponseEntity<?> verifyEmail(@RequestBody Map<String, String> request) {
        try {
            boolean verified = userService.verifyEmail(request.get("email"), request.get("otp"));
            if (verified) {
                return ResponseEntity.ok(Map.of("message", "Email verified successfully"));
            } else {
                return ResponseEntity.badRequest().body(Map.of("message", "Invalid or expired OTP"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Error verifying email: " + e.getMessage()));
        }
    }
    
    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody Map<String, String> request) {
        try {
            userService.sendPasswordResetOTP(request.get("email"));
            return ResponseEntity.ok(Map.of("message", "Password reset OTP sent to your email successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }
    
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> request) {
        try {
            boolean reset = userService.resetPassword(
                request.get("email"), 
                request.get("otp"), 
                request.get("newPassword")
            );
            if (reset) {
                return ResponseEntity.ok(Map.of("message", "Password reset successfully"));
            } else {
                return ResponseEntity.badRequest().body(Map.of("message", "Invalid or expired OTP"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Error resetting password: " + e.getMessage()));
        }
    }
    
    @GetMapping("/oauth2/google")
    public ResponseEntity<?> getGoogleOAuth2Url() {
        return ResponseEntity.ok(Map.of("url", "http://localhost:8080/api/oauth2/authorization/google"));
    }
}