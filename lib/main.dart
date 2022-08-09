import 'package:flutter/material.dart';

import 'presentation/screens/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: _router.onGenerateRoute,
    );
  }

  

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
