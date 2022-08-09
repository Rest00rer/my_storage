import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/my_storage_cubit.dart';

class FloatingBtn extends StatelessWidget {
  const FloatingBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final MyStorageCubit myStorageCubit = context.read<MyStorageCubit>();
    return FloatingActionButton(
      child: const Icon(Icons.add_circle_outline),
      onPressed: () => myStorageCubit.createFile(),
    );
  }
}
