import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../cubit/video_player_cubit.dart';
import '../../cubit/video_player_state.dart';

class Video extends StatelessWidget {
  final File videoFile;

  const Video._({required this.videoFile, Key? key}) : super(key: key);

  static Widget blocProvider({required File videoFile}) {
    return BlocProvider(
      create: (_) {
        return VideoPlayerCubit(videoFile: videoFile);
      },
      child: Video._(
        videoFile: videoFile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayerCubit = BlocProvider.of<VideoPlayerCubit>(context);

    return BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
      builder: (_, state) {
        return WillPopScope(
          onWillPop: () {
            return videoPlayerCubit.state.dispose().then((value) => true);
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
