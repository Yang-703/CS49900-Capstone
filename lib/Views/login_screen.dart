// login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Service/auth_service.dart';
import 'package:flutter_study_app/Views/nav_bar_category.dart';
import 'package:flutter_study_app/Views/signup_screen.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';
import 'package:flutter_study_app/Widgets/snackbar.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordHidden = true;
  final AuthService _authService = AuthService();

  Future<void> _logIn() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final result = await _authService.logInUser(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    setState(() {
      isLoading = false;
    });
    if (result == "Login successful") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const NavBarCategorySelection(),
        ),
      );
    } else {
      showSnackBar(context, "Login failed! $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gradient background for a modern look.
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Header section with illustration and welcoming text.
                  Column(
                    children: [
                      // Ensure the asset exists in the project.
                      Image.asset(
                        "assets/undraw_login.png",
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Sign in to continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Email input field with rounded corners and icon.
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$")
                          .hasMatch(value.trim())) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password input field with icon and toggle visibility.
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                        icon: Icon(isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    obscureText: isPasswordHidden,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  // Login button with improved styling.
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: MyButton(
                            onTap: _logIn,
                            buttonText: "Login",
                          ),
                        ),
                  const SizedBox(height: 20),
                  // Sign Up navigation text.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up Here",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}