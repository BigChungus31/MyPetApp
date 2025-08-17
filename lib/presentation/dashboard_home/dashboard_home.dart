import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/pet_service.dart';
import './widgets/pet_profile_header.dart';
import './widgets/pet_profile_switcher_bottom_sheet.dart';
import './widgets/recent_activities_section.dart';
import './widgets/service_grid.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final PetService _petService = PetService.instance;
  List<Map<String, dynamic>> _pets = [];
  Map<String, dynamic>? _selectedPet;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserPets();
  }

  Future<void> _loadUserPets() async {
    try {
      final pets = await _petService.getUserPets();
      setState(() {
        _pets = pets;
        _selectedPet = pets.isNotEmpty ? pets.first : null;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      // If user has no pets, navigate to pet profile creation
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.petProfileCreation);
      }
    }
  }

  void _showPetSwitcher() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PetProfileSwitcherBottomSheet(
        pets: _pets,
        currentPet: _selectedPet,
        onPetSelected: (pet) {
          setState(() => _selectedPet = pet);
        }));
  }

  Future<void> _signOut() async {
    try {
      await AuthService.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.signIn);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: ${error.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text(
          'MyPet',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800])),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
            onPressed: () {
              // TODO: Implement notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications feature coming soon!')));
            }),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[700]),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('My Profile')),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings')),
              const PopupMenuItem(
                value: 'help',
                child: Text('Help & Support')),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Sign Out')),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                _signOut();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value feature coming soon!')));
              }
            }),
        ]),
      body: RefreshIndicator(
        onRefresh: _loadUserPets,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Pet Profile Header
              PetProfileHeader(
                currentPet: _selectedPet,
                onProfileTap: _showPetSwitcher,
              ),
              
              SizedBox(height: 3.h),
              
              // Services Grid
              ServiceGrid(),
              
              SizedBox(height: 3.h),
              
              // Recent Activities
              if (_selectedPet != null)
                RecentActivitiesSection(
                  petId: _selectedPet!['id'],
                ),
              
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}