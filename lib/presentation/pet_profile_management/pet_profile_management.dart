import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/info_row.dart';
import './widgets/medical_condition_card.dart';
import './widgets/pet_profile_actions.dart';
import './widgets/pet_profile_header.dart';
import './widgets/photo_edit_bottom_sheet.dart';
import './widgets/profile_section_card.dart';
import './widgets/weight_chart_widget.dart';

class PetProfileManagement extends StatefulWidget {
  const PetProfileManagement({Key? key}) : super(key: key);

  @override
  State<PetProfileManagement> createState() => _PetProfileManagementState();
}

class _PetProfileManagementState extends State<PetProfileManagement> {
  final ImagePicker _imagePicker = ImagePicker();

  // Expanded sections state
  Map<String, bool> expandedSections = {
    'basic': true,
    'medical': false,
    'emergency': false,
    'insurance': false,
    'weight': false,
    'conditions': false,
    'gallery': false,
  };

  // Current pet data
  int currentPetIndex = 0;

  // Mock pet data
  final List<Map<String, dynamic>> petProfiles = [
    {
      "id": 1,
      "name": "Buddy",
      "breed": "Golden Retriever",
      "age": 3,
      "gender": "Male",
      "weight": 28.5,
      "targetWeight": 30.0,
      "profileImage":
          "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg",
      "microchipId": "982000123456789",
      "dateOfBirth": "2021-05-15",
      "color": "Golden",
      "allergies": "Chicken, Wheat",
      "medications": "Heartgard Plus (monthly)",
      "medicalConditions": "Hip Dysplasia (mild)",
      "preferredVet": "Dr. Sarah Johnson - Pet Care Clinic",
      "emergencyContact": "John Smith - +91 9876543210",
      "insuranceProvider": "Pet Assure India",
      "policyNumber": "PA-IND-2024-001234",
      "coverageDetails":
          "Comprehensive coverage including accidents, illness, and wellness",
      "weightHistory": [
        {"date": "2024-06-01", "weight": 27.2},
        {"date": "2024-07-01", "weight": 27.8},
        {"date": "2024-08-01", "weight": 28.5},
      ],
      "medicalConditionsList": [
        {
          "name": "Hip Dysplasia",
          "severity": "Low",
          "description": "Mild hip dysplasia detected during routine checkup",
          "treatment": "Joint supplements and controlled exercise",
          "diagnosedDate": "2024-03-15"
        }
      ],
      "photoGallery": [
        "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg",
        "https://images.pexels.com/photos/1805164/pexels-photo-1805164.jpeg",
        "https://images.pexels.com/photos/2253275/pexels-photo-2253275.jpeg",
      ]
    },
    {
      "id": 2,
      "name": "Whiskers",
      "breed": "Persian Cat",
      "age": 2,
      "gender": "Female",
      "weight": 4.2,
      "targetWeight": 4.5,
      "profileImage":
          "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg",
      "microchipId": "982000987654321",
      "dateOfBirth": "2022-08-20",
      "color": "White",
      "allergies": "None known",
      "medications": "None",
      "medicalConditions": "None",
      "preferredVet": "Dr. Priya Sharma - Feline Care Center",
      "emergencyContact": "Jane Doe - +91 9876543211",
      "insuranceProvider": "Bajaj Allianz Pet Insurance",
      "policyNumber": "BA-PET-2024-005678",
      "coverageDetails": "Basic coverage for accidents and major illnesses",
      "weightHistory": [
        {"date": "2024-06-01", "weight": 3.8},
        {"date": "2024-07-01", "weight": 4.0},
        {"date": "2024-08-01", "weight": 4.2},
      ],
      "medicalConditionsList": [],
      "photoGallery": [
        "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg",
        "https://images.pexels.com/photos/416160/pexels-photo-416160.jpeg",
      ]
    }
  ];

  Map<String, dynamic> get currentPet => petProfiles[currentPetIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PetProfileHeader(
              petData: currentPet,
              onEditPhoto: _showPhotoEditBottomSheet,
              onSwitchProfile: _showProfileSwitcher,
            ),
            SizedBox(height: 2.h),
            _buildBasicDetailsSection(),
            _buildMedicalHistorySection(),
            _buildEmergencyContactsSection(),
            _buildInsuranceSection(),
            _buildWeightTrackingSection(),
            _buildMedicalConditionsSection(),
            _buildPhotoGallerySection(),
            PetProfileActions(
              onAddNewPet: _addNewPet,
              onGenerateQR: _generateQRCode,
              onBackupData: _backupData,
              onExportReport: _exportReport,
              onDeletePet: _showDeleteConfirmation,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicDetailsSection() {
    return ProfileSectionCard(
      title: 'Basic Details',
      icon: Icons.pets,
      isExpanded: expandedSections['basic']!,
      onToggle: () => _toggleSection('basic'),
      onEdit: () => _editBasicDetails(),
      children: [
        InfoRow(
          label: 'Name',
          value: currentPet['name'] ?? '',
          onEdit: () => _editField('name'),
        ),
        InfoRow(
          label: 'Breed',
          value: currentPet['breed'] ?? '',
          onEdit: () => _editField('breed'),
        ),
        InfoRow(
          label: 'Age',
          value: '${currentPet['age'] ?? 0} years',
          onEdit: () => _editField('age'),
        ),
        InfoRow(
          label: 'Gender',
          value: currentPet['gender'] ?? '',
          onEdit: () => _editField('gender'),
        ),
        InfoRow(
          label: 'Weight',
          value: '${currentPet['weight'] ?? 0} kg',
          onEdit: () => _editField('weight'),
        ),
        InfoRow(
          label: 'Color',
          value: currentPet['color'] ?? '',
          onEdit: () => _editField('color'),
        ),
        InfoRow(
          label: 'Date of Birth',
          value: _formatDate(currentPet['dateOfBirth'] ?? ''),
          onEdit: () => _editField('dateOfBirth'),
        ),
        InfoRow(
          label: 'Microchip ID',
          value: currentPet['microchipId'] ?? '',
          onEdit: () => _editField('microchipId'),
        ),
      ],
    );
  }

  Widget _buildMedicalHistorySection() {
    return ProfileSectionCard(
      title: 'Medical History',
      icon: Icons.medical_services,
      isExpanded: expandedSections['medical']!,
      onToggle: () => _toggleSection('medical'),
      onEdit: () => _editMedicalHistory(),
      children: [
        InfoRow(
          label: 'Allergies',
          value: currentPet['allergies'] ?? '',
          onEdit: () => _editField('allergies'),
        ),
        InfoRow(
          label: 'Current Medications',
          value: currentPet['medications'] ?? '',
          onEdit: () => _editField('medications'),
        ),
        InfoRow(
          label: 'Medical Conditions',
          value: currentPet['medicalConditions'] ?? '',
          onEdit: () => _editField('medicalConditions'),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactsSection() {
    return ProfileSectionCard(
      title: 'Emergency Contacts',
      icon: Icons.emergency,
      isExpanded: expandedSections['emergency']!,
      onToggle: () => _toggleSection('emergency'),
      onEdit: () => _editEmergencyContacts(),
      children: [
        InfoRow(
          label: 'Preferred Vet',
          value: currentPet['preferredVet'] ?? '',
          onEdit: () => _editField('preferredVet'),
        ),
        InfoRow(
          label: 'Emergency Contact',
          value: currentPet['emergencyContact'] ?? '',
          onEdit: () => _editField('emergencyContact'),
        ),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return ProfileSectionCard(
      title: 'Insurance Information',
      icon: Icons.security,
      isExpanded: expandedSections['insurance']!,
      onToggle: () => _toggleSection('insurance'),
      onEdit: () => _editInsurance(),
      children: [
        InfoRow(
          label: 'Insurance Provider',
          value: currentPet['insuranceProvider'] ?? '',
          onEdit: () => _editField('insuranceProvider'),
        ),
        InfoRow(
          label: 'Policy Number',
          value: currentPet['policyNumber'] ?? '',
          onEdit: () => _editField('policyNumber'),
        ),
        InfoRow(
          label: 'Coverage Details',
          value: currentPet['coverageDetails'] ?? '',
          onEdit: () => _editField('coverageDetails'),
        ),
      ],
    );
  }

  Widget _buildWeightTrackingSection() {
    return ProfileSectionCard(
      title: 'Weight Tracking',
      icon: Icons.timeline,
      isExpanded: expandedSections['weight']!,
      onToggle: () => _toggleSection('weight'),
      onEdit: () => _addWeightEntry(),
      children: [
        WeightChartWidget(
          weightHistory: (currentPet['weightHistory'] as List)
              .cast<Map<String, dynamic>>(),
          targetWeight: (currentPet['targetWeight'] as num).toDouble(),
        ),
      ],
    );
  }

  Widget _buildMedicalConditionsSection() {
    final conditions = (currentPet['medicalConditionsList'] as List)
        .cast<Map<String, dynamic>>();

    return ProfileSectionCard(
      title: 'Medical Conditions',
      icon: Icons.local_hospital,
      isExpanded: expandedSections['conditions']!,
      onToggle: () => _toggleSection('conditions'),
      onEdit: () => _addMedicalCondition(),
      children: conditions.isNotEmpty
          ? conditions
              .map((condition) => MedicalConditionCard(
                    condition: condition,
                    onEdit: () => _editMedicalCondition(condition),
                    onDelete: () => _deleteMedicalCondition(condition),
                  ))
              .toList()
          : [
              Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'medical_services',
                      color: AppTheme.lightTheme.textTheme.bodySmall?.color ??
                          Colors.grey,
                      size: 8.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No medical conditions recorded',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
    );
  }

  Widget _buildPhotoGallerySection() {
    final photos = (currentPet['photoGallery'] as List).cast<String>();

    return ProfileSectionCard(
      title: 'Photo Gallery',
      icon: Icons.photo_library,
      isExpanded: expandedSections['gallery']!,
      onToggle: () => _toggleSection('gallery'),
      onEdit: () => _addPhoto(),
      children: [
        photos.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.w,
                  childAspectRatio: 1,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _viewPhoto(photos[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.shadowColor,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: photos[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.lightTheme.textTheme.bodySmall?.color ??
                          Colors.grey,
                      size: 8.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No photos added yet',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  void _toggleSection(String section) {
    setState(() {
      expandedSections[section] = !expandedSections[section]!;
    });
  }

  void _showPhotoEditBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PhotoEditBottomSheet(
        onImageSourceSelected: _updateProfilePhoto,
        onRemovePhoto: _removeProfilePhoto,
      ),
    );
  }

  void _updateProfilePhoto(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          currentPet['profileImage'] = image.path;
        });
        Fluttertoast.showToast(
          msg: "Profile photo updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update photo",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _removeProfilePhoto() {
    setState(() {
      currentPet['profileImage'] =
          'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg';
    });
    Fluttertoast.showToast(
      msg: "Profile photo removed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showProfileSwitcher() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Switch Pet Profile',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ...petProfiles.asMap().entries.map((entry) {
              final index = entry.key;
              final pet = entry.value;
              final isSelected = index == currentPetIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentPetIndex = index;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.dividerColor,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: CustomImageWidget(
                            imageUrl: pet['profileImage'] ?? '',
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet['name'] ?? 'Unknown',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : null,
                              ),
                            ),
                            Text(
                              '${pet['breed']} • ${pet['age']} years',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 6.w,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _addNewPet() {
    Navigator.pushNamed(context, '/pet-profile-creation');
  }

  void _generateQRCode() {
    Fluttertoast.showToast(
      msg: "QR Code generated for ${currentPet['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _backupData() {
    Fluttertoast.showToast(
      msg: "Pet data backed up successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _exportReport() {
    Fluttertoast.showToast(
      msg: "Pet report exported successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Pet Profile',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${currentPet['name']}\'s profile? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.textTheme.bodySmall?.color,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePet();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deletePet() {
    if (petProfiles.length > 1) {
      setState(() {
        petProfiles.removeAt(currentPetIndex);
        if (currentPetIndex >= petProfiles.length) {
          currentPetIndex = petProfiles.length - 1;
        }
      });
      Fluttertoast.showToast(
        msg: "Pet profile deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Cannot delete the last pet profile",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _editBasicDetails() {
    Fluttertoast.showToast(
      msg: "Edit basic details",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _editMedicalHistory() {
    Fluttertoast.showToast(
      msg: "Edit medical history",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _editEmergencyContacts() {
    Fluttertoast.showToast(
      msg: "Edit emergency contacts",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _editInsurance() {
    Fluttertoast.showToast(
      msg: "Edit insurance information",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _addWeightEntry() {
    Fluttertoast.showToast(
      msg: "Add weight entry",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _addMedicalCondition() {
    Fluttertoast.showToast(
      msg: "Add medical condition",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _editMedicalCondition(Map<String, dynamic> condition) {
    Fluttertoast.showToast(
      msg: "Edit ${condition['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _deleteMedicalCondition(Map<String, dynamic> condition) {
    setState(() {
      (currentPet['medicalConditionsList'] as List).remove(condition);
    });
    Fluttertoast.showToast(
      msg: "${condition['name']} removed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _addPhoto() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          (currentPet['photoGallery'] as List).add(image.path);
        });
        Fluttertoast.showToast(
          msg: "Photo added to gallery",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to add photo",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _viewPhoto(String photoUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 90.w,
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: photoUrl,
                width: 90.w,
                height: 60.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editField(String fieldName) {
    Fluttertoast.showToast(
      msg: "Edit $fieldName",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
