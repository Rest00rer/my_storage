import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_storage/cubit/video_player_cubit.dart';
import 'package:video_player/video_player.dart';

import '../../cubit/video_player_state.dart';

class Video extends StatelessWidget {
  
  const Video.context(
    this.uri, {
    Key? key,
    required this.aspectRatio,
  }) : super(key: key);

  static Widget blocProvider(
    String uri, {
    required double aspectRatio,
  }) {
    return BlocProvider(
      create: (context) {
        return VideoPlayerCubit(uri);
      },
      child: Video.context(
        uri,
        aspectRatio: aspectRatio,
      ),
    );
  }

  final String uri;
  final double aspectRatio;

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
      builder: (_, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: AspectRatio(
            key: ValueKey(state.loaded),
            aspectRatio: aspectRatio,
            child: state.notLoaded
                ? const Center(child: CircularProgressIndicator())
                : VideoPlayer(state.controller),
          ),
        );
      },
    );
  }
}