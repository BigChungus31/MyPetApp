import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivitiesSection extends StatelessWidget {
  const RecentActivitiesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentActivities = [
      {
        'type': 'appointment',
        'title': 'Vet Appointment',
        'subtitle': 'Dr. Sharma - Tomorrow 10:00 AM',
        'icon': 'local_hospital',
        'color': const Color(0xFFE3F2FD),
        'time': '2 hours ago',
      },
      {
        'type': 'vaccination',
        'title': 'Vaccination Due',
        'subtitle': 'Rabies vaccine - Due in 3 days',
        'icon': 'vaccines',
        'color': const Color(0xFFFFF3E0),
        'time': '1 day ago',
      },
      {
        'type': 'delivery',
        'title': 'Order Delivered',
        'subtitle': 'Royal Canin Dog Food - 5kg',
        'icon': 'local_shipping',
        'color': const Color(0xFFE8F5E8),
        'time': '2 days ago',
      },
      {
        'type': 'grooming',
        'title': 'Grooming Completed',
        'subtitle': 'Full grooming session at PetSpa',
        'icon': 'content_cut',
        'color': const Color(0xFFF3E5F5),
        'time': '1 week ago',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activities',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full activities page
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 16.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recentActivities.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final activity = recentActivities[index];
                return _buildActivityCard(activity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      width: 70.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: activity['color'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: activity['icon'] as String,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      activity['time'] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            activity['subtitle'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
