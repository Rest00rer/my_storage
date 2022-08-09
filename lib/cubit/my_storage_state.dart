part of 'my_storage_cubit.dart';

@immutable
abstract class MyStorageState {}

class StorageLoadingState extends MyStorageState {}

class StorageLoadedState extends MyStorageState {
  final MyStorage myStorage;
  StorageLoadedState({required this.myStorage});
}

class StorageErrorState extends MyStorageState {
  final String errorMsg;
  StorageErrorState({
    required this.errorMsg,
  });
}
