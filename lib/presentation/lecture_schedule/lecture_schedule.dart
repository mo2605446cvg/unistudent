import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/lecture_detail_sheet.dart';
import './widgets/schedule_grid_widget.dart';
import './widgets/week_navigation_widget.dart';

class LectureSchedule extends StatefulWidget {
  const LectureSchedule({super.key});

  @override
  State<LectureSchedule> createState() => _LectureScheduleState();
}

class _LectureScheduleState extends State<LectureSchedule>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedWeek = DateTime.now();
  String _selectedDepartment = 'All';
  String _selectedYear = 'All';
  bool _isLoading = false;

  // Mock lecture data
  final List<Map<String, dynamic>> _lectureData = [
    {
      "id": 1,
      "courseCode": "CS101",
      "courseName": "مقدمة في علوم الحاسوب",
      "instructor": "د. أحمد محمد",
      "instructorContact": "ahmed.mohamed@university.edu",
      "room": "A101",
      "roomLocation": "مبنى الحاسوب - الطابق الأول",
      "startTime": "08:00",
      "endTime": "09:30",
      "dayOfWeek": 1, // Monday "department": "Computer Science",
      "year": "First Year",
      "color": 0xFF1B365D,
      "materials": ["محاضرة 1 - مقدمة", "تمارين الأسبوع الأول"],
      "mapLink": "https://maps.google.com/?q=Computer+Building"
    },
    {
      "id": 2,
      "courseCode": "MATH201",
      "courseName": "الرياضيات المتقدمة",
      "instructor": "د. فاطمة علي",
      "instructorContact": "fatima.ali@university.edu",
      "room": "B205",
      "roomLocation": "مبنى الرياضيات - الطابق الثاني",
      "startTime": "10:00",
      "endTime": "11:30",
      "dayOfWeek": 1,
      "department": "Mathematics",
      "year": "Second Year",
      "color": 0xFF4A90A4,
      "materials": ["كتاب الرياضيات", "حلول التمارين"],
      "mapLink": "https://maps.google.com/?q=Mathematics+Building"
    },
    {
      "id": 3,
      "courseCode": "ENG102",
      "courseName": "اللغة الإنجليزية",
      "instructor": "أ. سارة حسن",
      "instructorContact": "sara.hassan@university.edu",
      "room": "C301",
      "roomLocation": "مبنى اللغات - الطابق الثالث",
      "startTime": "13:00",
      "endTime": "14:30",
      "dayOfWeek": 2, // Tuesday "department": "Languages",
      "year": "First Year",
      "color": 0xFFE8B931,
      "materials": ["كتاب القواعد", "تسجيلات صوتية"],
      "mapLink": "https://maps.google.com/?q=Languages+Building"
    },
    {
      "id": 4,
      "courseCode": "PHY201",
      "courseName": "الفيزياء العامة",
      "instructor": "د. محمود عبدالله",
      "instructorContact": "mahmoud.abdullah@university.edu",
      "room": "D102",
      "roomLocation": "مبنى العلوم - المختبر الثاني",
      "startTime": "15:00",
      "endTime": "16:30",
      "dayOfWeek": 3, // Wednesday "department": "Physics",
      "year": "Second Year",
      "color": 0xFF2D7D32,
      "materials": ["دليل المختبر", "تقارير التجارب"],
      "mapLink": "https://maps.google.com/?q=Science+Building"
    },
    {
      "id": 5,
      "courseCode": "CHEM101",
      "courseName": "الكيمياء الأساسية",
      "instructor": "د. نور الدين",
      "instructorContact": "nour.aldin@university.edu",
      "room": "E201",
      "roomLocation": "مبنى الكيمياء - المختبر الأول",
      "startTime": "09:00",
      "endTime": "10:30",
      "dayOfWeek": 4, // Thursday "department": "Chemistry",
      "year": "First Year",
      "color": 0xFFF57C00,
      "materials": ["كتاب الكيمياء", "جدول العناصر"],
      "mapLink": "https://maps.google.com/?q=Chemistry+Building"
    }
  ];

  final List<String> _departments = [
    'All',
    'Computer Science',
    'Mathematics',
    'Languages',
    'Physics',
    'Chemistry'
  ];

  final List<String> _years = [
    'All',
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 2; // Schedule tab active
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateWeek(bool isNext) {
    setState(() {
      _selectedWeek = _selectedWeek.add(Duration(days: isNext ? 7 : -7));
    });
  }

  void _goToToday() {
    setState(() {
      _selectedWeek = DateTime.now();
    });
  }

  Future<void> _refreshSchedule() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _showLectureDetails(Map<String, dynamic> lecture) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => LectureDetailSheet(lecture: lecture));
  }

  void _showFilterModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => FilterModalWidget(
            selectedDepartment: _selectedDepartment,
            selectedYear: _selectedYear,
            departments: _departments,
            years: _years,
            onApplyFilter: (department, year) {
              setState(() {
                _selectedDepartment = department;
                _selectedYear = year;
              });
            }));
  }

  List<Map<String, dynamic>> _getFilteredLectures() {
    return _lectureData.where((lecture) {
      bool departmentMatch = _selectedDepartment == 'All' ||
          (lecture["department"] as String) == _selectedDepartment;
      bool yearMatch = _selectedYear == 'All' ||
          (lecture["year"] as String) == _selectedYear;
      return departmentMatch && yearMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
            appBar: AppBar(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                elevation: 2,
                title: Text('جدول المحاضرات',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                actions: [
                  IconButton(
                      onPressed: _showFilterModal,
                      icon: CustomIconWidget(
                          iconName: 'filter_list',
                          color: Colors.white,
                          size: 24)),
                  SizedBox(width: 2.w),
                ],
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: Colors.white,
                        size: 24))),
            body: Column(children: [
              // Week Navigation
              WeekNavigationWidget(
                  selectedWeek: _selectedWeek,
                  onNavigateWeek: _navigateWeek,
                  onGoToToday: _goToToday),

              // Schedule Grid
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: _refreshSchedule,
                      color: AppTheme.lightTheme.primaryColor,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: AppTheme.lightTheme.primaryColor))
                          : ScheduleGridWidget(
                              lectures: _getFilteredLectures(),
                              selectedWeek: _selectedWeek,
                              onLectureTap: _showLectureDetails))),
            ]),
            bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2)),
                    ]),
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppTheme.lightTheme.primaryColor,
                    labelColor: AppTheme.lightTheme.primaryColor,
                    unselectedLabelColor:
                        AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    labelStyle: AppTheme.lightTheme.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    unselectedLabelStyle:
                        AppTheme.lightTheme.textTheme.labelSmall,
                    onTap: (index) {
                      switch (index) {
                        case 0:
                          Navigator.pushNamed(context, '/admin-dashboard');
                          break;
                        case 1:
                          Navigator.pushNamed(context, '/messages');
                          break;
                        case 2:
                          // Current screen - Schedule
                          break;
                        case 3:
                          Navigator.pushNamed(context, '/student-login');
                          break;
                        case 4:
                          Navigator.pushNamed(context, '/student-registration');
                          break;
                      }
                    },
                    tabs: [
                      Tab(
                          icon: CustomIconWidget(
                              iconName: 'dashboard',
                              size: 20,
                              color: _tabController.index == 0
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant),
                          text: 'لوحة التحكم'),
                      Tab(
                          icon: CustomIconWidget(
                              iconName: 'message',
                              size: 20,
                              color: _tabController.index == 1
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant),
                          text: 'الرسائل'),
                      Tab(
                          icon: CustomIconWidget(
                              iconName: 'schedule',
                              size: 20,
                              color: AppTheme.lightTheme.primaryColor),
                          text: 'الجدول'),
                      Tab(
                          icon: CustomIconWidget(
                              iconName: 'login',
                              size: 20,
                              color: _tabController.index == 3
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant),
                          text: 'تسجيل الدخول'),
                      Tab(
                          icon: CustomIconWidget(
                              iconName: 'person_add',
                              size: 20,
                              color: _tabController.index == 4
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant),
                          text: 'التسجيل'),
                    ]))));
  }
}
