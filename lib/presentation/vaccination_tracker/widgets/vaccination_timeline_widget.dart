import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VaccinationTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> vaccinations;
  final Function(Map<String, dynamic>) onVaccinationTap;

  const VaccinationTimelineWidget({
    Key? key,
    required this.vaccinations,
    required this.onVaccinationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vaccinations.length,
      itemBuilder: (context, index) {
        final vaccination = vaccinations[index];
        final isCompleted = vaccination['status'] == 'completed';
        final isOverdue = vaccination['status'] == 'overdue';
        final isUpcoming = vaccination['status'] == 'upcoming';

        return Container(
          margin: EdgeInsets.only(bottom: 3.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator
              Column(
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppTheme.successLight
                          : isOverdue
                              ? AppTheme.errorLight
                              : AppTheme.warningLight,
                    ),
                    child: isCompleted
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: Colors.white,
                            size: 2.w,
                          )
                        : null,
                  ),
                  if (index < vaccinations.length - 1)
                    Container(
                      width: 0.5.w,
                      height: 8.h,
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                ],
              ),
              SizedBox(width: 4.w),
              // Vaccination card
              Expanded(
                child: GestureDetector(
                  onTap: () => onVaccinationTap(vaccination),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: isCompleted
                            ? AppTheme.successLight.withValues(alpha: 0.3)
                            : isOverdue
                                ? AppTheme.errorLight.withValues(alpha: 0.3)
                                : AppTheme.warningLight.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                vaccination['name'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? AppTheme.successLight
                                        .withValues(alpha: 0.1)
                                    : isOverdue
                                        ? AppTheme.errorLight
                                            .withValues(alpha: 0.1)
                                        : AppTheme.warningLight
                                            .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Text(
                                isCompleted
                                    ? 'Completed'
                                    : isOverdue
                                        ? 'Overdue'
                                        : 'Upcoming',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: isCompleted
                                      ? AppTheme.successLight
                                      : isOverdue
                                          ? AppTheme.errorLight
                                          : AppTheme.warningLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: AppTheme.textSecondaryLight,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              vaccination['date'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                        if (vaccination['veterinarian'] != null) ...[
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'local_hospital',
                                color: AppTheme.textSecondaryLight,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  vaccination['veterinarian'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (vaccination['nextDue'] != null) ...[
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: AppTheme.primaryLight,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Next due: ${vaccination['nextDue']}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
