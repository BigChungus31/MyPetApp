import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PetProfileSwitcherBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> pets;
  final Map<String, dynamic> currentPet;
  final Function(Map<String, dynamic>) onPetSelected;

  const PetProfileSwitcherBottomSheet({
    Key? key,
    required this.pets,
    required this.currentPet,
    required this.onPetSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 2.h),

          // Title
          Text(
            'Switch Pet Profile',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Pet list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: pets.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final pet = pets[index];
                final isSelected =
                    (pet['id'] as int) == (currentPet['id'] as int);

                return _buildPetItem(context, pet, isSelected);
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Add new pet button
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pet-profile-creation');
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              label: Text(
                'Add New Pet',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildPetItem(
      BuildContext context, Map<String, dynamic> pet, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onPetSelected(pet);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Pet photo
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: (pet['profilePhoto'] as String?) ??
                      'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=400&fit=crop',
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Pet info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (pet['name'] as String?) ?? 'Unknown Pet',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${pet['breed'] ?? 'Unknown Breed'} • ${pet['age'] ?? 'N/A'} years',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
