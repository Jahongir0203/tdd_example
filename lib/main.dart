import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tdd_example/core/di/di.dart';
import 'package:tdd_example/core/router/routes.dart';
import 'package:tdd_example/core/theme/theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TDD example',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router.config(),
    );
  }
}
