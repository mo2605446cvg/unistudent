import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onPasswordVisibilityToggle;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(bool?) onRememberMeChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;
  final bool isFormValid;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.rememberMe,
    required this.emailError,
    required this.passwordError,
    required this.onPasswordVisibilityToggle,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
    required this.onLogin,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: emailError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: emailController,
              focusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              onChanged: onEmailChanged,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني / الرقم الجامعي',
                hintText: 'أدخل بريدك الإلكتروني',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 3.h,
                ),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),

          // Email Error
          if (emailError != null) ...[
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                emailError!,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],

          SizedBox(height: 3.h),

          // Password Field
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: passwordError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: passwordController,
              focusNode: passwordFocusNode,
              obscureText: !isPasswordVisible,
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              onChanged: onPasswordChanged,
              onFieldSubmitted: (_) {
                if (isFormValid) {
                  onLogin();
                }
              },
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                hintText: 'أدخل كلمة المرور',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: onPasswordVisibilityToggle,
                  icon: CustomIconWidget(
                    iconName:
                        isPasswordVisible ? 'visibility_off' : 'visibility',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 3.h,
                ),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),

          // Password Error
          if (passwordError != null) ...[
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                passwordError!,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],

          SizedBox(height: 2.h),

          // Remember Me and Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Forgot Password
              GestureDetector(
                onTap: isLoading ? null : onForgotPassword,
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              // Remember Me
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تذكرني',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  SizedBox(width: 2.w),
                  Checkbox(
                    value: rememberMe,
                    onChanged: isLoading ? null : onRememberMeChanged,
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Login Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: (isFormValid && !isLoading) ? onLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    AppTheme.lightTheme.colorScheme.outline,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'تسجيل الدخول',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
