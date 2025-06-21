import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_picture_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/terms_checkbox_widget.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({super.key});

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _fullNameController = TextEditingController();
  final _universityCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAccepted = false;
  bool _isLoading = false;
  String? _profileImagePath;

  // Validation states
  String? _fullNameError;
  String? _universityCodeError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _universityCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _fullNameController.text.isNotEmpty &&
        _universityCodeController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _isTermsAccepted &&
        _fullNameError == null &&
        _universityCodeError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  void _validateFullName(String value) {
    setState(() {
      if (value.isEmpty) {
        _fullNameError = 'الاسم الكامل مطلوب';
      } else if (value.length < 2) {
        _fullNameError = 'الاسم يجب أن يكون أكثر من حرفين';
      } else {
        _fullNameError = null;
      }
    });
  }

  void _validateUniversityCode(String value) {
    setState(() {
      if (value.isEmpty) {
        _universityCodeError = 'رمز الجامعة مطلوب';
      } else if (value.length < 6) {
        _universityCodeError = 'رمز الجامعة يجب أن يكون 6 أرقام على الأقل';
      } else if (!RegExp(r'^[0-9]+\$').hasMatch(value)) {
        _universityCodeError = 'رمز الجامعة يجب أن يحتوي على أرقام فقط';
      } else {
        _universityCodeError = null;
      }
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
      } else if (value.length < 8) {
        _passwordError = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
      } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
        _passwordError =
            'كلمة المرور يجب أن تحتوي على حروف كبيرة وصغيرة وأرقام';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'تأكيد كلمة المرور مطلوب';
      } else if (value != _passwordController.text) {
        _confirmPasswordError = 'كلمة المرور غير متطابقة';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration logic
      final mockUsers = [
        {'email': 'admin@university.edu', 'code': '123456'},
        {'email': 'student@university.edu', 'code': '654321'},
      ];

      bool userExists = mockUsers.any((user) =>
          user['email'] == _emailController.text ||
          user['code'] == _universityCodeController.text);

      if (userExists) {
        _showErrorDialog('المستخدم موجود بالفعل',
            'البريد الإلكتروني أو رمز الجامعة مستخدم من قبل');
        return;
      }

      // Success feedback
      HapticFeedback.lightImpact();
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog(
          'خطأ في الشبكة', 'تعذر الاتصال بالخادم. يرجى المحاولة مرة أخرى');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, textDirection: TextDirection.rtl),
        content: Text(message, textDirection: TextDirection.rtl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('تم إنشاء الحساب بنجاح',
            textDirection: TextDirection.rtl),
        content: const Text('سيتم توجيهك إلى شاشة التحقق',
            textDirection: TextDirection.rtl),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/student-login');
            },
            child: const Text('متابعة', textDirection: TextDirection.rtl),
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
          child: Column(
            children: [
              // Header with progress indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.shadowColor,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 6.w,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'إنشاء حساب جديد',
                            style: AppTheme.lightTheme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8.w,
                                height: 0.5.h,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 8.w,
                                height: 0.5.h,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.dividerColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'الخطوة 1 من 2',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w), // Balance the back button
                  ],
                ),
              ),

              // Scrollable form content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 2.h),

                        // Profile picture section
                        ProfilePictureWidget(
                          imagePath: _profileImagePath,
                          onImageSelected: (path) {
                            setState(() {
                              _profileImagePath = path;
                            });
                          },
                        ),

                        SizedBox(height: 4.h),

                        // Registration form
                        RegistrationFormWidget(
                          fullNameController: _fullNameController,
                          universityCodeController: _universityCodeController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          isPasswordVisible: _isPasswordVisible,
                          isConfirmPasswordVisible: _isConfirmPasswordVisible,
                          fullNameError: _fullNameError,
                          universityCodeError: _universityCodeError,
                          emailError: _emailError,
                          passwordError: _passwordError,
                          confirmPasswordError: _confirmPasswordError,
                          onFullNameChanged: _validateFullName,
                          onUniversityCodeChanged: _validateUniversityCode,
                          onEmailChanged: _validateEmail,
                          onPasswordChanged: _validatePassword,
                          onConfirmPasswordChanged: _validateConfirmPassword,
                          onPasswordVisibilityToggle: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          onConfirmPasswordVisibilityToggle: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Terms and conditions
                        TermsCheckboxWidget(
                          isAccepted: _isTermsAccepted,
                          onChanged: (value) {
                            setState(() {
                              _isTermsAccepted = value ?? false;
                            });
                          },
                        ),

                        SizedBox(height: 4.h),

                        // Create account button
                        SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: _isFormValid && !_isLoading
                                ? _handleRegistration
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isFormValid
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.dividerColor,
                              foregroundColor: Colors.white,
                              elevation: _isFormValid ? 2 : 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 5.w,
                                    height: 5.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'إنشاء الحساب',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لديك حساب بالفعل؟ ',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, '/student-login'),
                              child: Text(
                                'تسجيل الدخول',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
