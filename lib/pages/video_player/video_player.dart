import 'package:flutter/material.dart';
import 'package:player/apis/apicall.dart';
import 'package:player/exceptions/custom_exception.dart';
import 'package:player/models/video_model.dart';
import 'package:player/pages/video_player/player.dart';
import 'package:player/repository/video_player_repo.dart';
import 'package:player/services/video_player_service.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> with WidgetsBindingObserver {
  late VideoPlayerRepo videoPlayerRepo;
  late VideoPlayerService videoPlayerService;
  int pageNo = 0;
  List<VideoModel>? videos;
  String? error;
  bool isDataPresent = true;
  bool loadingMoreData = false;
  List<VideoPlayerController> controller = [];
  bool isBack = false;
  int currIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
              controller: PageController(viewportFraction: 1, initialPage: 0),
              scrollDirection: Axis.vertical,
              onPageChanged: (value) async {},
              itemBuilder: (context, index) {
                if (currIndex < index) {
                  isBack = false;
                  final ct = controller[0];
                  controller.removeAt(0);
                  addNextController(index, ct);
                } else if (currIndex > index) {
                  isBack = true;
                  final ct = controller[2];
                  controller.removeAt(2);
                  addPrevController(index, ct);
                }
                if (index == (videos!.length - 2)) {
                  pageNo = pageNo + 1;
                  getVideos();
                }
                return Player(
                  videoUrl: videos![index].videoUrl,
                  controller: isBack ? controller[0] : controller[1],
                );
              },
            ),
    );
  }

  addNextController(value, VideoPlayerController controllerLocal) async {
    await controllerLocal.dispose();
    final controller4 =
        VideoPlayerController.network(videos![value + 1].videoUrl);
    await controller4.initialize();
    controller.add(controller4);
    currIndex = value;
  }

  addPrevController(value, VideoPlayerController controllerLocal) async {
    await controllerLocal.dispose();
    final controller4 =
        VideoPlayerController.network(videos![value - 1].videoUrl);
    await controller4.initialize();
    controller.insert(0, controller4);
    currIndex = value;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (isBack) {
          controller[0].play();
        } else {
          controller[1].play();
        }
        break;
      case AppLifecycleState.inactive:
        controller[0].pause();
        controller[1].pause();
        if (controller.length >= 3) controller[2].pause();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
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
      if (videos == null) {
        final videoPlayerController1 =
            VideoPlayerController.network(data[0].videoUrl);
        await videoPlayerController1.initialize();
        controller.insert(0, videoPlayerController1);
        final videoPlayerController2 =
            VideoPlayerController.network(data[1].videoUrl);
        await videoPlayerController2.initialize();
        controller.insert(1, videoPlayerController2);
        final videoPlayerController3 =
            VideoPlayerController.network(data[2].videoUrl);
        await videoPlayerController3.initialize();
        controller.insert(2, videoPlayerController3);
      }
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
