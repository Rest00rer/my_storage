// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_storage/cubit/video_player_state.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit(File videoFile, {bool autoPlay = true})
      : super(VideoPlayerState.initialize(
          videoFile: videoFile,
        )) {
    state.controller.addListener(() {});
    state.controller.setLooping(true);
    state.controller.initialize().then((_) {
      emit(state.copyWith(
        loaded: true,
      ));
      if (autoPlay) {
        state.controller.play();
      }
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }
}
