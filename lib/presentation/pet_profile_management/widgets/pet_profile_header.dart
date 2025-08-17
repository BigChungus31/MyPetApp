import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PetProfileHeader extends StatelessWidget {
  final Map<String, dynamic> petData;
  final VoidCallback onEditPhoto;
  final VoidCallback onSwitchProfile;

  const PetProfileHeader({
    Key? key,
    required this.petData,
    required this.onEditPhoto,
    required this.onSwitchProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                Text(
                  'Pet Profile',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onSwitchProfile,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'swap_horiz',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Stack(
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: petData['profileImage'] ??
                          'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg',
                      width: 30.w,
                      height: 30.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditPhoto,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              petData['name'] ?? 'Unknown Pet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(petData['breed'] ?? 'Mixed'),
                SizedBox(width: 2.w),
                _buildInfoChip('${petData['age'] ?? 0} years'),
                SizedBox(width: 2.w),
                _buildInfoChip(petData['gender'] ?? 'Unknown'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
