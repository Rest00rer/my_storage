// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_storage/cubit/video_player_state.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit({required File videoFile}) : super(VideoPlayerState.initialize(videoFile: videoFile)) {
    if (Platform.isAndroid) {
      state.mainController.initialize().then((_) {
        emit(state.copyWith(loaded: true));
        state.mainController.play();
        print(state.mainController);
      }).onError((error, stackTrace) {
        print(error);
        print(stackTrace);
      });
    } else {

    }
  }
}
