import 'dart:io';
import 'package:filesaverz/filesaverz.dart';
import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const endPoint = "http://localhost:80/v1";
const emulatorEndPoint = "http://10.0.2.2:80/v1";

const projectId = "62ebcf6f623fa8fe113d";
const bucketId = "62ebcf8aac5827f2325e";

class MyStorageProvider {
  late final Client client;
  late final Account account;
  late final Storage storage;
  late final Realtime realtime;
  late final dynamic subscription;

  Stream get subscriptionStream => subscription.stream;

  Future<Directory> getDocDirectory() async => await getApplicationDocumentsDirectory();

  void initialize() {
    client = Client()
      ..setEndpoint(emulatorEndPoint) //! emulator or web
      ..setProject(projectId);
    storage = Storage(client);
    realtime = Realtime(client);
    login();
    subscription = realtime.subscribe(['files']);
    getListOfFiles();
  }

  login() async {
    try {
      await Account(client).getSessions();
    } on AppwriteException catch (_) {
      await Account(client).createAnonymousSession();
    }
  }

  getListOfFiles() async {
    try {
      return await storage.listFiles(bucketId: bucketId);
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  createFile() async {
    late final InputFile file;
    try {
      await FilePicker.platform.pickFiles().then((result) {
        if (result == null) return;
        file = InputFile(path: result.files.single.path, filename: result.files.single.name);
      });
      await storage.createFile(bucketId: bucketId, fileId: 'unique()', file: file);
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  deleteFile(String fileId) async {
    try {
      storage.deleteFile(bucketId: bucketId, fileId: fileId);
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  getFilePreview({required String fileId}) async {
    try {
      return storage.getFilePreview(bucketId: bucketId, fileId: fileId, height: 250, width: 250);
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  getFileForView({required String fileId}) async {
    try {
      return storage.getFileView(bucketId: bucketId, fileId: fileId);
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<File> getVideoFile({required String fileId}) async {
    late File videoFile;

    await getDocDirectory().then((directory) {
      videoFile = File('${directory.path}/$fileId.mp4');
    }).then((value) {
      try {
        storage.getFileView(bucketId: bucketId, fileId: fileId).then((uint8ListBytes) {
          videoFile.writeAsBytesSync(uint8ListBytes);
        });
      } on AppwriteException catch (e) {
        throw Exception(e.message);
      }
    });
    return videoFile;
  }

  downloadFile({required String fileId, required BuildContext context}) async {
    final FileSaver fileSaver = FileSaver(initialFileName: 'Untitled File', fileTypes: const ['txt', 'pdf', 'mp4', 'jpeg', 'png', 'wav', 'mp3']);
    try {
      storage.getFileDownload(bucketId: bucketId, fileId: fileId).then((uint8ListBytes) {
        fileSaver.writeAsBytesSync(uint8ListBytes, context: context);
      });
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  renameFile({required String fileId, required String newName}) async {
    late final InputFile file;
    await storage.getFileDownload(bucketId: bucketId, fileId: fileId).then((uint8ListBytes) {
      file = InputFile(bytes: uint8ListBytes, filename: newName);
    });
    await storage.createFile(bucketId: bucketId, fileId: 'unique()', file: file);
    await deleteFile(fileId);
  }
}
