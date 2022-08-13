// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_storage/cubit/video_player_state.dart';

class VideoPlayerCubit extends Cubit<InitializationVideoPlayerState> {
  VideoPlayerCubit(File videoFile, {bool autoPlay = true})
      : super(InitializationVideoPlayerState.initialize(
          videoFile: videoFile,
        )) {
    state.mainController.addListener(() {});
    state.mainController.setLooping(false);
    state.mainController.initialize().then((_) {
      emit(state.copyWith(loaded: true, controller: state.mainController));
      if (autoPlay) {
        state.mainController.play();
      }
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }

  Future<bool> dispose() async {
    bool isDispose = true;
    state.mainController.pause();
    state.mainController.dispose();
    return isDispose;
  }
}
