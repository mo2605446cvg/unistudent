import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _loadingAnimation;

  bool _showRetryOption = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadingAnimationController.repeat();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationTokens(),
        _loadUserPreferences(),
        _fetchCachedAcademicData(),
        _prepareOfflineContent(),
      ]);

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 2500));
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showRetryOption = true;
          _isInitializing = false;
        });

        // Auto retry after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _showRetryOption) {
            _retryInitialization();
          }
        });
      }
    }
  }

  Future<void> _checkAuthenticationTokens() async {
    // Simulate checking authentication tokens
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _fetchCachedAcademicData() async {
    // Simulate fetching cached academic data
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _prepareOfflineContent() async {
    // Simulate preparing offline content
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToNextScreen() {
    // Simulate navigation logic based on authentication status
    final bool isAuthenticated = false; // Mock authentication status
    final bool isNewUser = true; // Mock new user status

    String nextRoute;
    if (isAuthenticated) {
      nextRoute = '/lecture-schedule'; // Dashboard for authenticated students
    } else if (isNewUser) {
      nextRoute = '/student-registration'; // Registration for new users
    } else {
      nextRoute = '/student-login'; // Login for returning users
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _retryInitialization() {
    setState(() {
      _showRetryOption = false;
      _isInitializing = true;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.primaryColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightTheme.primaryColor,
                  AppTheme.primaryVariantLight,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _logoFadeAnimation,
                          child: ScaleTransition(
                            scale: _logoScaleAnimation,
                            child: _buildUniversityLogo(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAppTitle(),
                      SizedBox(height: 4.h),
                      _buildLoadingSection(),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUniversityLogo() {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'school',
              color: AppTheme.lightTheme.primaryColor,
              size: 12.w,
            ),
            SizedBox(height: 1.h),
            Text(
              'UNI',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Column(
      children: [
        Text(
          'UniStudent',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'جامعة الطلاب',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 1,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    if (_showRetryOption) {
      return _buildRetrySection();
    }

    return Column(
      children: [
        AnimatedBuilder(
          animation: _loadingAnimation,
          builder: (context, child) {
            return SizedBox(
              width: 8.w,
              height: 8.w,
              child: CircularProgressIndicator(
                value: _isInitializing ? null : _loadingAnimation.value,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.accentLight,
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.3),
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
        Text(
          'جاري التحميل...',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildRetrySection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.warningLight,
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        Text(
          'فشل في التحميل',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 1.h),
        Text(
          'سيتم إعادة المحاولة تلقائياً...',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 2.h),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentLight,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            'إعادة المحاولة',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
