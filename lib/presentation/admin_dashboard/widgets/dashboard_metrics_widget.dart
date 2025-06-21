import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const DashboardMetricsWidget({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إحصائيات سريعة',
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
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard(
              title: 'إجمالي الطلاب',
              value: '${metrics["totalStudents"]}',
              icon: 'people',
              color: AppTheme.lightTheme.primaryColor,
              context: context,
            ),
            _buildMetricCard(
              title: 'الإعلانات النشطة',
              value: '${metrics["activeAnnouncements"]}',
              icon: 'campaign',
              color: AppTheme.accentLight,
              context: context,
            ),
            _buildMetricCard(
              title: 'الملفات المعلقة',
              value: '${metrics["pendingUploads"]}',
              icon: 'cloud_upload',
              color: AppTheme.warningLight,
              context: context,
            ),
            _buildMetricCard(
              title: 'النشاط الأخير',
              value: '${metrics["recentActivity"]}',
              icon: 'timeline',
              color: AppTheme.successLight,
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 6.w,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
