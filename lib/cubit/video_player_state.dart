import 'dart:io';

import 'package:video_player/video_player.dart';

abstract class VideoPlayerState {}

class InitializationVideoPlayerState{
  InitializationVideoPlayerState({
    required this.controller,
    required this.loaded,
  });

  factory InitializationVideoPlayerState.initialize({
    required File videoFile,
  }) {
    final controller = VideoPlayerController.file(
      videoFile,
    );
    return InitializationVideoPlayerState(
      controller: controller,
      loaded: false,
    );
  }

  final VideoPlayerController controller;
  final bool loaded;

  bool get notLoaded => !loaded;

  InitializationVideoPlayerState copyWith({
    VideoPlayerController? controller,
    bool? loaded,
  }) {
    return InitializationVideoPlayerState(
      controller: controller ?? this.controller,
      loaded: loaded ?? this.loaded,
    );
  }
}