import 'dart:io';

import 'package:video_player/video_player.dart';

abstract class VideoPlayerState {}

class InitializationVideoPlayerState {
  InitializationVideoPlayerState({
    required this.mainController,
    required this.loaded,
  });

  final VideoPlayerController mainController;
  final bool loaded;

  factory InitializationVideoPlayerState.initialize({required File videoFile}) {
    final newController = VideoPlayerController.file(videoFile);
    return InitializationVideoPlayerState(
      mainController: newController,
      loaded: false,
    );
  }

  bool get notLoaded => !loaded;

  InitializationVideoPlayerState copyWith({
    VideoPlayerController? controller,
    bool? loaded,
  }) {
    return InitializationVideoPlayerState(
      mainController: controller ?? mainController,
      loaded: loaded ?? this.loaded,
    );
  }
}

class InitializeAndPlayState extends VideoPlayerState {
  final VideoPlayerController controller;
  InitializeAndPlayState(this.controller);
}
