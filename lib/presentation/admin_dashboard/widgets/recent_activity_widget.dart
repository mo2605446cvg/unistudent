import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityWidget({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'النشاط الأخير',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('عرض جميع الأنشطة غير متاح حالياً'),
                    backgroundColor: AppTheme.warningLight,
                  ),
                );
              },
              child: Text('عرض الكل'),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 4 ? 4 : activities.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.dividerLight,
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(activity, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      Map<String, dynamic> activity, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: _getActivityColor(activity["type"] as String)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: CustomIconWidget(
          iconName: _getActivityIcon(activity["type"] as String),
          color: _getActivityColor(activity["type"] as String),
          size: 6.w,
        ),
      ),
      title: Text(
        activity["action"] as String,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5.h),
          Text(
            activity["description"] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.textSecondaryLight,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                activity["timestamp"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(width: 3.w),
              CustomIconWidget(
                iconName: 'people',
                color: AppTheme.textSecondaryLight,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                '${activity["affectedCount"]} طالب',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_left',
        color: AppTheme.textSecondaryLight,
        size: 5.w,
      ),
      onTap: () {
        _showActivityDetails(activity, context);
      },
    );
  }

  String _getActivityIcon(String type) {
    switch (type) {
      case 'announcement':
        return 'campaign';
      case 'file':
        return 'cloud_upload';
      case 'student':
        return 'people';
      case 'message':
        return 'message';
      default:
        return 'info';
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'announcement':
        return AppTheme.lightTheme.primaryColor;
      case 'file':
        return AppTheme.accentLight;
      case 'student':
        return AppTheme.successLight;
      case 'message':
        return AppTheme.warningLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  void _showActivityDetails(
      Map<String, dynamic> activity, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity["action"] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الوصف:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(activity["description"] as String),
            SizedBox(height: 2.h),
            Text(
              'التوقيت:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(activity["timestamp"] as String),
            SizedBox(height: 2.h),
            Text(
              'عدد الطلاب المتأثرين:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text('${activity["affectedCount"]} طالب'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
