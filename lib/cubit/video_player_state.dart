import 'dart:io';

import 'package:video_player/video_player.dart';

class VideoPlayerState {
  VideoPlayerState._({
    required this.controller,
    required this.loaded,
  });

  factory VideoPlayerState.initialize({
    required File videoFile,
  }) {
    final controller = VideoPlayerController.file(
      videoFile,
    );
    return VideoPlayerState._(
      controller: controller,
      loaded: false,
    );
  }

  final VideoPlayerController controller;
  final bool loaded;

  bool get notLoaded => !loaded;

  VideoPlayerState copyWith({
    VideoPlayerController? controller,
    bool? loaded,
  }) {
    return VideoPlayerState._(
      controller: controller ?? this.controller,
      loaded: loaded ?? this.loaded,
    );
  }

  Future<void> dispose() async {
    controller.dispose();
  }
}