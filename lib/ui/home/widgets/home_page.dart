import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/ui/home/bloc/home/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      body: BlocProvider(
        create:
            (context) =>
                HomeBloc(GetIt.I<HomeRepository>())..add(GetSubjectsList()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    snap: false,

                    // App bar is not pinned at the top
                    pinned: true,

                    // App bar does not float
                    floating: false,
                    actions: const [_NotificationsBellButton()],
                    flexibleSpace: FlexibleSpaceBar(
                      // Center the title in the app bar
                      centerTitle: true,
                      title: Text.rich(
                        TextSpan(
                          text: l10n.homeTests,
                          style: AppTextStyles.homeTitle,
                          children: [
                            TextSpan(
                              text: l10n.appName,
                              style: AppTextStyles.homeTitleAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // SliverList.builder(
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return ListTile(title: Text('Item $index'));
                  //   },
                  //   itemCount: 40,
                  // ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 350,
                              minHeight: 114,
                            ),

                            child: GestureDetector(
                              onTap: () {
                                context.push(
                                  '/home/tests/${state.subjects[index].id}',
                                );
                              },
                              child: Container(
                                width: 350,
                                constraints: const BoxConstraints(
                                  minHeight: 114,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF252525).withOpacity(0.1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          // spacing: ,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.subjects[index].title,
                                              style: AppTextStyles.ortCardTitle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              state.subjects[index].subTitle,
                                              style: AppTextStyles.ortCardDesc,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (state.subjects[index].subTestCount > 0) ...[
                                              const SizedBox(height: 6),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(4),
                                                child: LinearProgressIndicator(
                                                  value: state.subjects[index].progressPercent / 100,
                                                  minHeight: 4,
                                                  backgroundColor: const Color(0xFFE0E0E0),
                                                  valueColor: const AlwaysStoppedAnimation(Color(0xFF7B1FA2)),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${state.subjects[index].completedSubTestCount} из ${state.subjects[index].subTestCount}',
                                                style: AppTextStyles.ortCardDesc,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/home/circle_ort_card.png',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      childCount: state.subjects.length,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _NotificationsBellButton extends StatefulWidget {
  const _NotificationsBellButton();

  @override
  State<_NotificationsBellButton> createState() =>
      _NotificationsBellButtonState();
}

class _NotificationsBellButtonState extends State<_NotificationsBellButton> {
  late Future<int> _unreadCount;

  @override
  void initState() {
    super.initState();
    _unreadCount = GetIt.I<NotificationsRepository>().getUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _unreadCount,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return IconButton(
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            child: const Icon(Icons.notifications_outlined, color: Colors.black),
          ),
          onPressed: () => context.push('/notifications'),
        );
      },
    );
  }
}
