import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController universityCodeController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String? fullNameError;
  final String? universityCodeError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final Function(String) onFullNameChanged;
  final Function(String) onUniversityCodeChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onConfirmPasswordChanged;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;

  const RegistrationFormWidget({
    super.key,
    required this.fullNameController,
    required this.universityCodeController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    this.fullNameError,
    this.universityCodeError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    required this.onFullNameChanged,
    required this.onUniversityCodeChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
  });

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    String? errorText,
    String? helperText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          textDirection: TextDirection.rtl,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintTextDirection: TextDirection.rtl,
            suffixIcon: suffixIcon,
            errorText: errorText,
            helperText: helperText,
            helperMaxLines: 2,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.error,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'ضعيف';
    if (password.length < 8) return 'متوسط';
    if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@\$!%*?&])')
        .hasMatch(password)) {
      return 'قوي جداً';
    }
    if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      return 'قوي';
    }
    return 'متوسط';
  }

  Color _getPasswordStrengthColor(String strength) {
    switch (strength) {
      case 'ضعيف':
        return AppTheme.lightTheme.colorScheme.error;
      case 'متوسط':
        return AppTheme.warningLight;
      case 'قوي':
        return AppTheme.successLight;
      case 'قوي جداً':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.dividerColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordStrength = _getPasswordStrength(passwordController.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        _buildFormField(
          label: 'الاسم الكامل *',
          hint: 'أدخل اسمك الكامل',
          controller: fullNameController,
          onChanged: onFullNameChanged,
          errorText: fullNameError,
          keyboardType: TextInputType.name,
        ),

        // University Code Field
        _buildFormField(
          label: 'رمز الجامعة *',
          hint: 'أدخل رمز الجامعة (6 أرقام)',
          controller: universityCodeController,
          onChanged: onUniversityCodeChanged,
          errorText: universityCodeError,
          helperText: 'رمز الجامعة المكون من 6 أرقام الموجود في بطاقة الطالب',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),

        // Email Field
        _buildFormField(
          label: 'البريد الإلكتروني *',
          hint: 'أدخل بريدك الإلكتروني',
          controller: emailController,
          onChanged: onEmailChanged,
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
        ),

        // Password Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'كلمة المرور *',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: passwordController,
              onChanged: onPasswordChanged,
              obscureText: !isPasswordVisible,
              textDirection: TextDirection.rtl,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'أدخل كلمة مرور قوية',
                hintTextDirection: TextDirection.rtl,
                errorText: passwordError,
                suffixIcon: GestureDetector(
                  onTap: onPasswordVisibilityToggle,
                  child: CustomIconWidget(
                    iconName:
                        isPasswordVisible ? 'visibility_off' : 'visibility',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.error,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.error,
                    width: 2,
                  ),
                ),
              ),
            ),
            if (passwordController.text.isNotEmpty) ...[
              SizedBox(height: 1.h),
              Row(
                children: [
                  Text(
                    'قوة كلمة المرور: ',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    passwordStrength,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getPasswordStrengthColor(passwordStrength),
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ],
            SizedBox(height: 3.h),
          ],
        ),

        // Confirm Password Field
        _buildFormField(
          label: 'تأكيد كلمة المرور *',
          hint: 'أعد إدخال كلمة المرور',
          controller: confirmPasswordController,
          onChanged: onConfirmPasswordChanged,
          errorText: confirmPasswordError,
          obscureText: !isConfirmPasswordVisible,
          suffixIcon: GestureDetector(
            onTap: onConfirmPasswordVisibilityToggle,
            child: CustomIconWidget(
              iconName:
                  isConfirmPasswordVisible ? 'visibility_off' : 'visibility',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
        ),
      ],
    );
  }
}
