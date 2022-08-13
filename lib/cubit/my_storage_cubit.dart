// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_storage/models/my_storage.dart';
import 'package:my_storage/services/my_storage_provider.dart';

part 'my_storage_state.dart';

class MyStorageCubit extends Cubit<MyStorageState> {
  MyStorageCubit() : super(StorageLoadingState());
  final _myStorageProvider = MyStorageProvider();
  late Stream subscription;

  initialize() {
    _myStorageProvider.initialize();
    subscription = _myStorageProvider.subscriptionStream;
    subscription.listen((response) {
      getFiles();
    });
  }

  Future<void> getFiles() async {
    try {
      emit(StorageLoadingState());
      final response = await _myStorageProvider.getFiles();
      emit(StorageLoadedState(myStorage: MyStorage(files: response.files)));
    } catch (errorMsg) {
      emit(StorageErrorState(errorMsg: errorMsg.toString()));
    }
  }

  Future<void> createFile() async {
    try {
      final response = await _myStorageProvider.createFile();
      emit(StorageLoadedState(myStorage: MyStorage(files: response.files)));
    } catch (errorMsg) {
      print(errorMsg);
    }
  }

  Future<dynamic> getFilePreview(String fileId) {
    return _myStorageProvider.getFilePreview(fileId: fileId);
  }

  Future<void> deleteFile(String fileId) async {
    try {
      await _myStorageProvider.deleteFile(fileId);
    } catch (errorMsg) {
      emit(StorageErrorState(errorMsg: errorMsg.toString()));
    }
  }

  Future<dynamic> getFileView(String fileId) {
    return _myStorageProvider.getFileView(fileId: fileId);
  }

  Future<Directory> getDocDirectory() async {
    Directory resultDir = await _myStorageProvider.getDocDirectory();
    return resultDir;
  }

  Future<File>getVideoFile({required String fileId}) async {
    return _myStorageProvider.getVideoFile(fileId: fileId);
  }
}
