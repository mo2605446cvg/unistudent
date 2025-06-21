import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/message_card_widget.dart';
import './widgets/message_detail_widget.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  String _searchQuery = '';
  int _currentIndex = 2; // Messages tab active
  late TabController _tabController;

  // Mock data for messages
  final List<Map<String, dynamic>> _messages = [
    {
      "id": 1,
      "senderName": "د. أحمد محمد",
      "senderRole": "عميد كلية الهندسة",
      "subject": "إعلان هام: تأجيل امتحانات الفصل الأول",
      "previewText":
          "نود إعلامكم بأنه تم تأجيل امتحانات الفصل الدراسي الأول لمدة أسبوع واحد بسبب الظروف الاستثنائية...",
      "fullContent":
          """السلام عليكم ورحمة الله وبركاته، نود إعلامكم بأنه تم تأجيل امتحانات الفصل الدراسي الأول لمدة أسبوع واحد بسبب الظروف الاستثنائية التي تمر بها الجامعة. الجدول الجديد للامتحانات: - بداية الامتحانات: 15 يناير 2024 - نهاية الامتحانات: 30 يناير 2024 يرجى مراجعة الجدول المحدث على موقع الجامعة الإلكتروني. مع أطيب التحيات، عمادة كلية الهندسة""",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "isRead": false,
      "isImportant": true,
      "hasAttachments": true,
      "attachments": [
        {
          "name": "جدول_الامتحانات_المحدث.pdf",
          "type": "pdf",
          "size": "2.5 MB",
          "url": "https://example.com/exam_schedule.pdf"
        }
      ],
      "reactions": {"like": 45, "important": 23, "acknowledge": 67},
      "userReaction": "acknowledge"
    },
    {
      "id": 2,
      "senderName": "أ. فاطمة علي",
      "senderRole": "مسجل الجامعة",
      "subject": "تذكير: آخر موعد لتسجيل المقررات",
      "previewText":
          "نذكركم بأن آخر موعد لتسجيل المقررات للفصل الدراسي الثاني هو يوم الخميس الموافق...",
      "fullContent":
          """عزيزي الطالب/الطالبة، نذكركم بأن آخر موعد لتسجيل المقررات للفصل الدراسي الثاني هو يوم الخميس الموافق 20 ديسمبر 2023. المطلوب منك: 1. مراجعة الخطة الدراسية 2. اختيار المقررات المناسبة 3. التأكد من عدم وجود تعارض في الأوقات 4. إتمام عملية التسجيل قبل الموعد النهائي للاستفسار، يرجى التواصل مع مكتب التسجيل. تحياتي، مسجل الجامعة""",
      "timestamp": DateTime.now().subtract(Duration(hours: 6)),
      "isRead": true,
      "isImportant": false,
      "hasAttachments": false,
      "attachments": [],
      "reactions": {"like": 12, "important": 8, "acknowledge": 34},
      "userReaction": "like"
    },
    {
      "id": 3,
      "senderName": "د. محمد حسن",
      "senderRole": "رئيس قسم علوم الحاسوب",
      "subject": "ورشة عمل: تطوير التطبيقات المحمولة",
      "previewText":
          "يسعدنا دعوتكم لحضور ورشة عمل حول تطوير التطبيقات المحمولة باستخدام Flutter...",
      "fullContent":
          """أعزائي الطلاب، يسعدنا دعوتكم لحضور ورشة عمل حول تطوير التطبيقات المحمولة باستخدام Flutter. تفاصيل الورشة: - التاريخ: السبت 23 ديسمبر 2023 - الوقت: من 10:00 صباحاً إلى 4:00 مساءً - المكان: مختبر الحاسوب رقم 3 - المدرب: م. أحمد الشامي المواضيع المطروحة: - مقدمة في Flutter - بناء واجهات المستخدم - إدارة البيانات - نشر التطبيقات التسجيل مجاني ومحدود لـ 30 مشارك فقط. للتسجيل، يرجى ملء النموذج المرفق. مع التحية، رئيس قسم علوم الحاسوب""",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "isRead": false,
      "isImportant": false,
      "hasAttachments": true,
      "attachments": [
        {
          "name": "نموذج_التسجيل.pdf",
          "type": "pdf",
          "size": "1.2 MB",
          "url": "https://example.com/registration_form.pdf"
        },
        {
          "name": "ملصق_الورشة.jpg",
          "type": "image",
          "size": "800 KB",
          "url":
              "https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=500"
        }
      ],
      "reactions": {"like": 28, "important": 15, "acknowledge": 19},
      "userReaction": null
    },
    {
      "id": 4,
      "senderName": "إدارة شؤون الطلاب",
      "senderRole": "شؤون الطلاب",
      "subject": "إعلان المنح الدراسية للفصل الثاني",
      "previewText":
          "تعلن إدارة شؤون الطلاب عن فتح باب التقديم للمنح الدراسية للطلاب المتفوقين...",
      "fullContent":
          """السلام عليكم ورحمة الله وبركاته، تعلن إدارة شؤون الطلاب عن فتح باب التقديم للمنح الدراسية للطلاب المتفوقين للفصل الدراسي الثاني. شروط التقديم: - معدل تراكمي لا يقل عن 3.5 - عدم وجود إنذارات أكاديمية - الانتظام في الحضور - تقديم خطاب توصية من أستاذ المقرر قيمة المنحة: 5000 ريال سعودي آخر موعد للتقديم: 31 ديسمبر 2023 للتقديم، يرجى زيارة مكتب شؤون الطلاب أو التقديم إلكترونياً. وفقكم الله، إدارة شؤون الطلاب""",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "isRead": true,
      "isImportant": true,
      "hasAttachments": false,
      "attachments": [],
      "reactions": {"like": 56, "important": 42, "acknowledge": 78},
      "userReaction": "important"
    },
    {
      "id": 5,
      "senderName": "مكتبة الجامعة",
      "senderRole": "أمين المكتبة",
      "subject": "ساعات عمل المكتبة خلال فترة الامتحانات",
      "previewText":
          "نود إعلامكم بأن مكتبة الجامعة ستعمل بساعات مطولة خلال فترة الامتحانات...",
      "fullContent":
          """أعزائي الطلاب والطالبات، نود إعلامكم بأن مكتبة الجامعة ستعمل بساعات مطولة خلال فترة الامتحانات لخدمتكم بشكل أفضل. ساعات العمل الجديدة: - الأحد إلى الخميس: من 7:00 صباحاً إلى 12:00 منتصف الليل - الجمعة والسبت: من 9:00 صباحاً إلى 10:00 مساءً الخدمات المتاحة: - قاعات الدراسة الفردية والجماعية - أجهزة الحاسوب والطباعة - الكتب والمراجع العلمية - خدمة الواي فاي المجاني نتمنى لكم التوفيق في امتحاناتكم. مع أطيب التحيات، إدارة مكتبة الجامعة""",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "isRead": false,
      "isImportant": false,
      "hasAttachments": false,
      "attachments": [],
      "reactions": {"like": 23, "important": 12, "acknowledge": 45},
      "userReaction": null
    }
  ];

  List<Map<String, dynamic>> get _filteredMessages {
    if (_searchQuery.isEmpty) {
      return _messages;
    }
    return _messages.where((message) {
      return (message['senderName'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (message['subject'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (message['fullContent'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  int get _unreadCount {
    return _messages.where((message) => !(message['isRead'] as bool)).length;
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 5, vsync: this, initialIndex: _currentIndex);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _onRefresh() async {
    // Simulate network request
    await Future.delayed(Duration(seconds: 2));
    // In real app, fetch new messages from API
    setState(() {
      // Refresh data
    });
  }

  void _openMessageDetail(Map<String, dynamic> message) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MessageDetailWidget(
          message: message,
          onReactionChanged: _updateMessageReaction,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _updateMessageReaction(int messageId, String? reaction) {
    setState(() {
      final messageIndex =
          _messages.indexWhere((msg) => msg['id'] == messageId);
      if (messageIndex != -1) {
        _messages[messageIndex]['userReaction'] = reaction;
      }
    });
  }

  void _markAsRead(int messageId) {
    setState(() {
      final messageIndex =
          _messages.indexWhere((msg) => msg['id'] == messageId);
      if (messageIndex != -1) {
        _messages[messageIndex]['isRead'] = true;
      }
    });
  }

  void _toggleImportant(int messageId) {
    setState(() {
      final messageIndex =
          _messages.indexWhere((msg) => msg['id'] == messageId);
      if (messageIndex != -1) {
        _messages[messageIndex]['isImportant'] =
            !_messages[messageIndex]['isImportant'];
      }
    });
  }

  void _archiveMessage(int messageId) {
    setState(() {
      _messages.removeWhere((msg) => msg['id'] == messageId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم أرشفة الرسالة'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {
            // Restore message logic
          },
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/lecture-schedule');
        break;
      case 1:
        Navigator.pushNamed(context, '/student-login');
        break;
      case 2:
        // Already on Messages
        break;
      case 3:
        Navigator.pushNamed(context, '/admin-dashboard');
        break;
      case 4:
        Navigator.pushNamed(context, '/student-registration');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2.0,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: 'البحث في الرسائل...',
                    hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 14.sp),
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                )
              : Row(
                  children: [
                    Text(
                      'الرسائل',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (_unreadCount > 0) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_unreadCount',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
          actions: [
            IconButton(
              onPressed: _toggleSearch,
              icon: CustomIconWidget(
                iconName: _isSearching ? 'close' : 'search',
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: _filteredMessages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'message',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 64,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'لا توجد رسائل مطابقة للبحث'
                            : 'لا توجد رسائل',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  itemCount: _filteredMessages.length,
                  itemBuilder: (context, index) {
                    final message = _filteredMessages[index];
                    return MessageCardWidget(
                      message: message,
                      onTap: () {
                        _markAsRead(message['id']);
                        _openMessageDetail(message);
                      },
                      onMarkRead: () => _markAsRead(message['id']),
                      onToggleImportant: () => _toggleImportant(message['id']),
                      onArchive: () => _archiveMessage(message['id']),
                    );
                  },
                ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.primaryColor,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          selectedLabelStyle:
              TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'schedule',
                color: _currentIndex == 0
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'الجدول',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _currentIndex == 1
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'الملف الشخصي',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'message',
                    color: _currentIndex == 2
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  if (_unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '$_unreadCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'الرسائل',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'dashboard',
                color: _currentIndex == 3
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'لوحة التحكم',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'app_registration',
                color: _currentIndex == 4
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'التسجيل',
            ),
          ],
        ),
      ),
    );
  }
}
