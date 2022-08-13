// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:my_storage/cubit/my_storage_cubit.dart';
import 'package:my_storage/presentation/widegets/video.dart';

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
              } else {
                return const Center(child: CircularProgressIndicator());
              }
              if (mime == 'image/png' || mime == 'image/jpeg' || mime == 'image/gif' || mime == 'image/tiff') {
                return Image.memory(snapshot.data);
              }
              if (/*mime == 'video/mp4'*/ true) {
                return VideoPlayerWidget(fileId: fileId);
              }
              // else {
              //   return const Center(child: Text('Ошибка, повторите запрос позже'));
              // }
            },
          );
        } else {
          return const Center(
            child: Text('text'),
          );
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
  // late VideoPlayerController _controller;
  // final myStorageProvider = MyStorageProvider()..initialize();

  // @override
  // void initState() {
  //   super.initState();

  //   // myStorageProvider.getVideoFile(fileId: widget.fileId).then((value) {
  //     _controller = VideoPlayerController.network('https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4')
  //       ..initialize().then((_) {
  //         setState(() {});
  //       });
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    // final myStorageCubit = BlocProvider.of<MyStorageCubit>(context);

    //  return FutureBuilder(
    // future: myStorageCubit.getVideoFile(fileId: widget.fileId),
    // builder: (context, snapshot) {
    //if (snapshot.hasData && snapshot.data != null) {
    // controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });

    return Video.blocProvider(
      'assets/video.mp4',
      aspectRatio: 2.0,
    );
    // Center(
    //   child: _controller.value.isInitialized
    //       ? Column(
    //           children: [
    //             AspectRatio(
    //               aspectRatio: _controller.value.aspectRatio,
    //               child: VideoPlayer(_controller),
    //             ),
    //           ],
    //         )
    //       : Container(),
    // );
    //    }// else {
    // return const Center(child: CircularProgressIndicator());
    // }
    //   },
    /*);*/
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }
}
