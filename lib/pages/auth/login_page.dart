import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/bottom_navigation/bottom_navigation.dart';
import 'package:food_inventory_tracking_app/util/utils.dart';
import 'package:provider/provider.dart';

import 'package:food_inventory_tracking_app/pages/auth/provider/firebase_auth_provider.dart';
import 'package:food_inventory_tracking_app/pages/auth/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // For password visibility toggle

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55ab55),
        elevation: 0,
        title: const Text(
          'Login Here',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with green background and app title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF55ab55),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.inventory_2_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Digi Pantry',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage your food, reduce waste',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Login Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Login',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xFF333333),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // const Text(
                  //   'Welcome back! Please sign in to continue',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Color(0xFF666666),
                  //   ),
                  // ),
                  // const SizedBox(height: 30),

                  // Email field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'your.email@example.com',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      prefixIcon:
                          const Icon(Icons.email, color: Color(0xFF55ab55)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(0xFF55ab55), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFF55ab55)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(0xFF55ab55), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // // Forgot password
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // Add forgot password functionality
                  //     },
                  //     child: const Text(
                  //       'Forgot Password?',
                  //       style: TextStyle(
                  //         color: Color(0xFF55ab55),
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 30),

                  // Login button
                  Consumer<FirebaseAuthProvider>(
                      builder: (context, provider, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          final res = await provider.signInWithEmailandPassword(
                              emailController.text.trim(),
                              passwordController.text.trim());

                          if (context.mounted) {
                            if (res) {
                              moveTo(context, const BottomNavigationPage());
                            } else {
                              showSnackBar(context, 'Something went wrong!!');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF55ab55),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        child: provider.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFF55ab55),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
