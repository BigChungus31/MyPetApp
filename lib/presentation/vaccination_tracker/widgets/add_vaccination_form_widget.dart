import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddVaccinationFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onVaccinationAdded;

  const AddVaccinationFormWidget({
    Key? key,
    required this.onVaccinationAdded,
  }) : super(key: key);

  @override
  State<AddVaccinationFormWidget> createState() =>
      _AddVaccinationFormWidgetState();
}

class _AddVaccinationFormWidgetState extends State<AddVaccinationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _vaccineNameController = TextEditingController();
  final _veterinarianController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedVaccineType = 'Rabies';
  DateTime _selectedDate = DateTime.now();
  DateTime? _nextDueDate;
  String _selectedClinic = 'Select Clinic';
  String _reminderTiming = '1 week before';
  XFile? _capturedCertificate;
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _showCamera = false;

  final List<String> _vaccineTypes = [
    'Rabies',
    'DHPP',
    'Bordetella',
    'Lyme Disease',
    'Canine Influenza',
    'Feline Leukemia',
    'FVRCP',
    'Other'
  ];

  final List<String> _clinics = [
    'Select Clinic',
    'PetCare Veterinary Clinic',
    'Animal Hospital Delhi',
    'Gurgaon Pet Clinic',
    'Noida Animal Care',
    'Faridabad Vet Center'
  ];

  final List<String> _reminderOptions = [
    '1 day before',
    '3 days before',
    '1 week before',
    '2 weeks before'
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _vaccineNameController.dispose();
    _veterinarianController.dispose();
    _notesController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras!.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras!.first)
              : _cameras!.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras!.first);

          _cameraController = CameraController(
            camera,
            kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
          );

          await _cameraController!.initialize();
          await _applySettings();

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Flash not supported
        }
      }
    } catch (e) {
      // Settings not supported
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedCertificate = photo;
        _showCamera = false;
      });
    } catch (e) {
      // Handle capture error silently
    }
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _capturedCertificate = image;
        });
      }
    } catch (e) {
      // Handle gallery error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      child: Form(
        key: _formKey,
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
              Text(
                'Add Vaccination Record',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),

              // Vaccine Type Dropdown
              Text(
                'Vaccine Type',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              DropdownButtonFormField<String>(
                value: _selectedVaccineType,
                decoration: InputDecoration(
                  prefixIcon: CustomIconWidget(
                    iconName: 'medical_services',
                    color: AppTheme.primaryLight,
                    size: 5.w,
                  ),
                ),
                items: _vaccineTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVaccineType = value!;
                  });
                },
              ),
              SizedBox(height: 2.h),

              // Vaccine Name (if Other is selected)
              if (_selectedVaccineType == 'Other') ...[
                Text(
                  'Vaccine Name',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _vaccineNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter vaccine name',
                    prefixIcon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.primaryLight,
                      size: 5.w,
                    ),
                  ),
                  validator: (value) {
                    if (_selectedVaccineType == 'Other' &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter vaccine name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
              ],

              // Date Administered
              Text(
                'Date Administered',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () => _selectDate(context, true),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.primaryLight,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Next Due Date
              Text(
                'Next Due Date (Optional)',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () => _selectDate(context, false),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.primaryLight,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        _nextDueDate != null
                            ? '${_nextDueDate!.day}/${_nextDueDate!.month}/${_nextDueDate!.year}'
                            : 'Select next due date',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: _nextDueDate != null
                              ? AppTheme.textPrimaryLight
                              : AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Clinic Selection
              Text(
                'Veterinary Clinic',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              DropdownButtonFormField<String>(
                value: _selectedClinic,
                decoration: InputDecoration(
                  prefixIcon: CustomIconWidget(
                    iconName: 'local_hospital',
                    color: AppTheme.primaryLight,
                    size: 5.w,
                  ),
                ),
                items: _clinics.map((clinic) {
                  return DropdownMenuItem(value: clinic, child: Text(clinic));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClinic = value!;
                  });
                },
              ),
              SizedBox(height: 2.h),

              // Veterinarian Name
              Text(
                'Veterinarian Name (Optional)',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _veterinarianController,
                decoration: InputDecoration(
                  hintText: 'Enter veterinarian name',
                  prefixIcon: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.primaryLight,
                    size: 5.w,
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Reminder Settings
              Text(
                'Reminder Timing',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              DropdownButtonFormField<String>(
                value: _reminderTiming,
                decoration: InputDecoration(
                  prefixIcon: CustomIconWidget(
                    iconName: 'notifications',
                    color: AppTheme.primaryLight,
                    size: 5.w,
                  ),
                ),
                items: _reminderOptions.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _reminderTiming = value!;
                  });
                },
              ),
              SizedBox(height: 2.h),

              // Certificate Photo Section
              Text(
                'Vaccination Certificate (Optional)',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),

              if (_capturedCertificate != null) ...[
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
                            _capturedCertificate!.path,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(_capturedCertificate!.path),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showCamera = true;
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.primaryLight,
                          size: 5.w,
                        ),
                        label: const Text('Retake'),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _capturedCertificate = null;
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.errorLight,
                          size: 5.w,
                        ),
                        label: const Text('Remove'),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showCamera = true;
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.primaryLight,
                          size: 5.w,
                        ),
                        label: const Text('Take Photo'),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickFromGallery,
                        icon: CustomIconWidget(
                          iconName: 'photo_library',
                          color: AppTheme.primaryLight,
                          size: 5.w,
                        ),
                        label: const Text('From Gallery'),
                      ),
                    ),
                  ],
                ),
              ],

              // Camera View
              if (_showCamera && _isCameraInitialized) ...[
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.w),
                    border: Border.all(
                      color: AppTheme.primaryLight,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.w),
                    child: Stack(
                      children: [
                        CameraPreview(_cameraController!),
                        Positioned(
                          bottom: 4.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showCamera = false;
                                  });
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'close',
                                    color: Colors.white,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _capturePhoto,
                                icon: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'camera',
                                    color: Colors.white,
                                    size: 8.w,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _pickFromGallery,
                                icon: Container(
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'photo_library',
                                    color: Colors.white,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: 2.h),

              // Notes
              Text(
                'Notes (Optional)',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add any additional notes...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: CustomIconWidget(
                      iconName: 'note',
                      color: AppTheme.primaryLight,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveVaccination,
                      child: const Text('Save Vaccination'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, bool isAdministeredDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isAdministeredDate ? _selectedDate : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isAdministeredDate) {
          _selectedDate = picked;
        } else {
          _nextDueDate = picked;
        }
      });
    }
  }

  void _saveVaccination() {
    if (_formKey.currentState!.validate()) {
      final vaccination = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': _selectedVaccineType == 'Other'
            ? _vaccineNameController.text
            : _selectedVaccineType,
        'type': _selectedVaccineType,
        'date':
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        'dateTime': _selectedDate,
        'nextDue': _nextDueDate != null
            ? '${_nextDueDate!.day}/${_nextDueDate!.month}/${_nextDueDate!.year}'
            : null,
        'nextDueDateTime': _nextDueDate,
        'clinic': _selectedClinic != 'Select Clinic' ? _selectedClinic : null,
        'veterinarian': _veterinarianController.text.isNotEmpty
            ? _veterinarianController.text
            : null,
        'reminderTiming': _reminderTiming,
        'notes':
            _notesController.text.isNotEmpty ? _notesController.text : null,
        'certificateImage': _capturedCertificate?.path,
        'status': 'completed',
        'batchNumber':
            'VB${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      };

      widget.onVaccinationAdded(vaccination);
      Navigator.pop(context);
    }
  }
}
