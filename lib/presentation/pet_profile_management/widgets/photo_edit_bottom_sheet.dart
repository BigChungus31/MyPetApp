import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PhotoEditBottomSheet extends StatelessWidget {
  final Function(ImageSource) onImageSourceSelected;
  final VoidCallback onRemovePhoto;

  const PhotoEditBottomSheet({
    Key? key,
    required this.onImageSourceSelected,
    required this.onRemovePhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Update Pet Photo',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildOptionTile(
            context,
            icon: 'camera_alt',
            title: 'Take Photo',
            subtitle: 'Use camera to capture new photo',
            onTap: () {
              Navigator.pop(context);
              onImageSourceSelected(ImageSource.camera);
            },
          ),
          _buildOptionTile(
            context,
            icon: 'photo_library',
            title: 'Choose from Gallery',
            subtitle: 'Select from existing photos',
            onTap: () {
              Navigator.pop(context);
              onImageSourceSelected(ImageSource.gallery);
            },
          ),
          _buildOptionTile(
            context,
            icon: 'delete',
            title: 'Remove Photo',
            subtitle: 'Use default pet avatar',
            onTap: () {
              Navigator.pop(context);
              onRemovePhoto();
            },
            isDestructive: true,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppTheme.lightTheme.colorScheme.error
        : AppTheme.lightTheme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: color,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
