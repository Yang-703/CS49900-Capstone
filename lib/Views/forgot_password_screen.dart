/* lib/Views/forgot_password_screen.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Service/auth_service.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';
import 'package:flutter_study_app/Widgets/snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    final result = await _authService.resetPassword(email: emailController.text);
    setState(() => isLoading = false);

    showSnackBar(context, result);
    if (result.contains("sent")) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        titleTextStyle: const TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      extendBodyBehindAppBar: true,
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
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.lock_open, size: 100, color: Colors.blueAccent),
                  const SizedBox(height: 20),
                  const Text(
                    "Forgot your password?\nEnter your email to receive a reset link.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 30),
                  isLoading
                      ? const CircularProgressIndicator()
                      : MyButton(
                          onTap: _resetPassword,
                          buttonText: "Send Reset Link",
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
