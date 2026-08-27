import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/data/repositories/news/news_repository.dart';
import 'package:synamyk/ui/news/news_list/bloc/news_bloc.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(

      body: BlocProvider(
        create:
            (context) =>
                NewsListBloc(GetIt.I<NewsRepository>())..add(NewsListRequest()),
        child: BlocBuilder<NewsListBloc, NewsListState>(
          builder: (context, state) {
            if (state is NewsListLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => GestureDetector(
                        onTap: () {
                          context.push(
                            '/news_details',
                            extra: state.newsLists[index].id,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 350,
                                minHeight: 114,
                              ),

                              child: Container(
                                width: 350,
                                height: 342,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF252525).withOpacity(0.1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 326,
                                      height: 204,

                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          state.newsLists[index].image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                    size: 32,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        spacing: 5,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.newsLists[index].title,
                                            style: AppTextStyles.newsTitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            state.newsLists[index].subTitle,
                                            style: AppTextStyles.newsSubtitle,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            state.newsLists[index].date,
                                            style: AppTextStyles.newsDate,
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
                      ),

                      childCount: state.newsLists.length,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            }
            if (state is NewsListFailure) {
              return Center(child: Text(l10n.errorUnknown));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
