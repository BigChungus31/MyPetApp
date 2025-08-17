import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PetPhotoUploadWidget extends StatefulWidget {
  final Function(XFile?) onPhotoSelected;
  final XFile? selectedPhoto;

  const PetPhotoUploadWidget({
    Key? key,
    required this.onPhotoSelected,
    this.selectedPhoto,
  }) : super(key: key);

  @override
  State<PetPhotoUploadWidget> createState() => _PetPhotoUploadWidgetState();
}

class _PetPhotoUploadWidgetState extends State<PetPhotoUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final camera = kIsWeb
            ? _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
                orElse: () => _cameras.first)
            : _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back,
                orElse: () => _cameras.first);

        _cameraController = CameraController(
            camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);
        await _cameraController!.initialize();
        await _applySettings();
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<void> _applySettings() async {
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}
    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (!await _requestCameraPermission()) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onPhotoSelected(photo);
      Navigator.pop(context);
    } catch (e) {
      // Handle error gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture photo')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (photo != null) {
        widget.onPhotoSelected(photo);
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to select photo')),
      );
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Add Pet Photo',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            if (_isCameraInitialized && _cameraController != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Take Photo',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: _capturePhoto,
              ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Choose from Gallery',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: _pickFromGallery,
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text(
                'Skip for Now',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                widget.onPhotoSelected(null);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPhotoOptions,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 2,
          ),
        ),
        child: widget.selectedPhoto != null
            ? ClipOval(
                child: kIsWeb
                    ? Image.network(
                        widget.selectedPhoto!.path,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      )
                    : CustomImageWidget(
                        imageUrl: widget.selectedPhoto!.path,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Add Photo',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
