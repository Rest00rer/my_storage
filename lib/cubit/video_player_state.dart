import 'dart:io';

import 'package:video_player/video_player.dart';

class VideoPlayerState {
  VideoPlayerState._({required this.mainController, required this.loaded});
  final VideoPlayerController mainController;
  final bool loaded;

  factory VideoPlayerState.initialize({required File videoFile}) {
    final controller = VideoPlayerController.file(videoFile);
    return VideoPlayerState._(mainController: controller, loaded: false);
  }

    factory VideoPlayerState.webInitialize({required String dataSource}) {
    final controller = VideoPlayerController.network(dataSource);
    return VideoPlayerState._(mainController: controller, loaded: false);
  }

  bool get notLoaded => !loaded;

  VideoPlayerState copyWith({VideoPlayerController? controller, bool? loaded}) {
    return VideoPlayerState._(
      mainController: controller ?? mainController,
      loaded: loaded ?? this.loaded,
    );
  }

  Future<void> dispose() async {
    await mainController.dispose().then((_) => true);
  }
}
