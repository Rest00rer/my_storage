import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/video_player_cubit.dart';
import 'package:video_player/video_player.dart';

import '../../cubit/video_player_state.dart';

class Video extends StatefulWidget {
  final File videoFile;

  const Video.context(
    this.videoFile, {
    Key? key,
  }) : super(key: key);

  static Widget blocProvider(final File videoFile) {
    return BlocProvider(
      create: (context) {
        return VideoPlayerCubit(videoFile);
      },
      child: Video.context(
        videoFile,
      ),
    );
  }

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    final videoPlayerCubit = BlocProvider.of<VideoPlayerCubit>(context);
    return BlocBuilder<VideoPlayerCubit, InitializationVideoPlayerState>(
      builder: (_, state) {
        return WillPopScope(
          onWillPop: () async {
            return videoPlayerCubit.dispose();
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: AspectRatio(
              key: ValueKey(state.loaded),
              aspectRatio: state.mainController.value.aspectRatio,
              child: state.notLoaded ? const Center(child: CircularProgressIndicator()) : VideoPlayer(state.mainController),
            ),
          ),
        );
      },
    );
  }
}
