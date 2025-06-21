import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LectureDetailSheet extends StatelessWidget {
  final Map<String, dynamic> lecture;

  const LectureDetailSheet({
    super.key,
    required this.lecture,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(lecture["color"] as int);

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lecture["courseCode"] as String,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            lecture["courseName"] as String,
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '${lecture["startTime"]} - ${lecture["endTime"]}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        size: 24,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructor info
                  _buildInfoSection(
                    'المحاضر',
                    'person',
                    [
                      _buildInfoRow('الاسم', lecture["instructor"] as String),
                      _buildInfoRow('البريد الإلكتروني',
                          lecture["instructorContact"] as String),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Location info
                  _buildInfoSection(
                    'الموقع',
                    'location_on',
                    [
                      _buildInfoRow('القاعة', lecture["room"] as String),
                      _buildInfoRow(
                          'العنوان', lecture["roomLocation"] as String),
                      _buildActionRow(
                        'عرض على الخريطة',
                        'map',
                        () {
                          // Open map functionality
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Course materials
                  _buildInfoSection(
                    'مواد المقرر',
                    'folder',
                    (lecture["materials"] as List).map((material) {
                      return _buildActionRow(
                        material as String,
                        'description',
                        () {
                          // Open material functionality
                        },
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Add to calendar functionality
                            Navigator.pop(context);
                          },
                          icon: CustomIconWidget(
                            iconName: 'event',
                            size: 20,
                            color: Colors.white,
                          ),
                          label: Text('إضافة للتقويم'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Set reminder functionality
                            Navigator.pop(context);
                          },
                          icon: CustomIconWidget(
                            iconName: 'notifications',
                            size: 20,
                            color: color,
                          ),
                          label: Text('تعيين تذكير'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: color,
                            side: BorderSide(color: color),
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      String title, String iconName, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              size: 20,
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(
              color: AppTheme.lightTheme.dividerColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(String label, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              size: 16,
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_left',
              size: 16,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
