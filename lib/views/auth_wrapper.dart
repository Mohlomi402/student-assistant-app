import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_view.dart';
import 'package:provider/provider.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    if (authVm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authVm.isLoggedIn) {
      return const LoginView();
    }

    
    return const DetailScreen(); //must be changed!!
  }
}
