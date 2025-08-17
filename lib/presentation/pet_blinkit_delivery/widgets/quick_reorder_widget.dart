import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickReorderWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reorderItems;
  final Function(Map<String, dynamic>) onReorder;

  const QuickReorderWidget({
    super.key,
    required this.reorderItems,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    if (reorderItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            'Quick Reorder',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: reorderItems.length,
            itemBuilder: (context, index) {
              final item = reorderItems[index];
              return Container(
                width: 30.w,
                margin: EdgeInsets.only(right: 3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: CustomImageWidget(
                          imageUrl: item['image'] as String,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['name'] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: () => onReorder(item),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Reorder',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
