import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PetProfileSwitcherWidget extends StatelessWidget {
  final List<Map<String, dynamic>> pets;
  final int selectedPetIndex;
  final Function(int) onPetSelected;

  const PetProfileSwitcherWidget({
    Key? key,
    required this.pets,
    required this.selectedPetIndex,
    required this.onPetSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showPetSelector(context),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryLight,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: pets.isNotEmpty
                        ? CustomImageWidget(
                            imageUrl: pets[selectedPetIndex]['image'] as String,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            child: CustomIconWidget(
                              iconName: 'pets',
                              color: AppTheme.primaryLight,
                              size: 6.w,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pets.isNotEmpty
                          ? pets[selectedPetIndex]['name'] as String
                          : 'No Pet',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pets.isNotEmpty
                          ? '${pets[selectedPetIndex]['breed']} • ${pets[selectedPetIndex]['age']}'
                          : 'Add a pet profile',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.primaryLight,
                  size: 5.w,
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/pet-profile-management'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textSecondaryLight,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  void _showPetSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Select Pet Profile',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ...pets.asMap().entries.map((entry) {
              final index = entry.key;
              final pet = entry.value;
              final isSelected = index == selectedPetIndex;

              return GestureDetector(
                onTap: () {
                  onPetSelected(index);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryLight.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(3.w),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: CustomImageWidget(
                            imageUrl: pet['image'] as String,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${pet['breed']} • ${pet['age']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.primaryLight,
                          size: 6.w,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/pet-profile-creation');
                },
                child: const Text('Add New Pet'),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
