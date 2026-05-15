//Members
// 220044173 Mohlomi_T
// 221013252 Kwetle_ME
// 221019628 Makhetha_L
// 223008010 Brits_T
// 221008431 Choane SRT
// 221003714 Leeuw SA
// 221027626 Mokhele M
// 223043312 Choeu TM
// 223038645 Ndlovu N

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_assistant_app/viewmodels/auth_viewmodel.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _obscureText = true;

  // =========================
  // LOGIN FUNCTION (FIXED SAFE)
  // =========================
  Future<void> _handleLogin() async {

    if (!_formKey.currentState!.validate()) return;

    final authVm =
        Provider.of<AuthViewModel>(
          context,
          listen: false,
        );

    final success = await authVm.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authVm.errorMessage ??
                "Login failed. Check credentials.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // ❗ NO NAVIGATION HERE (IMPORTANT)
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
      backgroundColor: Colors.white,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),

          child: Form(
            key: _formKey,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                const Icon(
                  Icons.school,
                  size: 80,
                  color: Colors.black,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Student Assistant",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // ================= EMAIL =================
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.contains("@")) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ================= PASSWORD =================
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,

                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password too short";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // ================= LOGIN BUTTON =================
                Consumer<AuthViewModel>(
                  builder: (context, vm, child) {

                    return SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: vm.isLoading
                            ? null
                            : _handleLogin,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),

                        child: vm.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Login"),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // ================= REGISTER =================
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterView(),
                      ),
                    );
                  },
                  child: const Text("Create account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}