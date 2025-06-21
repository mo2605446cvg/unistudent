import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/student_login/student_login.dart';
import '../presentation/admin_dashboard/admin_dashboard.dart';
import '../presentation/student_registration/student_registration.dart';
import '../presentation/lecture_schedule/lecture_schedule.dart';
import '../presentation/messages/messages.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String studentRegistration = '/student-registration';
  static const String studentLogin = '/student-login';
  static const String lectureSchedule = '/lecture-schedule';
  static const String messages = '/messages';
  static const String adminDashboard = '/admin-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    studentRegistration: (context) => const StudentRegistration(),
    studentLogin: (context) => const StudentLogin(),
    lectureSchedule: (context) => const LectureSchedule(),
    messages: (context) => const Messages(),
    adminDashboard: (context) => const AdminDashboard(),
  };
}
