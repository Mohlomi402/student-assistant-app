import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_assistant_app/viewmodels/auth_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    final authVm = Provider.of<AuthViewModel>(context, listen: false);

    bool success = await authVm.register(
  firstName: _firstNameController.text.trim(),
  lastName: _lastNameController.text.trim(),
  email: _emailController.text.trim(),
  password: _passwordController.text,
  confirmPassword: _confirmPasswordController.text,
);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: Colors.green,
          duration: Durations.extralong4,
          
        ),
      );

      Navigator.pop(context);
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVm.errorMessage ?? 'Registration failed'),
          backgroundColor: Colors.grey[800],
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),

                ),

                child: const Icon(
                  Icons.school,
                  size: 40,
                  color: Colors.white,

                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,

                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Sign up to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),

              Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                   controller: _firstNameController,
                   decoration: InputDecoration(
                   hintText: 'First Name',
                   prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
                   border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black),
               ),
               ),
                validator: (value) {
                if (value == null || value.isEmpty) {
                 return 'First name is required';
                }
                 return null;
                  },
                  ),
                    const SizedBox(height: 16),

                     TextFormField(
                       controller: _lastNameController,
                        decoration: InputDecoration(
                         hintText: 'Last Name',
                        prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                       ),
                      ),
                      validator: (value) {
                         if (value == null || value.isEmpty) {
                          return 'Last name is required';
                      }
                      return null;
                       },
                      ),
                     const SizedBox(height: 16,),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),

                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    
                     TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                        labelText: 'Password',
                       prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                       suffixIcon: IconButton(
                      icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                       color: Colors.grey[600],
                      ),
                      onPressed: () {
                      setState(() {
                      _obscurePassword = !_obscurePassword;
                     });
                    },
                  ),
                 border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black),
                ),
                ),
               validator: (value) {
               if (value == null || value.isEmpty) {
               return 'Password is required';
                }
               if (value.length < 6) {
              return 'Password must be at least 6 characters';
              }
              return null;
              },
               ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                          ),

                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      
                      validator: (value) 
                      {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                          
                        }
                         if (value != _passwordController.text) {
                                  'Passwords do not match';
                         }
                         return null;
                      }
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Consumer<AuthViewModel>(
                builder: (context, vm, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: vm.isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: vm.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Sign Up', style: TextStyle(fontSize: 16)),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}