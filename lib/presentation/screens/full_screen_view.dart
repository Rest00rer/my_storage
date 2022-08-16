import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart' as mime_service;
import '../../cubit/my_storage_cubit.dart';
import '../widegets/video.dart';

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
  }
}
