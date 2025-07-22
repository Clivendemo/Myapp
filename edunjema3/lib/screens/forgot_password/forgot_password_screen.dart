import 'package:flutter/material.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/utils/validators.dart';
import 'package:edunjema3/widgets/custom_button.dart';
import 'package:edunjema3/services/auth_service.dart';

/// A screen for users to reset their password.
class ForgotPasswordScreen extends StatefulWidget {
  /// Callback function to navigate back to the login screen.
  final VoidCallback onLoginTap;

  /// Creates a [ForgotPasswordScreen].
  const ForgotPasswordScreen({super.key, required this.onLoginTap});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthService().sendPasswordResetEmail(
          _emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset link sent to your email!')),
        );
        widget.onLoginTap(); // Navigate back to login after request
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.primaryColor),
          onPressed: widget.onLoginTap,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Password?',
                  style: AppConstants.headline4.copyWith(color: AppConstants.primaryColor),
                ),
                const SizedBox(height: AppConstants.mediumPadding),
                Text(
                  'Enter your email address to receive a password reset link.',
                  style: AppConstants.bodyText1.copyWith(color: AppConstants.mutedTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.largePadding * 1.5),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your registered email',
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
                const SizedBox(height: AppConstants.largePadding),
                CustomButton(
                  text: 'Reset Password',
                  onPressed: _handleResetPassword,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
