import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PetProfileActions extends StatelessWidget {
  final VoidCallback onAddNewPet;
  final VoidCallback onGenerateQR;
  final VoidCallback onBackupData;
  final VoidCallback onExportReport;
  final VoidCallback onDeletePet;

  const PetProfileActions({
    Key? key,
    required this.onAddNewPet,
    required this.onGenerateQR,
    required this.onBackupData,
    required this.onExportReport,
    required this.onDeletePet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: 'add',
                  title: 'Add New Pet',
                  color: AppTheme.lightTheme.primaryColor,
                  onTap: onAddNewPet,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: 'qr_code',
                  title: 'Generate QR',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  onTap: onGenerateQR,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: 'backup',
                  title: 'Backup Data',
                  color: AppTheme.successLight,
                  onTap: onBackupData,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: 'file_download',
                  title: 'Export Report',
                  color: AppTheme.warningLight,
                  onTap: onExportReport,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onDeletePet,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 5.w,
              ),
              label: Text(
                'Delete Pet Profile',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 6.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
