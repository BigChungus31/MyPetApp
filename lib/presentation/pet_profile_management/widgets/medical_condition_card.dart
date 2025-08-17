import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MedicalConditionCard extends StatelessWidget {
  final Map<String, dynamic> condition;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicalConditionCard({
    Key? key,
    required this.condition,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final severity = condition['severity'] ?? 'Low';
    final severityColor = _getSeverityColor(severity);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  condition['name'] ?? 'Unknown Condition',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  severity,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 4.w,
                    ),
                  ),
                ),
              if (onDelete != null)
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 4.w,
                    ),
                  ),
                ),
            ],
          ),
          if (condition['description'] != null &&
              condition['description'].toString().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                condition['description'],
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
          if (condition['treatment'] != null &&
              condition['treatment'].toString().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconWidget(
                    iconName: 'medical_services',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Treatment: ${condition['treatment']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (condition['diagnosedDate'] != null)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.lightTheme.textTheme.bodySmall?.color ??
                        Colors.grey,
                    size: 3.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Diagnosed: ${_formatDate(condition['diagnosedDate'])}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
      default:
        return AppTheme.successLight;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
