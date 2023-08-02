import 'package:player/apis/apicall.dart';
import 'package:player/endpoints/video_player_endpoints.dart';

class VideoPlayerService {
  final ApiCall apiCall;

  VideoPlayerService({required this.apiCall});

  Future<Map<String, dynamic>> getVideo({required int pageNo}) async {
    return await apiCall.getCall(VideoPlayerEndPoints.getVideo(pageNo: pageNo));
  }
}
