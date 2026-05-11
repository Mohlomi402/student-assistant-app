import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dxdtyghmmvvwvccaxvyh.supabase.co',

    anonKey:
    'sb_publishable_HFlpe8M5liEZoEFz3DWobw_ZVynth3Y',
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
          create: (context) => AuthViewModel(),
        ),

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