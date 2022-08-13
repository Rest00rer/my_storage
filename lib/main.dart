import 'package:flutter/material.dart';

import 'app_router.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
