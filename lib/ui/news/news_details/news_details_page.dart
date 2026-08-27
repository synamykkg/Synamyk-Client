import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/news/news_repository.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/news/news_details/bloc/news_details_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';

class NewsDetailsPage extends StatefulWidget {
  const NewsDetailsPage({super.key, required this.newsId});

  final String newsId;

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return BlocProvider(
      create:
          (_) =>
              NewsDetailsCubit(newsRepository: GetIt.I<NewsRepository>())
                ..loadNews(widget.newsId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.newsDetails, style: AppTextStyles.appBarTitle),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
        ),
        body: BlocConsumer<NewsDetailsCubit, NewsDetailsState>(
          listener: (context, state) async {
            if (state is NewsDetailsLoaded) {
              await controller.loadHtmlString(state.html);
            }
          },
          builder: (context, state) {
            if (state is NewsDetailsFailure) {
              return Center(child: Text(state.exception.toString()));
            }
            if (state is NewsDetailsLoaded) {
              return WebViewWidget(controller: controller);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
