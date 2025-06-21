import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LectureBlockWidget extends StatelessWidget {
  final Map<String, dynamic> lecture;
  final VoidCallback onTap;
  final bool isCurrentTime;

  const LectureBlockWidget({
    super.key,
    required this.lecture,
    required this.onTap,
    this.isCurrentTime = false,
  });

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              lecture["courseName"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem(
              context,
              'إضافة للتقويم',
              'event',
              () {
                Navigator.pop(context);
                // Add to calendar functionality
              },
            ),
            _buildContextMenuItem(
              context,
              'تعيين تذكير',
              'notifications',
              () {
                Navigator.pop(context);
                // Set reminder functionality
              },
            ),
            _buildContextMenuItem(
              context,
              'عرض المنهج',
              'description',
              () {
                Navigator.pop(context);
                // View syllabus functionality
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        size: 24,
        color: AppTheme.lightTheme.primaryColor,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(lecture["color"] as int);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showContextMenu(context),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border(
            right: BorderSide(
              color: color,
              width: 3,
            ),
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: isCurrentTime
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(1.5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Course name
              Expanded(
                child: Text(
                  lecture["courseName"] as String,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(height: 0.5.h),

              // Instructor
              Text(
                lecture["instructor"] as String,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  fontSize: 9.sp,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Room and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      lecture["room"] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        fontSize: 8.sp,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isCurrentTime)
                    CustomIconWidget(
                      iconName: 'play_circle_filled',
                      size: 12,
                      color: color,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
