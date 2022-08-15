import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/my_storage_cubit.dart';
import '../widegets/dropdown_menu.dart';
import '../widegets/floating_action_button.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatingBtn(),
      appBar: AppBar(
        title: const Text('My Storage'),
      ),
      body: const Files(),
    );
  }
}

class Files extends StatelessWidget {
  const Files({super.key});
  @override
  Widget build(BuildContext context) {
    final myStorageCubit = BlocProvider.of<MyStorageCubit>(context);//context.read<MyStorageCubit>();
    return BlocBuilder<MyStorageCubit, MyStorageState>(
      builder: (context, state) {
        if (state is StorageLoadingState) {
          myStorageCubit.getFiles();
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StorageLoadedState) {
          return StreamBuilder<Object>(
              stream: BlocProvider.of<MyStorageCubit>(context).stream,
              builder: (context, snapshot) {
                return GridView.builder(
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 5 / 6,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: state.myStorage.files.length,
                  itemBuilder: (context, i) {
                    return Column(
                        children: [
                          DropdownMenu(fileId: state.myStorage.files[i].$id),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              state.myStorage.files[i].name,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      );
                  },
                );
              });
        }
        if (state is StorageErrorState) {
          return Center(child: Text(state.errorMsg));
        } else {
          return Container();
        }
      },
    );
  }
}


