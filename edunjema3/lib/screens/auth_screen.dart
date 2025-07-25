import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
//import '../config/app_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginMode = true;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isToggling = false;

  final AuthService _authService = AuthService();

  void _toggleAuthMode() {
    if (_isToggling) {
      print('[AuthScreen] _toggleAuthMode called while already toggling. Ignoring.');
      return;
    }

    setState(() {
      _isToggling = true;
      _isLoginMode = !_isLoginMode;
      _emailController.clear();
      _passwordController.clear();
      _errorMessage = null;
    });
    print('[AuthScreen] Switched to ${_isLoginMode ? 'Login' : 'Register'} mode.');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isToggling = false;
        });
      }
    });
  }

  Future<void> _submitAuthForm() async {
    print('[_submitAuthForm] Button pressed. Mode: ${_isLoginMode ? 'Login' : 'Register'}');
    if (!_formKey.currentState!.validate()) {
      print('[_submitAuthForm] Form validation failed.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLoginMode) {
        print('[_submitAuthForm] Attempting to sign in with ${_emailController.text.trim()}...');
        await _authService.signInWithEmailAndPassword(_emailController.text.trim(), _passwordController.text.trim());
      } else {
        print('[_submitAuthForm] Attempting to register with ${_emailController.text.trim()}...');
        await _authService.createUserWithEmailAndPassword(_emailController.text.trim(), _passwordController.text.trim());
      }
    } catch (e) {
      print('[AuthScreen] Auth operation failed: $e');
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login to edunjema3' : 'Register for edunjema3'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLoginMode ? 'Welcome Back!' : 'Create Your Account',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'your.email@example.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Minimum 6 characters',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long.';
                        }
                        return null;
                        }, // This was likely the missing parenthesis
                    ),
                    const SizedBox(height: 24),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitAuthForm,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_isLoginMode ? 'Login' : 'Register'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: (_isLoading || _isToggling) ? null : _toggleAuthMode,
                      child: Text(
                        _isLoginMode ? 'Don\'t have an account? Register' : 'Already have an account? Login',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
