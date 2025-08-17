import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_vaccination_form_widget.dart';
import './widgets/pet_profile_switcher_widget.dart';
import './widgets/vaccination_detail_widget.dart';
import './widgets/vaccination_filter_widget.dart';
import './widgets/vaccination_timeline_widget.dart';

class VaccinationTracker extends StatefulWidget {
  const VaccinationTracker({Key? key}) : super(key: key);

  @override
  State<VaccinationTracker> createState() => _VaccinationTrackerState();
}

class _VaccinationTrackerState extends State<VaccinationTracker> {
  int _selectedPetIndex = 0;
  String _selectedFilter = 'all';
  List<Map<String, dynamic>> _vaccinations = [];

  // Mock pet data
  final List<Map<String, dynamic>> _pets = [
    {
      'id': 1,
      'name': 'Buddy',
      'breed': 'Golden Retriever',
      'age': '3 years',
      'image':
          'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&w=500',
    },
    {
      'id': 2,
      'name': 'Whiskers',
      'breed': 'Persian Cat',
      'age': '2 years',
      'image':
          'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&w=500',
    },
    {
      'id': 3,
      'name': 'Max',
      'breed': 'German Shepherd',
      'age': '5 years',
      'image':
          'https://images.pexels.com/photos/333083/pexels-photo-333083.jpeg?auto=compress&cs=tinysrgb&w=500',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMockVaccinations();
  }

  void _loadMockVaccinations() {
    final now = DateTime.now();
    _vaccinations = [
      {
        'id': 1,
        'name': 'Rabies Vaccination',
        'type': 'Rabies',
        'date': '15/07/2024',
        'dateTime': DateTime(2024, 7, 15),
        'nextDue': '15/07/2025',
        'nextDueDateTime': DateTime(2025, 7, 15),
        'clinic': 'PetCare Veterinary Clinic',
        'veterinarian': 'Dr. Priya Sharma',
        'status': 'completed',
        'batchNumber': 'VB123456789',
        'reminderTiming': '1 week before',
        'notes':
            'Pet showed no adverse reactions. Next booster due in 12 months.',
      },
      {
        'id': 2,
        'name': 'DHPP Vaccination',
        'type': 'DHPP',
        'date': '20/06/2024',
        'dateTime': DateTime(2024, 6, 20),
        'nextDue': '20/06/2025',
        'nextDueDateTime': DateTime(2025, 6, 20),
        'clinic': 'Animal Hospital Delhi',
        'veterinarian': 'Dr. Rajesh Kumar',
        'status': 'completed',
        'batchNumber': 'VB987654321',
        'reminderTiming': '3 days before',
      },
      {
        'id': 3,
        'name': 'Bordetella Vaccination',
        'type': 'Bordetella',
        'date': '25/08/2024',
        'dateTime': DateTime(2024, 8, 25),
        'nextDue': '25/02/2025',
        'nextDueDateTime': DateTime(2025, 2, 25),
        'clinic': 'Gurgaon Pet Clinic',
        'veterinarian': 'Dr. Anjali Verma',
        'status': now.isAfter(DateTime(2025, 2, 25)) ? 'overdue' : 'upcoming',
        'batchNumber': 'VB456789123',
        'reminderTiming': '1 week before',
        'notes': 'Annual booster required for kennel cough prevention.',
      },
      {
        'id': 4,
        'name': 'Lyme Disease Vaccination',
        'type': 'Lyme Disease',
        'date': '10/05/2024',
        'dateTime': DateTime(2024, 5, 10),
        'nextDue': '10/05/2025',
        'nextDueDateTime': DateTime(2025, 5, 10),
        'clinic': 'Noida Animal Care',
        'veterinarian': 'Dr. Suresh Gupta',
        'status': 'completed',
        'batchNumber': 'VB789123456',
        'reminderTiming': '2 weeks before',
      },
      {
        'id': 5,
        'name': 'Canine Influenza',
        'type': 'Canine Influenza',
        'date': '15/09/2024',
        'dateTime': DateTime(2024, 9, 15),
        'nextDue': '15/09/2025',
        'nextDueDateTime': DateTime(2025, 9, 15),
        'clinic': 'Faridabad Vet Center',
        'veterinarian': 'Dr. Meera Jain',
        'status': 'upcoming',
        'batchNumber': 'VB321654987',
        'reminderTiming': '1 day before',
        'notes': 'Seasonal vaccination recommended for high-risk areas.',
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredVaccinations {
    switch (_selectedFilter) {
      case 'completed':
        return _vaccinations.where((v) => v['status'] == 'completed').toList();
      case 'upcoming':
        return _vaccinations.where((v) => v['status'] == 'upcoming').toList();
      case 'overdue':
        return _vaccinations.where((v) => v['status'] == 'overdue').toList();
      default:
        return _vaccinations;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Pet Profile Switcher
            PetProfileSwitcherWidget(
              pets: _pets,
              selectedPetIndex: _selectedPetIndex,
              onPetSelected: (index) {
                setState(() {
                  _selectedPetIndex = index;
                });
              },
            ),

            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.textPrimaryLight,
                      size: 6.w,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Vaccination Tracker',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showCalendarIntegration(context),
                    icon: CustomIconWidget(
                      iconName: 'calendar_month',
                      color: AppTheme.primaryLight,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Section
            VaccinationFilterWidget(
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              onSearchTap: () => _showSearchDialog(context),
            ),

            // Vaccination Statistics
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total',
                      _vaccinations.length.toString(),
                      AppTheme.primaryLight,
                      'vaccines',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 8.h,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  Expanded(
                    child: _buildStatCard(
                      'Completed',
                      _vaccinations
                          .where((v) => v['status'] == 'completed')
                          .length
                          .toString(),
                      AppTheme.successLight,
                      'check_circle',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 8.h,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  Expanded(
                    child: _buildStatCard(
                      'Upcoming',
                      _vaccinations
                          .where((v) => v['status'] == 'upcoming')
                          .length
                          .toString(),
                      AppTheme.warningLight,
                      'schedule',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            // Vaccination Timeline
            Expanded(
              child: _filteredVaccinations.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: VaccinationTimelineWidget(
                        vaccinations: _filteredVaccinations,
                        onVaccinationTap: (vaccination) =>
                            _showVaccinationDetail(context, vaccination),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVaccinationForm(context),
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
        label: const Text('Add Vaccination'),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, Color color, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 8.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'medical_services',
            color: AppTheme.textSecondaryLight.withValues(alpha: 0.5),
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            _selectedFilter == 'all'
                ? 'No vaccination records found'
                : 'No ${_selectedFilter} vaccinations',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _selectedFilter == 'all'
                ? 'Add your first vaccination record to get started'
                : 'Try changing the filter to see more records',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          if (_selectedFilter == 'all')
            ElevatedButton.icon(
              onPressed: () => _showAddVaccinationForm(context),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: const Text('Add Vaccination'),
            ),
        ],
      ),
    );
  }

  void _showAddVaccinationForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddVaccinationFormWidget(
          onVaccinationAdded: (vaccination) {
            setState(() {
              _vaccinations.add(vaccination);
              _vaccinations.sort((a, b) => (b['dateTime'] as DateTime)
                  .compareTo(a['dateTime'] as DateTime));
            });
          },
        ),
      ),
    );
  }

  void _showVaccinationDetail(
      BuildContext context, Map<String, dynamic> vaccination) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VaccinationDetailWidget(
        vaccination: vaccination,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Search Vaccinations',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by vaccine name or veterinarian...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.primaryLight,
                  size: 5.w,
                ),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
            SizedBox(height: 2.h),
            Text(
              'Search functionality will filter vaccinations by vaccine name, veterinarian, or clinic.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showCalendarIntegration(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'calendar_month',
              color: AppTheme.primaryLight,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Calendar Integration',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync vaccination schedules with your device calendar for better visibility and reminders.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.primaryLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Upcoming vaccinations will be added to your calendar with reminders.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calendar sync enabled successfully'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: const Text('Enable Sync'),
          ),
        ],
      ),
    );
  }
}
