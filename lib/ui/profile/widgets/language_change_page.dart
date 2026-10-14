import 'package:flutter/material.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/features/language/bloc/language_bloc.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';

class LanguageChangePage extends StatelessWidget {
  const LanguageChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: SyAppBar(title: l10n.settingsLanguage),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverList(
                    delegate: SliverChildListDelegate([
                      GestureDetector(
                        onTap: () {
                          context.read<LanguageBloc>().add(
                            LanguageChanged(AppLanguage.russian),
                          );
                        },
                        child: Container(
                          width: 350,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Text(
                                  l10n.langRussian,
                                  style: AppTextStyles.settingsItem,
                                ),
                                Icon(Icons.settings, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     width: 350,
                      //     height: 44,
                      //     decoration: BoxDecoration(
                      //       color: Color(0xFFF6F6F6),
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 16),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         crossAxisAlignment: CrossAxisAlignment.center,

                      //         children: [
                      //           Text(
                      //             l10n.langEnglish,
                      //             style: AppTextStyles.settingsItem,
                      //           ),
                      //           Icon(Icons.settings, color: Colors.black),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          context.read<LanguageBloc>().add(
                            LanguageChanged(AppLanguage.kyrgyz),
                          );
                        },
                        child: Container(
                          width: 350,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Text(
                                  l10n.langKyrgyz,
                                  style: AppTextStyles.settingsItem,
                                ),
                                Icon(Icons.settings, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
