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
import 'login_view.dart';
import 'home_screen.dart';
import 'admin_dashboard.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() =>
      _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async {

      if (!mounted) return;

      await context
          .read<AuthViewModel>()
          .checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {

    final authVm =
    context.watch<AuthViewModel>();

    // ==============================
    // LOADING STATE
    // ==============================
    if (!authVm.sessionChecked) {

      return const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }

    // ==============================
    // NOT LOGGED IN
    // ==============================
    if (!authVm.isLoggedIn) {

      return const LoginView();
    }

    // ==============================
    // ADMIN ROUTE
    // ==============================
    if ((authVm.role ?? '').toLowerCase() == 'admin') {

      return const AdminDashboard();
    }

    // ==============================
    // DEFAULT ROUTE (STUDENT)
    // ==============================
    return const HomeScreen();
  }
}