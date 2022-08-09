import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_storage/cubit/my_storage_cubit.dart';
import 'package:my_storage/presentation/screens/full_screen_view.dart';

import 'home_page.dart';

class AppRouter {
  final _myStorageCubit = MyStorageCubit();

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _myStorageCubit..initialize(),
            child: const MyHomePage(),
          ),
        );
      case '/fullScreen':
        final fileId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _myStorageCubit,
            child: FullScreenPage(fileId: fileId),
          ),
        );
      default:
        return null;
    }
  }

  void dispose() {
    _myStorageCubit.close();
  }
}
