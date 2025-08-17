import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PetProfileHeader extends StatelessWidget {
  final Map<String, dynamic> currentPet;
  final VoidCallback onProfileTap;

  const PetProfileHeader({
    Key? key,
    required this.currentPet,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Pet Profile Picture with Tap to Switch
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: (currentPet['profilePhoto'] as String?) ??
                      'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=400&fit=crop',
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Pet Name and Breed
          Text(
            (currentPet['name'] as String?) ?? 'My Pet',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 0.5.h),

          Text(
            (currentPet['breed'] as String?) ?? 'Unknown Breed',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Pet Quick Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Age',
                '${currentPet['age'] ?? 'N/A'}',
                CustomIconWidget(
                  iconName: 'cake',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              _buildStatItem(
                'Weight',
                '${currentPet['weight'] ?? 'N/A'} kg',
                CustomIconWidget(
                  iconName: 'monitor_weight',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              _buildStatItem(
                'Gender',
                (currentPet['gender'] as String?) ?? 'N/A',
                CustomIconWidget(
                  iconName: 'pets',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Widget icon) {
    return Column(
      children: [
        icon,
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
