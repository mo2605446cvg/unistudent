import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/university_logo_widget.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _showBiometric = false;
  String? _emailError;
  String? _passwordError;

  // Mock credentials for testing
  final List<Map<String, String>> _mockCredentials = [
    {
      "email": "student@university.edu",
      "password": "Student123!",
      "name": "أحمد محمد",
      "role": "student"
    },
    {
      "email": "admin@university.edu",
      "password": "Admin123!",
      "name": "د. فاطمة أحمد",
      "role": "admin"
    },
    {
      "email": "sara.ali@university.edu",
      "password": "Sara123!",
      "name": "سارة علي",
      "role": "student"
    }
  ];

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showBiometric = true;
        });
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'البريد الإلكتروني مطلوب';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$')
          .hasMatch(value)) {
        _emailError = 'البريد الإلكتروني غير صحيح';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'كلمة المرور مطلوبة';
      } else if (value.length < 6) {
        _passwordError = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
      } else {
        _passwordError = null;
      }
    });
  }

  bool _isFormValid() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailError == null &&
        _passwordError == null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check credentials
    final credential = _mockCredentials.firstWhere(
      (cred) =>
          cred['email'] == _emailController.text.trim() &&
          cred['password'] == _passwordController.text,
      orElse: () => {},
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (credential.isNotEmpty) {
        // Success - trigger haptic feedback
        HapticFeedback.lightImpact();

        // Navigate based on role
        if (credential['role'] == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/lecture-schedule');
        }
      } else {
        // Show error
        _showErrorDialog('بيانات الدخول غير صحيحة. يرجى المحاولة مرة أخرى.');
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate biometric authentication
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Simulate successful biometric login
      HapticFeedback.lightImpact();
      Navigator.pushReplacementNamed(context, '/lecture-schedule');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'خطأ في تسجيل الدخول',
          style: AppTheme.lightTheme.textTheme.titleMedium,
          textAlign: TextAlign.right,
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _navigateToRegistration() {
    Navigator.pushNamed(context, '/student-registration');
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'استعادة كلمة المرور',
          style: AppTheme.lightTheme.textTheme.titleMedium,
          textAlign: TextAlign.right,
        ),
        content: Text(
          'سيتم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال رابط الاستعادة'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('إرسال'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 8.h),

                        // University Logo
                        UniversityLogoWidget(),

                        SizedBox(height: 6.h),

                        // Welcome Text
                        Text(
                          'مرحباً بك',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 1.h),

                        Text(
                          'سجل دخولك للوصول إلى حسابك الجامعي',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 4.h),

                        // Login Form
                        LoginFormWidget(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          emailFocusNode: _emailFocusNode,
                          passwordFocusNode: _passwordFocusNode,
                          isPasswordVisible: _isPasswordVisible,
                          isLoading: _isLoading,
                          rememberMe: _rememberMe,
                          emailError: _emailError,
                          passwordError: _passwordError,
                          onPasswordVisibilityToggle: _togglePasswordVisibility,
                          onEmailChanged: _validateEmail,
                          onPasswordChanged: _validatePassword,
                          onRememberMeChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          onForgotPassword: _handleForgotPassword,
                          onLogin: _handleLogin,
                          isFormValid: _isFormValid(),
                        ),

                        SizedBox(height: 3.h),

                        // Biometric Login
                        if (_showBiometric && !_isLoading)
                          BiometricLoginWidget(
                            onBiometricLogin: _handleBiometricLogin,
                          ),

                        const Spacer(),

                        // Registration Link
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'طالب جديد؟ ',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: _navigateToRegistration,
                                child: Text(
                                  'سجل الآن',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
