import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart' as mime_service;
import 'package:video_player/video_player.dart';
import '../../cubit/my_storage_cubit.dart';
import '../widegets/video.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FullScreenPage extends StatelessWidget {
  final String fileId;
  const FullScreenPage({Key? key, required this.fileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myStorageCubit = BlocProvider.of<MyStorageCubit>(context);
    late final String mime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen View'),
      ),
      body: FutureBuilder(
        future: myStorageCubit.getFileForView(fileId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final List<int> data = snapshot.data;
            mime = mime_service.lookupMimeType('', headerBytes: data) ?? 'video/mp4v';
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          if (mime == 'image/png' || mime == 'image/jpeg' || mime == 'image/gif' || mime == 'image/tiff') {
            return Image.memory(snapshot.data);
          }
          if (mime == 'video/mp4v') {
            return VideoPlayerWidget(fileId: fileId);
          } else {
            return const Center(child: Text('Ошибка, повторите запрос позже'));
          }
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String fileId;
  const VideoPlayerWidget({Key? key, required this.fileId}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    final myStorageCubit = BlocProvider.of<MyStorageCubit>(context);
    if (!kIsWeb) {
      return FutureBuilder(
        future: myStorageCubit.getVideoFile(fileId: widget.fileId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Video.blocProvider(
              videoFile: snapshot.data!,
            );
          } else {
            return Container();
          }
        },
      );
    } else {
      return WebVideoPlayer(context: context, fileId: widget.fileId);
    }
  }
}

class WebVideoPlayer extends StatefulWidget {
  final String fileId;
  final BuildContext context;
  const WebVideoPlayer({super.key, required this.fileId, required this.context});

  @override
  State<WebVideoPlayer> createState() => _WebVideoPlayerState();
}

class _WebVideoPlayerState extends State<WebVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<VideoPlayerController> futureController;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    final myStorageCubit = BlocProvider.of<MyStorageCubit>(context);

    futureController = myStorageCubit.getJvt().then((jvt) {
      _controller = VideoPlayerController.network(
        "http://localhost:80/v1/storage/buckets/62ebcf8aac5827f2325e/files/${widget.fileId}/view?project=62ebcf6f623fa8fe113d",
        httpHeaders: {"X-Appwrite-JWT": jvt},
      );

      _controller.initialize().then((_) {
        _controller.play();
        setState(() {});
      });
      return _controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureController,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        });
  }
}
