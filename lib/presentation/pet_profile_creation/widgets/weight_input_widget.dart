import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeightInputWidget extends StatefulWidget {
  final double? weight;
  final String unit;
  final Function(double?, String) onWeightChanged;

  const WeightInputWidget({
    Key? key,
    this.weight,
    this.unit = 'kg',
    required this.onWeightChanged,
  }) : super(key: key);

  @override
  State<WeightInputWidget> createState() => _WeightInputWidgetState();
}

class _WeightInputWidgetState extends State<WeightInputWidget> {
  late TextEditingController _weightController;
  late String _selectedUnit;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.unit;
    _weightController = TextEditingController(
      text: widget.weight?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      if (_selectedUnit == 'kg') {
        _selectedUnit = 'lbs';
        // Convert kg to lbs
        if (widget.weight != null) {
          final lbsWeight = (widget.weight! * 2.20462).toStringAsFixed(1);
          _weightController.text = lbsWeight;
          widget.onWeightChanged(double.tryParse(lbsWeight), _selectedUnit);
        }
      } else {
        _selectedUnit = 'kg';
        // Convert lbs to kg
        if (widget.weight != null) {
          final kgWeight = (widget.weight! / 2.20462).toStringAsFixed(1);
          _weightController.text = kgWeight;
          widget.onWeightChanged(double.tryParse(kgWeight), _selectedUnit);
        }
      }
    });
  }

  void _onWeightChanged(String value) {
    final weight = double.tryParse(value);
    widget.onWeightChanged(weight, _selectedUnit);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: _weightController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: 'Enter weight',
              suffixText: _selectedUnit,
              suffixStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: _onWeightChanged,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: _toggleUnit,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectedUnit == 'kg' ? 'lbs' : 'kg',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'swap_horiz',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
