

import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
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
  late final subscription;

  Stream get subscriptionStream => subscription.stream;

  void initialize() {
    client = Client()
      ..setEndpoint(emulatorEndPoint) //! emulator or web
      ..setProject(projectId);
    storage = Storage(client);
    realtime = Realtime(client);
    login();
    subscription = realtime.subscribe(['files']);
    getFiles();
  }

  login() async {
    try {
      await Account(client).getSessions();
    } on AppwriteException catch (_) {
      await Account(client).createAnonymousSession();
    }
  }

  getFiles() async {
    try {
      return await storage.listFiles(bucketId: bucketId);
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  createFile() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final file = InputFile(path: image.path, filename: image.name);
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

  getFileView({required String fileId}) async {
    try {
      return storage.getFileView(bucketId: bucketId, fileId: fileId);
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<File> getVideoFile({required String fileId}) async {
    File videoFile = File('');

    await getDocDirectory().then((directory) {
      videoFile = File('${directory.path}/video.mp4');
    }).then((value) {
      try {
        storage.getFileView(bucketId: bucketId, fileId: fileId).then((uint8ListBytes) {
          videoFile.writeAsBytes(uint8ListBytes).then((_) => _);
        });
      } on AppwriteException catch (e) {
        throw Exception(e.message);
      }
    });
    return videoFile;
  }

  Future<Directory> getDocDirectory() async => await getApplicationDocumentsDirectory();
}
