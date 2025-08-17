import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AgePickerWidget extends StatefulWidget {
  final int? selectedYears;
  final int? selectedMonths;
  final Function(int years, int months) onAgeSelected;

  const AgePickerWidget({
    Key? key,
    this.selectedYears,
    this.selectedMonths,
    required this.onAgeSelected,
  }) : super(key: key);

  @override
  State<AgePickerWidget> createState() => _AgePickerWidgetState();
}

class _AgePickerWidgetState extends State<AgePickerWidget> {
  late int _tempYears;
  late int _tempMonths;

  @override
  void initState() {
    super.initState();
    _tempYears = widget.selectedYears ?? 0;
    _tempMonths = widget.selectedMonths ?? 0;
  }

  void _showAgePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 40.h,
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
              'Select Age',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: Row(
                children: [
                  // Years picker
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Years',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 40,
                            scrollController: FixedExtentScrollController(
                              initialItem: _tempYears,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() => _tempYears = index);
                            },
                            children: List.generate(
                              21,
                              (index) => Center(
                                child: Text(
                                  '$index',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Months picker
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Months',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 40,
                            scrollController: FixedExtentScrollController(
                              initialItem: _tempMonths,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() => _tempMonths = index);
                            },
                            children: List.generate(
                              12,
                              (index) => Center(
                                child: Text(
                                  '$index',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onAgeSelected(_tempYears, _tempMonths);
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getAgeText() {
    if (widget.selectedYears == null && widget.selectedMonths == null) {
      return 'Select age';
    }

    final years = widget.selectedYears ?? 0;
    final months = widget.selectedMonths ?? 0;

    if (years == 0 && months == 0) {
      return 'Less than 1 month';
    } else if (years == 0) {
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else if (months == 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    } else {
      return '$years ${years == 1 ? 'year' : 'years'}, $months ${months == 1 ? 'month' : 'months'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showAgePicker,
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
                _getAgeText(),
                style: (widget.selectedYears != null ||
                        widget.selectedMonths != null)
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
