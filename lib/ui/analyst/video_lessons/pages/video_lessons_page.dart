import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/video_lessons/video_lessons_repository.dart';
import 'package:synamyk/ui/analyst/video_lessons/bloc/video_lessons_bloc.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoLessonsPage extends StatelessWidget {
  const VideoLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create:
            (context) =>
                VideoLessonsBloc(GetIt.I<VideoLessonsRepository>())
                  ..add(VideoLessonsRequest()),
        child: BlocBuilder<VideoLessonsBloc, VideoLessonsState>(
          builder: (context, state) {
            if (state is VideoLessonsLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final lesson = state.videoLessons[index];
                      return GestureDetector(
                        onTap: () => _launchUrl(lesson.videoUrl),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 350,
                                minHeight: 114,
                              ),
                              child: Container(
                                width: 350,
                                height: 342,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(
                                      0xFF252525,
                                    ).withOpacity(0.1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 326,
                                      height: 204,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              lesson.previewUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.play_circle_outline,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ),
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                child: const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${lesson.title.length >= 27 ? lesson.title.substring(0, 27) : lesson.title}...',
                                            style: AppTextStyles.newsTitle,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${lesson.description.length >= 100 ? lesson.description.substring(0, 100) : lesson.description}...',
                                            style: AppTextStyles.newsSubtitle,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                lesson.date,
                                                style: AppTextStyles.newsDate,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  lesson.duration,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: state.videoLessons.length),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            }
            if (state is VideoLessonsFailure) {
              return Center(child: Text(state.exception.toString()));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
