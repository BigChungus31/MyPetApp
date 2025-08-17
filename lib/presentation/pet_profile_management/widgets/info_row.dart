import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: value.isNotEmpty
                    ? AppTheme.lightTheme.textTheme.bodyMedium?.color
                    : AppTheme.lightTheme.textTheme.bodySmall?.color,
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
