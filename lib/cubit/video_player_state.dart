import 'dart:io';

import 'package:video_player/video_player.dart';

class InitializationVideoPlayerState {
  
  late VideoPlayerController mainController;
  bool loaded = false;
  File videoFile;
  InitializationVideoPlayerState({
    required this.videoFile,
  }){
    mainController = VideoPlayerController.file(videoFile);
  }

  bool get notLoaded => !loaded;
}