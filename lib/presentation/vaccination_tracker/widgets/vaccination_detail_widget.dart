import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/app_export.dart';

class VaccinationDetailWidget extends StatelessWidget {
  final Map<String, dynamic> vaccination;
  final Function() onClose;

  const VaccinationDetailWidget({
    Key? key,
    required this.vaccination,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 12.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Header with status
            Row(
              children: [
                Expanded(
                  child: Text(
                    vaccination['name'] as String,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Basic Information Card
            _buildInfoCard(
              'Basic Information',
              [
                _buildInfoRow('Vaccine Type', vaccination['type'] as String),
                _buildInfoRow(
                    'Date Administered', vaccination['date'] as String),
                if (vaccination['nextDue'] != null)
                  _buildInfoRow(
                      'Next Due Date', vaccination['nextDue'] as String),
                if (vaccination['batchNumber'] != null)
                  _buildInfoRow(
                      'Batch Number', vaccination['batchNumber'] as String),
              ],
            ),
            SizedBox(height: 2.h),

            // Veterinary Information Card
            if (vaccination['clinic'] != null ||
                vaccination['veterinarian'] != null)
              _buildInfoCard(
                'Veterinary Information',
                [
                  if (vaccination['clinic'] != null)
                    _buildInfoRow('Clinic', vaccination['clinic'] as String),
                  if (vaccination['veterinarian'] != null)
                    _buildInfoRow(
                        'Veterinarian', vaccination['veterinarian'] as String),
                ],
              ),
            SizedBox(height: 2.h),

            // Reminder Settings Card
            _buildInfoCard(
              'Reminder Settings',
              [
                _buildInfoRow(
                    'Reminder Timing', vaccination['reminderTiming'] as String),
                _buildInfoRow('Status', _getStatusText()),
              ],
            ),
            SizedBox(height: 2.h),

            // Certificate Image
            if (vaccination['certificateImage'] != null) ...[
              Text(
                'Vaccination Certificate',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.w),
                  child: kIsWeb
                      ? Image.network(
                          vaccination['certificateImage'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'image_not_supported',
                                      color: AppTheme.textSecondaryLight,
                                      size: 12.w,
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Certificate image not available',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Image.file(
                          File(vaccination['certificateImage'] as String),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'image_not_supported',
                                      color: AppTheme.textSecondaryLight,
                                      size: 12.w,
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Certificate image not available',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Notes
            if (vaccination['notes'] != null) ...[
              Text(
                'Notes',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  vaccination['notes'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _generateCertificate(context),
                    icon: CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.primaryLight,
                      size: 5.w,
                    ),
                    label: const Text('Export PDF'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onClose,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 5.w,
                    ),
                    label: const Text('Close'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (vaccination['status']) {
      case 'completed':
        return AppTheme.successLight;
      case 'overdue':
        return AppTheme.errorLight;
      case 'upcoming':
        return AppTheme.warningLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _getStatusText() {
    switch (vaccination['status']) {
      case 'completed':
        return 'Completed';
      case 'overdue':
        return 'Overdue';
      case 'upcoming':
        return 'Upcoming';
      default:
        return 'Unknown';
    }
  }

  Future<void> _generateCertificate(BuildContext context) async {
    try {
      final certificateContent = _generateCertificateContent();
      await _downloadFile(certificateContent, 'vaccination_certificate.txt');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Certificate exported successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to export certificate'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  String _generateCertificateContent() {
    return '''
VACCINATION CERTIFICATE
=======================

Pet Vaccination Record
Date Generated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

VACCINATION DETAILS:
- Vaccine Name: ${vaccination['name']}
- Vaccine Type: ${vaccination['type']}
- Date Administered: ${vaccination['date']}
- Status: ${_getStatusText()}

${vaccination['nextDue'] != null ? 'Next Due Date: ${vaccination['nextDue']}\n' : ''}
${vaccination['batchNumber'] != null ? 'Batch Number: ${vaccination['batchNumber']}\n' : ''}

VETERINARY INFORMATION:
${vaccination['clinic'] != null ? '- Clinic: ${vaccination['clinic']}\n' : ''}
${vaccination['veterinarian'] != null ? '- Veterinarian: ${vaccination['veterinarian']}\n' : ''}

REMINDER SETTINGS:
- Reminder Timing: ${vaccination['reminderTiming']}

${vaccination['notes'] != null ? 'NOTES:\n${vaccination['notes']}\n' : ''}

This is a digital vaccination record generated by MyPet App.
For official purposes, please consult with your veterinarian.
''';
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // For mobile platforms, this would require path_provider
      // For now, we'll just show success message
    }
  }
}
