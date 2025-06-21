import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeekNavigationWidget extends StatelessWidget {
  final DateTime selectedWeek;
  final Function(bool) onNavigateWeek;
  final VoidCallback onGoToToday;

  const WeekNavigationWidget({
    super.key,
    required this.selectedWeek,
    required this.onNavigateWeek,
    required this.onGoToToday,
  });

  String _getWeekRange() {
    final startOfWeek =
        selectedWeek.subtract(Duration(days: selectedWeek.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];

    return '${startOfWeek.day} ${months[startOfWeek.month - 1]} - ${endOfWeek.day} ${months[endOfWeek.month - 1]}';
  }

  bool _isCurrentWeek() {
    final now = DateTime.now();
    final startOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfSelectedWeek =
        selectedWeek.subtract(Duration(days: selectedWeek.weekday - 1));

    return startOfCurrentWeek.year == startOfSelectedWeek.year &&
        startOfCurrentWeek.month == startOfSelectedWeek.month &&
        startOfCurrentWeek.day == startOfSelectedWeek.day;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous week button
          GestureDetector(
            onTap: () => onNavigateWeek(false),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
          ),

          SizedBox(width: 4.w),

          // Week range display
          Expanded(
            child: Column(
              children: [
                Text(
                  _getWeekRange(),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!_isCurrentWeek()) ...[
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: onGoToToday,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'اليوم',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(width: 4.w),

          // Next week button
          GestureDetector(
            onTap: () => onNavigateWeek(true),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'chevron_left',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
