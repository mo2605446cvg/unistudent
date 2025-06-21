import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/admin_drawer_widget.dart';
import './widgets/dashboard_metrics_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRefreshing = false;

  // Mock admin data
  final Map<String, dynamic> adminData = {
    "name": "د. أحمد محمد",
    "role": "مدير النظام",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "permissions": ["dashboard", "messages", "files", "students", "analytics"]
  };

  // Mock dashboard metrics
  final Map<String, dynamic> dashboardMetrics = {
    "totalStudents": 1247,
    "activeAnnouncements": 8,
    "pendingUploads": 3,
    "recentActivity": 15
  };

  // Mock recent activities
  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "action": "إرسال إعلان جديد",
      "description": "تم إرسال إعلان عن موعد الامتحانات النهائية",
      "timestamp": "منذ 30 دقيقة",
      "affectedCount": 245,
      "type": "announcement"
    },
    {
      "id": 2,
      "action": "رفع ملف",
      "description": "تم رفع جدول المحاضرات للفصل الثاني",
      "timestamp": "منذ ساعة",
      "affectedCount": 180,
      "type": "file"
    },
    {
      "id": 3,
      "action": "تحديث بيانات الطلاب",
      "description": "تم تحديث بيانات 25 طالب جديد",
      "timestamp": "منذ ساعتين",
      "affectedCount": 25,
      "type": "student"
    },
    {
      "id": 4,
      "action": "إرسال رسالة",
      "description": "تم إرسال رسالة لطلاب قسم الهندسة",
      "timestamp": "منذ 3 ساعات",
      "affectedCount": 89,
      "type": "message"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        drawer: AdminDrawerWidget(
          adminData: adminData,
          onNavigate: _handleNavigation,
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                SizedBox(height: 3.h),
                DashboardMetricsWidget(metrics: dashboardMetrics),
                SizedBox(height: 3.h),
                QuickActionsWidget(onActionTap: _handleQuickAction),
                SizedBox(height: 3.h),
                RecentActivityWidget(activities: recentActivities),
                SizedBox(height: 10.h), // Bottom padding for FAB
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        icon: CustomIconWidget(
          iconName: 'menu',
          color: Colors.white,
          size: 6.w,
        ),
      ),
      title: Text(
        'لوحة التحكم',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showNotificationSettings,
          icon: CustomIconWidget(
            iconName: 'notifications',
            color: Colors.white,
            size: 6.w,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: adminData["avatar"] as String,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً، ${adminData["name"]}',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
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
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _createNewAnnouncement,
      backgroundColor: AppTheme.accentLight,
      foregroundColor: Colors.black,
      icon: CustomIconWidget(
        iconName: 'add',
        color: Colors.black,
        size: 6.w,
      ),
      label: Text(
        'إعلان جديد',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحديث البيانات بنجاح'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    }
  }

  void _handleNavigation(String route) {
    Navigator.pop(context); // Close drawer

    switch (route) {
      case 'dashboard':
        // Already on dashboard
        break;
      case 'messages':
        Navigator.pushNamed(context, '/messages');
        break;
      case 'students':
        Navigator.pushNamed(context, '/student-registration');
        break;
      case 'schedule':
        Navigator.pushNamed(context, '/lecture-schedule');
        break;
      case 'login':
        Navigator.pushNamed(context, '/student-login');
        break;
      default:
        _showFeatureNotAvailable();
    }
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'announcement':
        _createNewAnnouncement();
        break;
      case 'upload':
        _showUploadDialog();
        break;
      case 'students':
        Navigator.pushNamed(context, '/student-registration');
        break;
      case 'analytics':
        _showFeatureNotAvailable();
        break;
    }
  }

  void _createNewAnnouncement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'إنشاء إعلان جديد',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'عنوان الإعلان',
                hintText: 'أدخل عنوان الإعلان',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'محتوى الإعلان',
                hintText: 'أدخل محتوى الإعلان',
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('إلغاء'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSuccessMessage('تم إرسال الإعلان بنجاح');
                    },
                    child: Text('إرسال'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('رفع ملف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'image',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text('رفع صورة'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessMessage('تم رفع الصورة بنجاح');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.errorLight,
                size: 6.w,
              ),
              title: Text('رفع ملف PDF'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessMessage('تم رفع ملف PDF بنجاح');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إعدادات الإشعارات'),
        content: Text('سيتم إضافة إعدادات الإشعارات قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showFeatureNotAvailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('هذه الميزة غير متاحة حالياً'),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }
}
