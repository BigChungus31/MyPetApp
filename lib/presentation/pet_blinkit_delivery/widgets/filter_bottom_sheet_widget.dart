import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  RangeValues _priceRange = const RangeValues(0, 5000);
  String _selectedBrand = '';
  String _selectedPetType = '';
  double _selectedRating = 0;

  final List<String> brands = [
    'Pedigree',
    'Royal Canin',
    'Whiskas',
    'Drools',
    'Farmina'
  ];
  final List<String> petTypes = ['Dog', 'Cat', 'Bird', 'Fish', 'Rabbit'];

  void _applyFilters() {
    final filters = {
      'priceRange': _priceRange,
      'brand': _selectedBrand,
      'petType': _selectedPetType,
      'rating': _selectedRating,
    };
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 5000);
      _selectedBrand = '';
      _selectedPetType = '';
      _selectedRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  Text(
                    'Price Range',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 5000,
                    divisions: 50,
                    labels: RangeLabels(
                      '₹${_priceRange.start.round()}',
                      '₹${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Brand Selection
                  Text(
                    'Brand',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: brands.map((brand) {
                      final isSelected = _selectedBrand == brand;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBrand = isSelected ? '' : brand;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: Text(
                            brand,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Pet Type Selection
                  Text(
                    'Pet Type',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: petTypes.map((petType) {
                      final isSelected = _selectedPetType == petType;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPetType = isSelected ? '' : petType;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: Text(
                            petType,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Rating Selection
                  Text(
                    'Minimum Rating',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: List.generate(5, (index) {
                      final rating = index + 1.0;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRating =
                                _selectedRating == rating ? 0 : rating;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 2.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _selectedRating >= rating
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'star',
                                color: _selectedRating >= rating
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                rating.toInt().toString(),
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: _selectedRating >= rating
                                      ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
