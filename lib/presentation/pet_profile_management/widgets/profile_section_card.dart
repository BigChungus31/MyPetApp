import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;

  const ProfileSectionCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.children,
    required this.isExpanded,
    required this.onToggle,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: icon.toString().split('.').last,
                      color: AppTheme.lightTheme.primaryColor,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (onEdit != null)
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 4.w,
                        ),
                      ),
                    ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.textTheme.bodyMedium?.color ??
                        Colors.grey,
                    size: 5.w,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                children: children,
              ),
            ),
        ],
      ),
    );
  }
}
