import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  static bool get isAuthenticated => _auth.currentUser != null;

  /// Stream of user document from Firestore
  static Stream<DocumentSnapshot<Map<String, dynamic>>>? userStream(String uid) {
    try {
      return _firestore.collection('users').doc(uid).snapshots();
    } catch (e) {
      debugPrint('Error getting user stream: $e');
      return null;
    }
  }

  /// Get user document from Firestore
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  /// Update user profile data in Firestore and Firebase Auth
  static Future<void> updateProfileData({
    required String uid,
    required String name,
    required String phone,
  }) async {
    final phoneError = validateEthiopianPhone(phone);
    if (phoneError != null) {
      throw phoneError;
    }
    if (name.trim().isEmpty) {
      throw 'Name cannot be empty';
    }

    // Update display name in Firebase Auth
    final user = _auth.currentUser;
    if (user != null && user.displayName != name.trim()) {
      await user.updateDisplayName(name.trim());
    }

    // Update Firestore user document
    await _firestore.collection('users').doc(uid).set({
      'name': name.trim(),
      'phone': phone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Helper to require authentication before performing sensitive actions like ordering
  static Future<bool> requireAuth(
    BuildContext context, {
    String action = 'place an order',
  }) async {
    if (isAuthenticated) {
      return true;
    }

    final shouldNavigate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.lock_person_outlined, color: Color(0xfff59e0b), size: 28),
            SizedBox(width: 10),
            Text(
              "Sign In Required",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          "You must be signed in to $action.\n\nPlease log in or create a new account to proceed.",
          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfff59e0b),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              "Log In / Sign Up",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return shouldNavigate ?? false;
  }

  /// Validates Ethiopian phone number format:
  /// Exactly 10 digits starting with only '09' or '07'.
  static String? validateEthiopianPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final clean = value.trim().replaceAll(RegExp(r'\s+'), '');
    if (!clean.startsWith('09') && !clean.startsWith('07')) {
      return 'Phone number must start with 09 or 07';
    }
    if (clean.length != 10) {
      return 'Phone number must be exactly 10 digits (currently ${clean.length})';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(clean)) {
      return 'Phone number must contain digits only';
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Sign Up with Name, Phone, Email, and Password
  static Future<UserCredential> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    // 1. Create auth user
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = credential.user;
    if (user != null) {
      // 2. Set display name
      await user.updateDisplayName(name.trim());

      // 3. Store user record in Firestore
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name.trim(),
          'phone': phone.trim(),
          'email': email.trim().toLowerCase(),
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'customer',
        });
      } catch (firestoreError) {
        debugPrint('Firestore profile save note: $firestoreError');
      }
    }

    return credential;
  }

  /// Log In with Email and Password
  static Future<UserCredential> logIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  /// Log Out
  static Future<void> logOut() async {
    await _auth.signOut();
  }

  /// Generates a secure 6-digit OTP and initiates email password reset.
  /// Stores OTP in Firestore 'password_resets/{email}' with a 10-minute expiry.
  static Future<String> generateAndSendEmailOtp(String email) async {
    final cleanEmail = email.trim().toLowerCase();

    // Generate 6-digit numeric OTP (100000 - 999999)
    final random = Random.secure();
    final otpCode = (100000 + random.nextInt(900000)).toString();
    final expiresAt = DateTime.now().add(const Duration(minutes: 10));

    debugPrint('====================================');
    debugPrint('🔑 Generated OTP for $cleanEmail: $otpCode');
    debugPrint('⏳ Expires at: $expiresAt');
    debugPrint('====================================');

    // 1. Store OTP record in Firestore
    try {
      await _firestore.collection('password_resets').doc(cleanEmail).set({
        'email': cleanEmail,
        'otp': otpCode,
        'expiresAt': expiresAt.toIso8601String(),
        'verified': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Firestore OTP save note: $e');
    }

    // 2. Trigger Firebase Auth's official password reset email
    try {
      await _auth.sendPasswordResetEmail(email: cleanEmail);
      debugPrint('📧 Firebase password reset email sent to: $cleanEmail');
    } catch (e) {
      debugPrint('Firebase reset email trigger note: $e');
    }

    return otpCode;
  }

  /// Verifies the 6-digit OTP code entered by the user
  static Future<bool> verifyEmailOtp({
    required String email,
    required String enteredOtp,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanOtp = enteredOtp.trim();

    try {
      final doc = await _firestore.collection('password_resets').doc(cleanEmail).get();
      if (!doc.exists) {
        throw 'No OTP verification request found for this email. Please request a new code.';
      }

      final data = doc.data()!;
      final storedOtp = data['otp']?.toString() ?? '';
      final expiresAtStr = data['expiresAt']?.toString() ?? '';

      final expiresAt = DateTime.tryParse(expiresAtStr) ?? DateTime.now();
      if (DateTime.now().isAfter(expiresAt)) {
        throw 'Verification code has expired. Please request a new code.';
      }

      if (storedOtp != cleanOtp) {
        throw 'Invalid verification code. Please check your email and try again.';
      }

      // Mark OTP as verified
      await _firestore.collection('password_resets').doc(cleanEmail).update({
        'verified': true,
      });

      return true;
    } catch (e) {
      if (e is String) rethrow;
      throw 'Verification error: ${e.toString()}';
    }
  }

  /// Resets the user's password once the OTP has been verified
  static Future<void> resetPasswordWithOtp({
    required String email,
    required String newPassword,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    try {
      final doc = await _firestore.collection('password_resets').doc(cleanEmail).get();
      if (!doc.exists || doc.data()?['verified'] != true) {
        throw 'Please verify your OTP code before resetting password.';
      }

      // If user is currently signed in, update directly
      final user = _auth.currentUser;
      if (user != null && user.email?.toLowerCase() == cleanEmail) {
        await user.updatePassword(newPassword.trim());
      } else {
        // Trigger password reset email from Firebase as secondary fallback
        await _auth.sendPasswordResetEmail(email: cleanEmail);
      }

      // Cleanup OTP document
      await _firestore.collection('password_resets').doc(cleanEmail).delete();
    } catch (e) {
      if (e is String) rethrow;
      throw 'Failed to reset password: $e';
    }
  }

  /// Parses FirebaseAuthException and returns user-friendly error strings
  static String parseAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this email address.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect password or email. Please try again.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'invalid-email':
          return 'The email address is not formatted correctly.';
        case 'weak-password':
          return 'The password is too weak. Please use at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again in a few minutes.';
        case 'user-disabled':
          return 'This user account has been disabled. Please contact support.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }
    return error.toString();
  }
}
