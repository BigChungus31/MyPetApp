import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../core/app_export.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text);

      if (mounted) {
        Fluttertoast.showToast(
            msg: "Welcome back! Signed in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);

        Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
      }
    } catch (error) {
      if (mounted) {
        Fluttertoast.showToast(
            msg: "Sign in failed. Please check your credentials.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 8.h),

                          // Logo and App Name
                          Center(
                              child: Column(children: [
                            Container(
                                width: 20.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(4.w)),
                                child: Icon(Icons.pets,
                                    size: 10.w, color: Colors.blue[600])),
                            SizedBox(height: 2.h),
                            Text('MyPet',
                                style: GoogleFonts.inter(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800])),
                            SizedBox(height: 1.h),
                            Text('Welcome back to your pet care companion',
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp, color: Colors.grey[600]),
                                textAlign: TextAlign.center),
                          ])),

                          SizedBox(height: 6.h),

                          // Email Field
                          TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                      borderSide: BorderSide(
                                          color: Colors.blue[600]!))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              }),

                          SizedBox(height: 3.h),

                          // Password Field
                          TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  suffixIcon: IconButton(
                                      icon: Icon(_obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      }),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                      borderSide: BorderSide(
                                          color: Colors.blue[600]!))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              }),

                          SizedBox(height: 2.h),

                          // Forgot Password
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {
                                    // TODO: Implement forgot password
                                    Fluttertoast.showToast(
                                        msg:
                                            "Forgot password feature coming soon!",
                                        toastLength: Toast.LENGTH_SHORT);
                                  },
                                  child: Text('Forgot Password?',
                                      style: GoogleFonts.inter(
                                          color: Colors.blue[600],
                                          fontWeight: FontWeight.w500)))),

                          SizedBox(height: 4.h),

                          // Sign In Button
                          SizedBox(
                              height: 6.h,
                              child: ElevatedButton(
                                  onPressed: _isLoading ? null : _signIn,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[600],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.w)),
                                      elevation: 0),
                                  child: _isLoading
                                      ? SizedBox(
                                          width: 5.w,
                                          height: 5.w,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white))
                                      : Text('Sign In',
                                          style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)))),

                          SizedBox(height: 4.h),

                          // Divider
                          Row(children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Text('Or continue with',
                                    style: GoogleFonts.inter(
                                        color: Colors.grey[600],
                                        fontSize: 12.sp))),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ]),

                          SizedBox(height: 3.h),

                          // Mock Credentials Info Box
                          Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(2.w),
                                  border: Border.all(color: Colors.blue[200]!)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Icon(Icons.info_outline,
                                          color: Colors.blue[600], size: 4.w),
                                      SizedBox(width: 2.w),
                                      Text('Demo Credentials',
                                          style: GoogleFonts.inter(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue[700])),
                                    ]),
                                    SizedBox(height: 2.h),
                                    Text(
                                        'Email: sarah.owner@example.com\nPassword: petlover123',
                                        style: GoogleFonts.inter(
                                            fontSize: 11.sp,
                                            color: Colors.blue[700])),
                                    SizedBox(height: 1.h),
                                    Text('Or',
                                        style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            color: Colors.blue[600])),
                                    Text(
                                        'Email: rahul.petowner@example.com\nPassword: doglover456',
                                        style: GoogleFonts.inter(
                                            fontSize: 11.sp,
                                            color: Colors.blue[700])),
                                  ])),

                          SizedBox(height: 4.h),

                          // Sign Up Link
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? ",
                                    style: GoogleFonts.inter(
                                        color: Colors.grey[600],
                                        fontSize: 12.sp)),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AppRoutes.signUp);
                                    },
                                    child: Text('Sign Up',
                                        style: GoogleFonts.inter(
                                            color: Colors.blue[600],
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600))),
                              ]),

                          SizedBox(height: 2.h),
                        ])))));
  }
}
