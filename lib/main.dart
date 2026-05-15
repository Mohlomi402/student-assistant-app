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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/splash_screen.dart';
import 'package:student_assistant_app/viewmodels/application_view_model.dart';
import 'package:student_assistant_app/viewmodels/admin_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dxdtyghmmvvwvccaxvyh.supabase.co',
    anonKey: 'sb_publishable_HFlpe8M5liEZoEFz3DWobw_ZVynth3Y',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AUTH VIEWMODEL
        ChangeNotifierProvider(
          create: (context)=> AuthViewModel()),
          ChangeNotifierProvider(create: (context)=> ApplicationViewModel(), //added to test must be removed
        ),
        ChangeNotifierProvider(create: (context)=> AdminViewModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
