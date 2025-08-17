import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/app_routes.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Pet Blinkit',
        'subtitle': 'Fast delivery',
        'icon': Icons.local_shipping,
        'color': Colors.orange,
        'route': AppRoutes.petBlinkitDelivery,
      },
      {
        'title': 'Appointments',
        'subtitle': 'Grooming',
        'icon': Icons.content_cut,
        'color': Colors.purple,
        'route': null, // TODO: Implement grooming appointments
      },
      {
        'title': 'E-Consultations',
        'subtitle': 'Online vet',
        'icon': Icons.video_call,
        'color': Colors.green,
        'route': null, // TODO: Implement consultations
      },
      {
        'title': 'Clinic Appointments',
        'subtitle': 'NCR clinics',
        'icon': Icons.local_hospital,
        'color': Colors.red,
        'route': null, // TODO: Implement clinic appointments
      },
      {
        'title': 'Vaccination Tracker',
        'subtitle': 'Track vaccines',
        'icon': Icons.medical_services,
        'color': Colors.blue,
        'route': AppRoutes.vaccinationTracker,
      },
      {
        'title': 'Insurance',
        'subtitle': 'Pet insurance',
        'icon': Icons.security,
        'color': Colors.indigo,
        'route': null, // TODO: Implement insurance
      },
      {
        'title': 'Pet Friendly Cafes',
        'subtitle': 'Find venues',
        'icon': Icons.restaurant,
        'color': Colors.brown,
        'route': AppRoutes.petFriendlyVenues,
      },
      {
        'title': 'Vets Near Me',
        'subtitle': 'Find vets',
        'icon': Icons.location_on,
        'color': Colors.teal,
        'route': null, // TODO: Implement vet locator
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 3.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(context, service);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        if (service['route'] != null) {
          Navigator.pushNamed(context, service['route']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${service['title']} feature coming soon!'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: (service['color'] as Color).withAlpha(26),
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: (service['color'] as Color).withAlpha(51),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: service['color'],
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Icon(
                service['icon'],
                color: Colors.white,
                size: 6.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              service['title'],
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              service['subtitle'],
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
