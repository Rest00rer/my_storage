// ignore_for_file: prefer_typing_uninitialized_variables


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:my_storage/cubit/my_storage_cubit.dart';
import 'package:video_player/video_player.dart';

class FullScreenPage extends StatelessWidget {
  final String fileId;
  const FullScreenPage({Key? key, required this.fileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myStorageCubit = BlocProvider.of<MyStorageCubit>(context);
    late final mime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen View'),
      ),
      body: BlocBuilder<MyStorageCubit, MyStorageState>(builder: (context, state) {
        if (state is StorageLoadedState) {
          return FutureBuilder(
            future: myStorageCubit.getFileView(fileId),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                mime = lookupMimeType('', headerBytes: snapshot.data);
                // print('');
              } else {
                return const Center(child: Text('Неизвестный формат файла'));
              }
              if (mime == 'image/png' || mime == 'image/jpeg' || mime == 'image/gif' || mime == 'image/tiff') {
                return Image.memory(snapshot.data);
              }
              if (mime == 'video/mp4') {
                return VideoPlayerWidget(fileId: fileId);
              } else {
                return const Center(child: Text('Ошибка, повторите запрос позже'));
              }
            },
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final fileId;
  const VideoPlayerWidget({Key? key, required this.fileId}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    final myStorageCubit = BlocProvider.of<MyStorageCubit>(context);
    final Uint8List bytes = myStorageCubit.getFileView(widget.fileId) as Uint8List;
    final videoFile = File('');
    videoFile.writeAsBytes(bytes);
    _controller = VideoPlayerController.file(videoFile);
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });
      },
      child: Center(
        child: _controller.value.isInitialized
            ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
