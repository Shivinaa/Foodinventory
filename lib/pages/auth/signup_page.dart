import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/bottom_navigation/bottom_navigation.dart';
import 'package:food_inventory_tracking_app/util/utils.dart';
import 'package:provider/provider.dart';

import 'package:food_inventory_tracking_app/pages/auth/provider/firebase_auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

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
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with green background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 30),
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
                      Icons.person_add,
                      size: 70,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Join Digi Pantry',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create an account to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Sign Up Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name field
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Your full name',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF55ab55)),
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

                    const SizedBox(height: 20),

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
                        hintText: 'Create a strong password',
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

                    const SizedBox(height: 30),

                    // Sign Up button
                    Consumer<FirebaseAuthProvider>(
                        builder: (context, provider, _) {
                      return SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () async {
                            final res =
                                await provider.signUpWithEmailandPassword(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              nameController.text.trim(),
                            );
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
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    }),

                    const SizedBox(height: 30),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFF55ab55),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
