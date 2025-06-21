import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? imagePath;
  final Function(String) onImageSelected;

  const ProfilePictureWidget({
    super.key,
    this.imagePath,
    required this.onImageSelected,
  });

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'اختر صورة الملف الشخصي',
              style: AppTheme.lightTheme.textTheme.titleMedium,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  context,
                  'الكاميرا',
                  'camera_alt',
                  () {
                    Navigator.pop(context);
                    // Mock camera selection
                    onImageSelected(
                        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png');
                  },
                ),
                _buildImageSourceOption(
                  context,
                  'المعرض',
                  'photo_library',
                  () {
                    Navigator.pop(context);
                    // Mock gallery selection
                    onImageSelected(
                        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png');
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.w,
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showImageSourceDialog(context),
          child: Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: imagePath != null
                ? ClipOval(
                    child: CustomImageWidget(
                      imageUrl: imagePath!,
                      width: 30.w,
                      height: 30.w,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'add_a_photo',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 8.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'إضافة صورة',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'اختياري - يمكنك إضافة صورة شخصية',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
