import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/pet_profile_creation/pet_profile_creation.dart';
import '../presentation/pet_profile_management/pet_profile_management.dart';
import '../presentation/vaccination_tracker/vaccination_tracker.dart';
import '../presentation/pet_blinkit_delivery/pet_blinkit_delivery.dart';
import '../presentation/auth/signin_screen.dart';
import '../presentation/auth/signup_screen.dart';
import '../presentation/pet_friendly_venues/pet_friendly_venues.dart';

class AppRoutes {
  // Route constants
  static const String initial = splashScreen;
  static const String splashScreen = '/splash';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String dashboardHome = '/dashboard-home';
  static const String petProfileCreation = '/pet-profile-creation';
  static const String petProfileManagement = '/pet-profile-management';
  static const String vaccinationTracker = '/vaccination-tracker';
  static const String petBlinkitDelivery = '/pet-blinkit-delivery';
  static const String petFriendlyVenues = '/pet-friendly-venues';

  // Route map
  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),
    dashboardHome: (context) => const DashboardHome(),
    petProfileCreation: (context) => const PetProfileCreation(),
    petProfileManagement: (context) => const PetProfileManagement(),
    vaccinationTracker: (context) => const VaccinationTracker(),
    petBlinkitDelivery: (context) => const PetBlinkitDelivery(),
    petFriendlyVenues: (context) => const PetFriendlyVenuesScreen(),
  };
}
