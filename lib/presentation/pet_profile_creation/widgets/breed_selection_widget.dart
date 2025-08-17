import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BreedSelectionWidget extends StatefulWidget {
  final String? selectedBreed;
  final Function(String) onBreedSelected;

  const BreedSelectionWidget({
    Key? key,
    this.selectedBreed,
    required this.onBreedSelected,
  }) : super(key: key);

  @override
  State<BreedSelectionWidget> createState() => _BreedSelectionWidgetState();
}

class _BreedSelectionWidgetState extends State<BreedSelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredBreeds = [];

  final List<String> _popularIndianBreeds = [
    'Mixed Breed',
    'Indian Pariah Dog',
    'Labrador Retriever',
    'Golden Retriever',
    'German Shepherd',
    'Pomeranian',
    'Beagle',
    'Rottweiler',
    'Doberman',
    'Cocker Spaniel',
    'Dachshund',
    'Pug',
    'Shih Tzu',
    'Boxer',
    'Great Dane',
    'Saint Bernard',
    'Husky',
    'Bulldog',
    'Chihuahua',
    'Yorkshire Terrier',
    'Persian Cat',
    'Siamese Cat',
    'Maine Coon',
    'British Shorthair',
    'Ragdoll',
    'Bengal Cat',
    'Russian Blue',
    'Himalayan Cat',
    'Indian Street Cat',
    'Bombay Cat',
  ];

  @override
  void initState() {
    super.initState();
    _filteredBreeds = _popularIndianBreeds;
    _searchController.addListener(_filterBreeds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBreeds() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBreeds = _popularIndianBreeds
          .where((breed) => breed.toLowerCase().contains(query))
          .toList();
    });
  }

  void _showBreedModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        height: 80.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Breed',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search breeds...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredBreeds.length,
                itemBuilder: (context, index) {
                  final breed = _filteredBreeds[index];
                  final isSelected = widget.selectedBreed == breed;
                  final isPopular = index < 5 && _searchController.text.isEmpty;

                  return ListTile(
                    title: Row(
                      children: [
                        if (isPopular)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Popular',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (isPopular) SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            breed,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          )
                        : null,
                    onTap: () {
                      widget.onBreedSelected(breed);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBreedModal,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.selectedBreed ?? 'Select breed',
                style: widget.selectedBreed != null
                    ? AppTheme.lightTheme.textTheme.bodyLarge
                    : AppTheme.lightTheme.inputDecorationTheme.hintStyle,
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
