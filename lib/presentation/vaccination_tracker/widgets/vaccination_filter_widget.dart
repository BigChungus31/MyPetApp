import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VaccinationFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final Function() onSearchTap;

  const VaccinationFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onSearchTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all', 'label': 'All', 'icon': 'list'},
      {'key': 'completed', 'label': 'Completed', 'icon': 'check_circle'},
      {'key': 'upcoming', 'label': 'Upcoming', 'icon': 'schedule'},
      {'key': 'overdue', 'label': 'Overdue', 'icon': 'warning'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Search bar
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondaryLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Search vaccinations...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                final isSelected = selectedFilter == filter['key'];
                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: filter['icon'] as String,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.textSecondaryLight,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          filter['label'] as String,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        onFilterChanged(filter['key'] as String);
                      }
                    },
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    selectedColor: AppTheme.primaryLight,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
