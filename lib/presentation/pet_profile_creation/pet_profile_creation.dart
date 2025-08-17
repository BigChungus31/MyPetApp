import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/age_picker_widget.dart';
import './widgets/breed_selection_widget.dart';
import './widgets/gender_selection_widget.dart';
import './widgets/pet_photo_upload_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/weight_input_widget.dart';

class PetProfileCreation extends StatefulWidget {
  const PetProfileCreation({Key? key}) : super(key: key);

  @override
  State<PetProfileCreation> createState() => _PetProfileCreationState();
}

class _PetProfileCreationState extends State<PetProfileCreation> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scrollController = ScrollController();

  // Form data
  XFile? _selectedPhoto;
  String? _selectedBreed;
  int? _selectedYears;
  int? _selectedMonths;
  double? _weight;
  String _weightUnit = 'kg';
  String? _selectedGender;
  bool _isVaccinated = false;
  bool _hasInsurance = false;
  final _insuranceController = TextEditingController();

  // UI state
  bool _hasUnsavedChanges = false;
  int _nameCharacterCount = 0;
  final int _maxNameLength = 30;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _insuranceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    setState(() {
      _nameCharacterCount = _nameController.text.length;
      _hasUnsavedChanges = true;
    });
  }

  void _onPhotoSelected(XFile? photo) {
    setState(() {
      _selectedPhoto = photo;
      _hasUnsavedChanges = true;
    });
  }

  void _onBreedSelected(String breed) {
    setState(() {
      _selectedBreed = breed;
      _hasUnsavedChanges = true;
    });
  }

  void _onAgeSelected(int years, int months) {
    setState(() {
      _selectedYears = years;
      _selectedMonths = months;
      _hasUnsavedChanges = true;
    });
  }

  void _onWeightChanged(double? weight, String unit) {
    setState(() {
      _weight = weight;
      _weightUnit = unit;
      _hasUnsavedChanges = true;
    });
  }

  void _onGenderSelected(String gender) {
    setState(() {
      _selectedGender = gender;
      _hasUnsavedChanges = true;
    });
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
        _selectedBreed != null &&
        (_selectedYears != null || _selectedMonths != null) &&
        _selectedGender != null;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Unsaved Changes',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to go back?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Leave',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _savePetProfile() {
    if (!_isFormValid()) return;

    // Show success animation and navigate
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Profile Created!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '${_nameController.text}\'s profile has been successfully created.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resetForm();
                  },
                  child: Text('Add Another Pet'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/dashboard-home');
                  },
                  child: Text('Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _selectedPhoto = null;
      _selectedBreed = null;
      _selectedYears = null;
      _selectedMonths = null;
      _weight = null;
      _weightUnit = 'kg';
      _selectedGender = null;
      _isVaccinated = false;
      _hasInsurance = false;
      _insuranceController.clear();
      _hasUnsavedChanges = false;
      _nameCharacterCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              ProgressIndicatorWidget(
                currentStep: 1,
                totalSteps: 3,
              ),

              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (await _onWillPop()) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Pet Profile',
                            style: AppTheme.lightTheme.textTheme.titleLarge,
                          ),
                          Text(
                            'Tell us about your furry friend',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.h),

                        // Pet photo upload
                        Center(
                          child: PetPhotoUploadWidget(
                            selectedPhoto: _selectedPhoto,
                            onPhotoSelected: _onPhotoSelected,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Pet name
                        Text(
                          'Pet Name *',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _nameController,
                          maxLength: _maxNameLength,
                          decoration: InputDecoration(
                            hintText: 'Enter your pet\'s name',
                            counterText: '$_nameCharacterCount/$_maxNameLength',
                            counterStyle: AppTheme
                                .lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: _nameCharacterCount > _maxNameLength * 0.8
                                  ? AppTheme.lightTheme.colorScheme.error
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your pet\'s name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Breed selection
                        Text(
                          'Breed *',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        BreedSelectionWidget(
                          selectedBreed: _selectedBreed,
                          onBreedSelected: _onBreedSelected,
                        ),

                        SizedBox(height: 3.h),

                        // Age selection
                        Text(
                          'Age *',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        AgePickerWidget(
                          selectedYears: _selectedYears,
                          selectedMonths: _selectedMonths,
                          onAgeSelected: _onAgeSelected,
                        ),

                        SizedBox(height: 3.h),

                        // Weight input
                        Text(
                          'Weight',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        WeightInputWidget(
                          weight: _weight,
                          unit: _weightUnit,
                          onWeightChanged: _onWeightChanged,
                        ),

                        SizedBox(height: 3.h),

                        // Gender selection
                        Text(
                          'Gender *',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        GenderSelectionWidget(
                          selectedGender: _selectedGender,
                          onGenderSelected: _onGenderSelected,
                        ),

                        SizedBox(height: 4.h),

                        // Medical information section
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'medical_services',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Medical Information',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),

                              // Vaccination status
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Is your pet vaccinated?',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyLarge,
                                    ),
                                  ),
                                  Switch(
                                    value: _isVaccinated,
                                    onChanged: (value) {
                                      setState(() {
                                        _isVaccinated = value;
                                        _hasUnsavedChanges = true;
                                      });
                                    },
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.h),

                              // Insurance status
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Does your pet have insurance?',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyLarge,
                                    ),
                                  ),
                                  Switch(
                                    value: _hasInsurance,
                                    onChanged: (value) {
                                      setState(() {
                                        _hasInsurance = value;
                                        _hasUnsavedChanges = true;
                                      });
                                    },
                                  ),
                                ],
                              ),

                              if (_hasInsurance) ...[
                                SizedBox(height: 2.h),
                                TextField(
                                  controller: _insuranceController,
                                  decoration: InputDecoration(
                                    hintText: 'Insurance provider (optional)',
                                    prefixIcon: CustomIconWidget(
                                      iconName: 'shield',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 20,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() => _hasUnsavedChanges = true);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h), // Space for sticky button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Sticky continue button
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: _isFormValid() ? _savePetProfile : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: _isFormValid()
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.38),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: _isFormValid()
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.38),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
