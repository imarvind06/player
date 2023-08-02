import 'dart:convert';

import 'package:player/models/video_model.dart';
import 'package:player/services/video_player_service.dart';

import '../exceptions/custom_exception.dart';

class VideoPlayerRepo {
  final VideoPlayerService videoPlayerService;

  VideoPlayerRepo({required this.videoPlayerService});

  Future<List<VideoModel>> getVideo({required int pageNo}) async {
    var data = await videoPlayerService.getVideo(pageNo: pageNo);

    if (data["statusCode"] == 200) {
      Map<String, dynamic> output;
      if (data['result'] != null) {
        output = json.decode(data['result']);
      } else {
        output = {};
      }
      try {
        return (output["data"]["posts"] as List)
            .map((e) => VideoModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } catch (e) {
        throw CustomException(
            type: data["statusCode"],
            message: "Some unexpected error occurred");
      }
    } else {
      throw CustomException(
        type: data["statusCode"],
        message: data["result"],
      );
    }
  }
}
