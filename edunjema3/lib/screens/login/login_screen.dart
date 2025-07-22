import 'package:flutter/material.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/utils/validators.dart';
import 'package:edunjema3/widgets/custom_button.dart';
import 'package:edunjema3/services/auth_service.dart';

/// A screen for user login.
class LoginScreen extends StatefulWidget {
  /// Callback function to navigate to the registration screen.
  final VoidCallback onRegisterTap;
  /// Callback function to navigate to the forgot password screen.
  final VoidCallback onForgotPasswordTap;

  /// Creates a [LoginScreen].
  const LoginScreen({
    super.key,
    required this.onRegisterTap,
    required this.onForgotPasswordTap,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthService().signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        // If successful, AuthWrapper will automatically navigate to HomeScreen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
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
    _emailController.dispose();
    _passwordController.dispose();
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
                  'Welcome Back!',
                  style: AppConstants.headline4.copyWith(color: AppConstants.primaryColor),
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                Text(
                  'Sign in to continue to your lesson planning journey.',
                  style: AppConstants.bodyText1.copyWith(color: AppConstants.mutedTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.largePadding * 1.5),
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
                    hintText: 'Enter your password',
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
                const SizedBox(height: AppConstants.smallPadding),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: widget.onForgotPasswordTap,
                    child: Text(
                      'Forgot Password?',
                      style: AppConstants.bodyText2.copyWith(color: AppConstants.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.largePadding),
                CustomButton(
                  text: 'Login',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppConstants.bodyText2,
                    ),
                    TextButton(
                      onPressed: widget.onRegisterTap,
                      child: Text(
                        'Register',
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
