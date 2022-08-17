import 'dart:io';
import 'package:appwrite/models.dart' as appwritefile;
import 'package:filesaverz/filesaverz.dart';
import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
// import 'dart:js' as js;

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
      ..setEndpoint(kIsWeb ? endPoint : emulatorEndPoint) //! emulator or web
      ..setProject(projectId);
    storage = Storage(client);
    realtime = Realtime(client);
    account = Account(client);
    login();
    subscription = realtime.subscribe(['files']);
    getListOfFiles();
  }

  login() async {
    try {
      await account.getSessions();
    } on AppwriteException catch (_) {
      await account.createAnonymousSession();
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
    if (!kIsWeb) {
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
    } else {
      late final InputFile file;
      await FilePicker.platform.pickFiles().then((result) async {
        file = InputFile(bytes: result!.files.first.bytes, filename: result.files.first.name);
        await storage.createFile(bucketId: bucketId, fileId: 'unique()', file: file);
        return null;
      });
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
    if (!kIsWeb) {
      final FileSaver fileSaver = FileSaver(initialFileName: 'Untitled File', fileTypes: const ['txt', 'pdf', 'mp4', 'jpeg', 'png', 'wav', 'mp3']);
      try {
        storage.getFileDownload(bucketId: bucketId, fileId: fileId).then((uint8ListBytes) {
          fileSaver.writeAsBytesSync(uint8ListBytes, context: context);
        });
      } on AppwriteException catch (e) {
        throw Exception(e.message);
      }
    } else {
      try {
        storage.getFile(bucketId: bucketId, fileId: fileId).then((fileResponse) {
          final appwritefile.File file = fileResponse;
          storage.getFile(bucketId: bucketId, fileId: fileId).then((file) {
            html.AnchorElement anchorElement = html.AnchorElement(href: file.toString());
            anchorElement.download = file.name;
            anchorElement.click();
          });
        });
      } on AppwriteException catch (e) {
        throw Exception(e.message);
      }
    }
  }

  renameFile({required String fileId, required String newName}) async {
    if (!kIsWeb) {
      late final InputFile file;
      await storage.getFileDownload(bucketId: bucketId, fileId: fileId).then((uint8ListBytes) {
        file = InputFile(bytes: uint8ListBytes, filename: newName);
      });
      await storage.createFile(bucketId: bucketId, fileId: 'unique()', file: file);
      await deleteFile(fileId);
    } else {
      await storage.getFileView(bucketId: bucketId, fileId: fileId).then((bytes) {
        InputFile file = InputFile(bytes: bytes, filename: newName);
        storage.createFile(bucketId: bucketId, fileId: 'unique()', file: file);
        deleteFile(fileId);
      });
      return null;
    }
  }

  Future<String> getJvt() async {
    late final String jwt;
    await account.createJWT().then((response) {
      jwt = response.jwt;
    });
    return jwt;
  }

  // Future<String> getVideoDataSource({required String fileId}) {
  //   late String dataSource = '';
  //   return dataSource;
  //   client.webAuth(url)
  // }
}
