class VideoModel {
  final String id;
  final String videoUrl;

  VideoModel({
    required this.id,
    required this.videoUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json["postId"],
        videoUrl: json["submission"]["mediaUrl"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "videoUrl": videoUrl,
      };
}
