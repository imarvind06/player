import 'package:flutter/material.dart';
import 'package:player/apis/apicall.dart';
import 'package:player/exceptions/custom_exception.dart';
import 'package:player/models/video_model.dart';
import 'package:player/pages/video_player/player.dart';
import 'package:player/repository/video_player_repo.dart';
import 'package:player/services/video_player_service.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerRepo videoPlayerRepo;
  late VideoPlayerService videoPlayerService;
  int pageNo = 0;
  List<VideoModel>? videos;
  String? error;
  bool isDataPresent = true;
  bool loadingMoreData = false;

  @override
  void initState() {
    videoPlayerService = VideoPlayerService(apiCall: ApiCall());
    videoPlayerRepo = VideoPlayerRepo(videoPlayerService: videoPlayerService);
    getVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videos == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PageView.builder(
              itemCount: videos!.length,
              controller: PageController(viewportFraction: 1),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (index == (videos!.length - 2)) {
                  pageNo = pageNo + 1;
                  getVideos();
                }
                return Player(
                  videoUrl: videos![index].videoUrl,
                );
              },
            ),
    );
  }

  Future<void> getVideos() async {
    if (!isDataPresent) {
      pageNo = 0;
      isDataPresent = true;
    }
    // if (videos != null && isDataPresent) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     setState(() {
    //       loadingMoreData = true;
    //     });
    //   });
    // }
    try {
      final data = await videoPlayerRepo.getVideo(pageNo: pageNo);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (data.length < 10) {
            isDataPresent = false;
          } else {
            isDataPresent = true;
          }
          if (videos == null) {
            videos = data;
          } else {
            videos!.addAll(data);
          }
          error = null;
          loadingMoreData = false;
        });
      });
    } catch (e) {
      final errorLocal = e as CustomException;
      setState(() {
        error = errorLocal.message;
      });
    }
  }
}
