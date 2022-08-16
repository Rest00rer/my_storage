
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
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
      getListOfFiles();
    });
  }

  Future<void> getListOfFiles() async {
    try {
      emit(StorageLoadingState());
      final response = await _myStorageProvider.getListOfFiles();
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
      emit(StorageErrorState(errorMsg: errorMsg.toString()));
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

  Future<dynamic> getFileForView(String fileId) {
    return _myStorageProvider.getFileForView(fileId: fileId);
  }

  Future<Directory> getDocDirectory() async {
    Directory resultDir = await _myStorageProvider.getDocDirectory();
    return resultDir;
  }

  Future<File>getVideoFile({required String fileId}) async {
    return _myStorageProvider.getVideoFile(fileId: fileId);
  }

  Future<void>downloadFile({required String fileId, required BuildContext context})async {
    _myStorageProvider.downloadFile(fileId: fileId, context: context);
  }

}
