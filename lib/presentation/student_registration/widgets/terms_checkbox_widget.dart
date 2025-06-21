import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TermsCheckboxWidget extends StatelessWidget {
  final bool isAccepted;
  final Function(bool?) onChanged;

  const TermsCheckboxWidget({
    super.key,
    required this.isAccepted,
    required this.onChanged,
  });

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'الشروط والأحكام',
          textDirection: TextDirection.rtl,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'شروط استخدام تطبيق UniStudent',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 2.h),
              Text(
                '1. قبول الشروط: باستخدام هذا التطبيق، فإنك توافق على الالتزام بهذه الشروط والأحكام.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 1.h),
              Text(
                '2. استخدام البيانات: نحن نحترم خصوصيتك ونحمي بياناتك الشخصية وفقاً لسياسة الخصوصية.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 1.h),
              Text(
                '3. المسؤولية: أنت مسؤول عن الحفاظ على سرية معلومات حسابك.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 1.h),
              Text(
                '4. الاستخدام المقبول: يجب استخدام التطبيق للأغراض التعليمية فقط.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'سياسة الخصوصية',
          textDirection: TextDirection.rtl,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سياسة خصوصية تطبيق UniStudent',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 2.h),
              Text(
                '1. جمع البيانات: نجمع المعلومات الضرورية لتقديم الخدمات التعليمية.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 1.h),
              Text(
                '2. استخدام البيانات: نستخدم بياناتك لتحسين تجربتك التعليمية.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 1.h),
              Text(
                '3. حماية البيانات: نطبق أعلى معايير الأمان لحماية معلوماتك.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 1.h),
              Text(
                '4. مشاركة البيانات: لا نشارك بياناتك مع أطراف ثالثة دون موافقتك.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: isAccepted,
                onChanged: onChanged,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                checkColor: Colors.white,
                side: BorderSide(
                  color: isAccepted
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.dividerColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.5.h),
                  RichText(
                    textDirection: TextDirection.rtl,
                    text: TextSpan(
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: 'أوافق على '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => _showTermsDialog(context),
                            child: Text(
                              'الشروط والأحكام',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' و '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => _showPrivacyDialog(context),
                            child: Text(
                              'سياسة الخصوصية',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' *'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isAccepted) ...[
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Text(
              'يجب الموافقة على الشروط والأحكام للمتابعة',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ],
    );
  }
}
