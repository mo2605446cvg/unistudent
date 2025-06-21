import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './lecture_block_widget.dart';

class ScheduleGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> lectures;
  final DateTime selectedWeek;
  final Function(Map<String, dynamic>) onLectureTap;

  const ScheduleGridWidget({
    super.key,
    required this.lectures,
    required this.selectedWeek,
    required this.onLectureTap,
  });

  List<String> get _weekDays =>
      ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];

  List<String> get _timeSlots => [
        '08:00',
        '09:00',
        '10:00',
        '11:00',
        '12:00',
        '13:00',
        '14:00',
        '15:00',
        '16:00',
        '17:00'
      ];

  DateTime _getCurrentTime() {
    return DateTime.now();
  }

  bool _isCurrentTimeSlot(String timeSlot, int dayIndex) {
    final now = _getCurrentTime();
    final currentDayOfWeek = now.weekday;
    final currentHour = now.hour;

    // Convert dayIndex (0-4) to weekday (1-5)
    final slotDayOfWeek = dayIndex + 1;

    if (currentDayOfWeek != slotDayOfWeek) return false;

    final slotHour = int.parse(timeSlot.split(':')[0]);
    return currentHour == slotHour;
  }

  List<Map<String, dynamic>> _getLecturesForDayAndTime(
      int dayOfWeek, String timeSlot) {
    return lectures.where((lecture) {
      final lectureDay = lecture["dayOfWeek"] as int;
      final lectureStartTime = lecture["startTime"] as String;

      return lectureDay == dayOfWeek + 1 && lectureStartTime == timeSlot;
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'event_available',
            size: 64,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            'لا توجد محاضرات اليوم',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'استمتع بوقت فراغك واستعد للمحاضرات القادمة',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (lectures.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Days header
          Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Time column header
                Container(
                  width: 20.w,
                  alignment: Alignment.center,
                  child: Text(
                    'الوقت',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                // Day headers
                Expanded(
                  child: Row(
                    children: _weekDays.asMap().entries.map((entry) {
                      final index = entry.key;
                      final day = entry.value;
                      final isToday = _getCurrentTime().weekday == index + 1;

                      return Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                color: AppTheme.lightTheme.dividerColor,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Text(
                            day,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight:
                                  isToday ? FontWeight.w600 : FontWeight.w500,
                              color: isToday
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Schedule grid
          ...(_timeSlots.map((timeSlot) {
            return Container(
              height: 12.h,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Time column
                  Container(
                    width: 20.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      border: Border(
                        left: BorderSide(
                          color: AppTheme.lightTheme.dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      timeSlot,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  // Day columns
                  Expanded(
                    child: Row(
                      children: List.generate(5, (dayIndex) {
                        final dayLectures =
                            _getLecturesForDayAndTime(dayIndex, timeSlot);
                        final isCurrentTime =
                            _isCurrentTimeSlot(timeSlot, dayIndex);

                        return Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCurrentTime
                                  ? AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.05)
                                  : Colors.transparent,
                              border: Border(
                                left: BorderSide(
                                  color: AppTheme.lightTheme.dividerColor,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: dayLectures.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(1.w),
                                    child: LectureBlockWidget(
                                      lecture: dayLectures.first,
                                      onTap: () =>
                                          onLectureTap(dayLectures.first),
                                      isCurrentTime: isCurrentTime,
                                    ),
                                  )
                                : isCurrentTime
                                    ? Container(
                                        margin: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.primaryColor,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: CustomIconWidget(
                                            iconName: 'access_time',
                                            size: 16,
                                            color: AppTheme
                                                .lightTheme.primaryColor,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          }).toList()),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
