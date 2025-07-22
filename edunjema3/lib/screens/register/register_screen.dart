import 'package:flutter/material.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/utils/validators.dart';
import 'package:edunjema3/widgets/custom_button.dart';
import 'package:edunjema3/services/auth_service.dart';

/// A screen for user registration.
class RegisterScreen extends StatefulWidget {
  /// Callback function to navigate back to the login screen.
  final VoidCallback onLoginTap;

  /// Creates a [RegisterScreen].
  const RegisterScreen({super.key, required this.onLoginTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthService().registerWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _nameController.text, // Pass the name for profile creation
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please log in.')),
        );
        widget.onLoginTap(); // Navigate back to login after successful registration
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Account',
                  style: AppConstants.headline4.copyWith(color: AppConstants.primaryColor),
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                Text(
                  'Join us to simplify your lesson planning.',
                  style: AppConstants.bodyText1.copyWith(color: AppConstants.mutedTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.largePadding * 1.5),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person, color: AppConstants.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                    ),
                    filled: true,
                    fillColor: AppConstants.cardColor,
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) => Validators.validateText(value, 'Full Name'),
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email, color: AppConstants.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                    ),
                    filled: true,
                    fillColor: AppConstants.cardColor,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Create a password',
                    prefixIcon: const Icon(Icons.lock, color: AppConstants.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                    ),
                    filled: true,
                    fillColor: AppConstants.cardColor,
                  ),
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_reset, color: AppConstants.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                    ),
                    filled: true,
                    fillColor: AppConstants.cardColor,
                  ),
                  obscureText: true,
                  validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                ),
                const SizedBox(height: AppConstants.largePadding),
                CustomButton(
                  text: 'Register',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: AppConstants.bodyText2,
                    ),
                    TextButton(
                      onPressed: widget.onLoginTap,
                      child: Text(
                        'Login',
                        style: AppConstants.bodyText2.copyWith(color: AppConstants.accentColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
