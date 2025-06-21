import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final String selectedDepartment;
  final String selectedYear;
  final List<String> departments;
  final List<String> years;
  final Function(String, String) onApplyFilter;

  const FilterModalWidget({
    super.key,
    required this.selectedDepartment,
    required this.selectedYear,
    required this.departments,
    required this.years,
    required this.onApplyFilter,
  });

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late String _tempSelectedDepartment;
  late String _tempSelectedYear;

  @override
  void initState() {
    super.initState();
    _tempSelectedDepartment = widget.selectedDepartment;
    _tempSelectedYear = widget.selectedYear;
  }

  void _applyFilters() {
    widget.onApplyFilter(_tempSelectedDepartment, _tempSelectedYear);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _tempSelectedDepartment = 'All';
      _tempSelectedYear = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'تصفية الجدول',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'إعادة تعيين',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
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
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Department filter
                  _buildFilterSection(
                    'القسم',
                    'school',
                    widget.departments,
                    _tempSelectedDepartment,
                    (value) {
                      setState(() {
                        _tempSelectedDepartment = value;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Year filter
                  _buildFilterSection(
                    'السنة الدراسية',
                    'calendar_today',
                    widget.years,
                    _tempSelectedYear,
                    (value) {
                      setState(() {
                        _tempSelectedYear = value;
                      });
                    },
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('إلغاء'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('تطبيق'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    String iconName,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
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
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.dividerColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = option == selectedValue;
              final isLast = index == options.length - 1;

              return GestureDetector(
                onTap: () => onChanged(option),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: !isLast
                        ? Border(
                            bottom: BorderSide(
                              color: AppTheme.lightTheme.dividerColor,
                              width: 0.5,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option == 'All' ? 'الكل' : option,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          size: 20,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
