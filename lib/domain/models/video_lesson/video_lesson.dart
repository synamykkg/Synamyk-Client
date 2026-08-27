class VideoLesson {
  const VideoLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.previewUrl,
    required this.videoUrl,
    required this.date,
    required this.duration,
  });
  final String id;
  final String title;
  final String description;
  final String previewUrl;
  final String videoUrl;
  final String date;
  final String duration;

  factory VideoLesson.fromJson(Map<String, dynamic> json) {
    return VideoLesson(
      id: json['id'],
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      previewUrl: json['snippet']['thumbnails']['high']['url'],
      videoUrl: 'https://www.youtube.com/watch?v=${json['id']}',
      date: json['snippet']['publishedAt'],
      duration: json['contentDetails']['duration'],
    );
  }
}
