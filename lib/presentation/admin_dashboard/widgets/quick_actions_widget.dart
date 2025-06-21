import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final Function(String) onActionTap;

  const QuickActionsWidget({
    super.key,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجراءات سريعة',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              title: 'إرسال إعلان',
              subtitle: 'إرسال إعلان جديد للطلاب',
              icon: 'campaign',
              color: AppTheme.lightTheme.primaryColor,
              onTap: () => onActionTap('announcement'),
            ),
            _buildActionCard(
              title: 'رفع ملفات',
              subtitle: 'رفع ملفات ومستندات',
              icon: 'cloud_upload',
              color: AppTheme.accentLight,
              onTap: () => onActionTap('upload'),
            ),
            _buildActionCard(
              title: 'إدارة الطلاب',
              subtitle: 'عرض وإدارة بيانات الطلاب',
              icon: 'people',
              color: AppTheme.successLight,
              onTap: () => onActionTap('students'),
            ),
            _buildActionCard(
              title: 'التحليلات',
              subtitle: 'عرض الإحصائيات والتقارير',
              icon: 'analytics',
              color: AppTheme.warningLight,
              onTap: () => onActionTap('analytics'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 7.w,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
