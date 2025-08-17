import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check authentication status
    final isAuthenticated = AuthService.instance.isAuthenticated;

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[50]!,
                  Colors.white,
                  Colors.blue[50]!,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animations
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(6.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withAlpha(77),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.pets,
                        size: 15.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // App Name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'MyPet',
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Your Pet Care Companion',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Making pet care easier, one step at a time',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 8.h),

                // Loading indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: 8.w,
                    height: 8.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
