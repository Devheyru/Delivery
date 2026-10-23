import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minoo_deleivery/services/auth/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Step indicator: 1 = Enter Email, 2 = Enter OTP, 3 = New Password, 4 = Success
  int _currentStep = 1;

  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Resend countdown timer
  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  String get _enteredOtp =>
      _otpControllers.map((c) => c.text.trim()).join();

  // STEP 1: Request OTP
  Future<void> _handleRequestOtp() async {
    final email = _emailController.text.trim();
    final validationError = AuthService.validateEmail(email);
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthService.generateAndSendEmailOtp(email);
      _startResendTimer();
      setState(() {
        _isLoading = false;
        _currentStep = 2;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xfff59e0b),
            content: Text('Verification code sent to $email'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = AuthService.parseAuthError(e);
      });
    }
  }

  // STEP 2: Verify OTP
  Future<void> _handleVerifyOtp() async {
    final otp = _enteredOtp;
    if (otp.length != 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits of the code');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final isValid = await AuthService.verifyEmailOtp(
        email: email,
        enteredOtp: otp,
      );

      if (isValid) {
        setState(() {
          _isLoading = false;
          _currentStep = 3;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // STEP 3: Reset Password
  Future<void> _handleResetPassword() async {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      await AuthService.resetPasswordWithOtp(
        email: email,
        newPassword: password,
      );

      setState(() {
        _isLoading = false;
        _currentStep = 4;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = AuthService.parseAuthError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {
            if (_currentStep > 1 && _currentStep < 4) {
              setState(() {
                _currentStep--;
                _errorMessage = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          "Reset Password",
          style: TextStyle(
            color: Color(0xFF3C2F2F),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Step Indicators
              _buildStepIndicator(),
              const SizedBox(height: 30),

              // Step Content
              if (_currentStep == 1) _buildEmailStep(),
              if (_currentStep == 2) _buildOtpStep(),
              if (_currentStep == 3) _buildNewPasswordStep(),
              if (_currentStep == 4) _buildSuccessStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _indicatorDot(step: 1, label: 'Email'),
        _indicatorLine(isActive: _currentStep >= 2),
        _indicatorDot(step: 2, label: 'Code'),
        _indicatorLine(isActive: _currentStep >= 3),
        _indicatorDot(step: 3, label: 'Password'),
      ],
    );
  }

  Widget _indicatorDot({required int step, required String label}) {
    final isDone = _currentStep > step;
    final isCurrent = _currentStep == step;
    final color = (isDone || isCurrent) ? const Color(0xfff59e0b) : Colors.grey.shade300;

    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: isDone
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  '$step',
                  style: TextStyle(
                    color: isCurrent ? Colors.white : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isCurrent ? const Color(0xfff59e0b) : Colors.grey.shade600,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _indicatorLine({required bool isActive}) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
      color: isActive ? const Color(0xfff59e0b) : Colors.grey.shade300,
    );
  }

  // STEP 1 WIDGET
  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xfff59e0b).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              size: 56,
              color: Color(0xfff59e0b),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            "Forgot Your Password?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C2F2F),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            "Enter your registered email address and we'll send you a 6-digit OTP code to reset your password.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
          ),
        ),
        const SizedBox(height: 28),

        const Text(
          'Email Address',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "example@mail.com",
              prefixIcon: Icon(Icons.mail_outline, color: Color(0xfff59e0b)),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        if (_errorMessage != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 28),
        _actionButton(
          label: "Send 6-Digit Code",
          onPressed: _handleRequestOtp,
        ),
      ],
    );
  }

  // STEP 2 WIDGET (OTP INPUT)
  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xfff59e0b).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size: 56,
            color: Color(0xfff59e0b),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Enter Verification Code",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3C2F2F),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We sent a 6-digit verification code to:\n${_emailController.text.trim()}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 28),

        // 6 OTP Box Inputs
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 44,
              height: 54,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C2F2F),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFececf8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xfff59e0b), width: 2),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _otpFocusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _otpFocusNodes[index - 1].requestFocus();
                  }
                  if (_enteredOtp.length == 6) {
                    _handleVerifyOtp();
                  }
                },
              ),
            );
          }),
        ),

        if (_errorMessage != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),
        // Resend countdown
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            if (!_canResend)
              Text(
                "Resend in ${_resendCountdown}s",
                style: const TextStyle(
                  color: Color(0xfff59e0b),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              )
            else
              TextButton(
                onPressed: _handleRequestOtp,
                child: const Text(
                  "Resend Code",
                  style: TextStyle(
                    color: Color(0xfff59e0b),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 24),
        _actionButton(
          label: "Verify Code",
          onPressed: _handleVerifyOtp,
        ),
      ],
    );
  }

  // STEP 3 WIDGET (NEW PASSWORD)
  Widget _buildNewPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xfff59e0b).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 56,
              color: Color(0xfff59e0b),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            "Create New Password",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C2F2F),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            "Your new password must be at least 6 characters long.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 28),

        const Text('New Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter at least 6 characters",
              prefixIcon: const Icon(Icons.password_outlined, color: Color(0xfff59e0b)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text('Confirm New Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Re-enter new password",
              prefixIcon: const Icon(Icons.password_outlined, color: Color(0xfff59e0b)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        if (_errorMessage != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 28),
        _actionButton(
          label: "Update Password",
          onPressed: _handleResetPassword,
        ),
      ],
    );
  }

  // STEP 4 WIDGET (SUCCESS)
  Widget _buildSuccessStep() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            size: 80,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Password Changed!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3C2F2F),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Your password has been reset successfully.\nYou can now log in with your new credentials.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 36),
        _actionButton(
          label: "Back to LogIn",
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/logIn', (route) => false),
        ),
      ],
    );
  }

  Widget _actionButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xfff59e0b),
          elevation: 3,
          shadowColor: const Color(0xfff59e0b).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _isLoading ? null : onPressed,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}
