import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdminDrawerWidget extends StatelessWidget {
  final Map<String, dynamic> adminData;
  final Function(String) onNavigate;

  const AdminDrawerWidget({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: 'dashboard',
                  title: 'لوحة التحكم',
                  isSelected: true,
                  onTap: () => onNavigate('dashboard'),
                ),
                _buildDrawerItem(
                  icon: 'message',
                  title: 'الرسائل',
                  onTap: () => onNavigate('messages'),
                ),
                _buildDrawerItem(
                  icon: 'folder',
                  title: 'إدارة الملفات',
                  onTap: () => onNavigate('files'),
                ),
                _buildDrawerItem(
                  icon: 'people',
                  title: 'إدارة الطلاب',
                  onTap: () => onNavigate('students'),
                ),
                _buildDrawerItem(
                  icon: 'schedule',
                  title: 'الجداول الدراسية',
                  onTap: () => onNavigate('schedule'),
                ),
                _buildDrawerItem(
                  icon: 'analytics',
                  title: 'التحليلات',
                  onTap: () => onNavigate('analytics'),
                ),
                Divider(color: AppTheme.dividerLight),
                _buildDrawerItem(
                  icon: 'settings',
                  title: 'الإعدادات',
                  onTap: () => onNavigate('settings'),
                ),
                _buildDrawerItem(
                  icon: 'help',
                  title: 'المساعدة',
                  onTap: () => onNavigate('help'),
                ),
                _buildDrawerItem(
                  icon: 'logout',
                  title: 'تسجيل الخروج',
                  onTap: () => onNavigate('login'),
                  isLogout: true,
                ),
              ],
            ),
          ),
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 25.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: adminData["avatar"] as String,
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                adminData["name"] as String,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  adminData["role"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isLogout = false,
  }) {
    final Color itemColor = isLogout
        ? AppTheme.errorLight
        : isSelected
            ? AppTheme.lightTheme.primaryColor
            : AppTheme.textPrimaryLight;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon,
          color: itemColor,
          size: 6.w,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: itemColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.dividerLight, width: 1),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: AppTheme.textSecondaryLight,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UniStudent Admin',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'الإصدار 1.0.0',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
