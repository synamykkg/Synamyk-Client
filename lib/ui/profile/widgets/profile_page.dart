import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/repositories/user/image/image_repository.dart';

import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_exit_modal.dart';
import 'package:synamyk/ui/profile/bloc/change_user_info/change_user_info_bloc.dart';
import 'package:synamyk/ui/profile/bloc/change_user_info/change_user_info_event.dart';
import 'package:synamyk/ui/profile/bloc/change_user_info/change_user_info_state.dart';
import 'package:synamyk/ui/profile/bloc/profile_bloc.dart';
import 'package:synamyk/ui/profile/bloc/profile_event.dart';
import 'package:synamyk/ui/profile/bloc/profile_state.dart';
import 'package:synamyk/utils/app_messenger.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => ProfileBloc(
                GetIt.I<UserRepository>(),
                GetIt.I<ImageRepository>(),
                GetIt.I<ProfileRepository>(),
              )..add(LoadProfile()),
        ),
        BlocProvider(create: (context) => ChangeUserInfoBloc()),
      ],
      child: Scaffold(
        bottomNavigationBar: BlocBuilder<AppAuthBloc, AppAuthState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 350,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // context.read<AppAuthBloc>().add(AppAuthLogoutRequested());
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return OrtTestExitModal(
                            onConfirm: () {
                              context.read<AppAuthBloc>().add(
                                AppAuthLogoutRequested(),
                              );
                              Navigator.pop(context, 'confirmed');
                            },
                            onCancel: () {
                              Navigator.pop(context, 'cancelled');
                            },
                            onDismiss: () {},
                            title: l10n.deleteAccount,
                            subTitle: l10n.deleteAccountMessage,
                            confirmText: l10n.exitTestConfirm,
                            cancelText: l10n.exitTestCancel,
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Text(
                      l10n.deleteAccount,
                      style: GoogleFonts.roboto(color: Colors.red),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded && state.avatarError != null) {
              AppMessenger.showError(context, state.avatarError!);
            }
          },
          builder: (context, state) {
            XFile? xFile;
            String firstName = 'Name';
            String lastName = 'Surname';
            String description = 'Description';
            String region = 'Region';
            int totalScore = 0;
            int completedTests = 0;
            String? avatarPath = '';

            if (state is ProfileLoaded) {
              debugPrint("${state.user}");
              if (state.user != null) {
                firstName = state.user!.firstName;
                lastName = state.user!.lastName;
                description = state.user!.description;
                region = state.user!.region;
                totalScore = state.user!.totalScoreValue;
                completedTests = state.user!.completedTestsValue;
                avatarPath = state.user!.avatarPath;
              } else {
                // Handle case where user is null but loaded (e.g. not logged in or no data)
                // For now, we keep defaults or show a "No User" message
              }
              final bloc = context.read<ProfileBloc>();
              final changeUserInfoBloc = context.read<ChangeUserInfoBloc>();
              debugPrint(
                'STATE: ${state.runtimeType}, avatar: ${(state is ProfileLoaded) ? state.user?.avatarPath : null}',
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RefreshIndicator(
                  onRefresh: () async {
                    bloc.add(LoadProfile());
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                            l10n.profileTitle,
                            style: AppTextStyles.appBarTitle,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ProfileAvatar(
                              avatarPath: state.user?.avatarPath,
                              isUpdating: state.isAvatarUpdating,
                              onTap:
                                  () => _showAvatarActionsSheet(
                                    context,
                                    bloc,
                                    hasAvatar:
                                        state.user?.avatarPath != null &&
                                        state.user!.avatarPath!.isNotEmpty,
                                  ),
                            ),
                            Column(
                              children: [
                                Text(
                                  totalScore.toString(),
                                  style: AppTextStyles.profileStatValue,
                                ),
                                Text(
                                  l10n.points,
                                  style: AppTextStyles.profileStatLabel,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  completedTests.toString(),
                                  style: AppTextStyles.profileStatValue,
                                ),
                                Text(
                                  l10n.score,
                                  style: AppTextStyles.profileStatLabel,
                                ),
                              ],
                            ),
                            // Column(
                            //   children: [
                            //     Text(
                            //       '3',
                            //       style: AppTextStyles.profileStatValue,
                            //     ),
                            //     Text(
                            //       l10n.rating,
                            //       style: AppTextStyles.profileStatLabel,
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(width: 16)),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$firstName $lastName',
                              style: AppTextStyles.profileName,
                            ),
                            Text(description, style: AppTextStyles.profileDesc),
                            Text(
                              region,
                              style: AppTextStyles.profileDesc.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 209,
                            height: 32,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE5E5E5),
                                elevation: 0,
                                padding: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48),
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFE5E5E5),
                                  ),
                                ),
                              ),

                              onPressed: () {
                                changeUserInfoBloc.add(
                                  ChangeFirstName(firstName: firstName),
                                );
                                changeUserInfoBloc.add(
                                  ChangeLastName(lastName: lastName),
                                );
                                changeUserInfoBloc.add(
                                  ChangeDescription(description: description),
                                );
                                if (avatarPath != null &&
                                    avatarPath.isNotEmpty) {
                                  changeUserInfoBloc.add(
                                    ChangeAvatar(path: avatarPath),
                                  );
                                }

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: changeUserInfoBloc,
                                      child: FractionallySizedBox(
                                        heightFactor:
                                            0.8, // около 70% высоты экрана
                                        widthFactor: 1.0,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 16,
                                            bottom:
                                                MediaQuery.of(
                                                  context,
                                                ).viewInsets.bottom +
                                                16,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

                                              children: [
                                                // Хендл сверху
                                                Center(
                                                  child: Container(
                                                    width: 40,
                                                    height: 4,
                                                    margin:
                                                        const EdgeInsets.only(
                                                          bottom: 16,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            2,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                // Заголовок и крестик
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      l10n.editProfile,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Аватар
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Container(
                                                    width: 64,
                                                    height: 64,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: BlocBuilder<
                                                      ChangeUserInfoBloc,
                                                      ChangeUserInfoState
                                                    >(
                                                      builder: (
                                                        context,
                                                        changeState,
                                                      ) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            final changeBloc =
                                                                context
                                                                    .read<
                                                                      ChangeUserInfoBloc
                                                                    >();
                                                            final picker =
                                                                ImagePicker();

                                                            final XFile?
                                                            xfile = await picker
                                                                .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .gallery,
                                                                  imageQuality:
                                                                      80,
                                                                );

                                                            if (xfile == null) {
                                                              return;
                                                            }
                                                            debugPrint(
                                                              xfile.path,
                                                            );
                                                            changeBloc.add(
                                                              ChangeAvatar(
                                                                path:
                                                                    xfile.path,
                                                              ),
                                                            );
                                                          },
                                                          child:
                                                              (changeState.avatarPath !=
                                                                          null &&
                                                                      changeState
                                                                          .avatarPath!
                                                                          .isNotEmpty)
                                                                  ? (changeState
                                                                          .avatarPath!
                                                                          .startsWith(
                                                                            'http',
                                                                          )
                                                                      ? Image.network(
                                                                        changeState
                                                                            .avatarPath!,
                                                                        fit:
                                                                            BoxFit.cover,
                                                                        key: ValueKey(
                                                                          changeState
                                                                              .avatarPath!,
                                                                        ),
                                                                      )
                                                                      : Image.file(
                                                                        File(
                                                                          changeState
                                                                              .avatarPath!,
                                                                        ),
                                                                        fit:
                                                                            BoxFit.cover,
                                                                        key: ValueKey(
                                                                          changeState
                                                                              .avatarPath!,
                                                                        ),
                                                                      ))
                                                                  : const Icon(
                                                                    Icons
                                                                        .person,
                                                                  ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 16),

                                                // Поля ввода
                                                TextFormField(
                                                  initialValue: firstName,
                                                  onChanged: (value) {
                                                    changeUserInfoBloc.add(
                                                      ChangeFirstName(
                                                        firstName: value,
                                                      ),
                                                    );
                                                  },

                                                  decoration: InputDecoration(
                                                    labelText: l10n.firstName,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  initialValue: lastName,
                                                  onChanged: (value) {
                                                    changeUserInfoBloc.add(
                                                      ChangeLastName(
                                                        lastName: value,
                                                      ),
                                                    );
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: l10n.lastName,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  initialValue: description,
                                                  onChanged: (value) {
                                                    changeUserInfoBloc.add(
                                                      ChangeDescription(
                                                        description: value,
                                                      ),
                                                    );
                                                  },
                                                  maxLines: 4,
                                                  decoration: InputDecoration(
                                                    labelText: l10n.description,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 16),

                                                // Кнопка Сохранить
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 48,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      final currentState =
                                                          changeUserInfoBloc
                                                              .state;
                                                      bloc.add(
                                                        SaveProfile(
                                                          firstName:
                                                              currentState
                                                                  .firstName,
                                                          lastName:
                                                              currentState
                                                                  .lastName,
                                                          description:
                                                              currentState
                                                                  .description,
                                                          avatarPath:
                                                              currentState
                                                                  .avatarPath ??
                                                              '',
                                                        ),
                                                      );

                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(l10n.saveData),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              // onPressed: () {
                              //   showModalBottomSheet(
                              //     context: context,
                              //     isScrollControlled: true,
                              //     backgroundColor: Colors.white,
                              //     shape: const RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.vertical(
                              //         top: Radius.circular(24),
                              //       ),
                              //     ),
                              //     builder: (context) {
                              //       return FractionallySizedBox(
                              //         heightFactor:
                              //             0.7, // занимает 70% высоты экрана
                              //         widthFactor: 1.0, // на всю ширину
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(16.0),
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Center(
                              //                 child: Container(
                              //                   width: 40,
                              //                   height: 4,
                              //                   margin: const EdgeInsets.only(
                              //                     bottom: 16,
                              //                   ),
                              //                   decoration: BoxDecoration(
                              //                     color: Colors.grey[300],
                              //                     borderRadius:
                              //                         BorderRadius.circular(2),
                              //                   ),
                              //                 ),
                              //               ),
                              //               Text(
                              //                 'Редактировать профиль',
                              //                 style: TextStyle(
                              //                   fontSize: 20,
                              //                   fontWeight: FontWeight.bold,
                              //                 ),
                              //               ),
                              //               const SizedBox(height: 16),
                              //               Row(
                              //                 children: [
                              //                   Text(
                              //                     'Аватар',
                              //                     style: AppTextStyles.settingsItem,
                              //                   ),
                              //                   const SizedBox(width: 16),
                              //                 ],
                              //               ),

                              //               // Здесь можно добавить любое содержимое
                              //               ElevatedButton(
                              //                 onPressed:
                              //                     () => Navigator.pop(context),
                              //                 child: const Text('Закрыть'),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   );
                              // },
                              child: Row(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.editProfile,
                                    style: AppTextStyles.editProfileButton,
                                  ),
                                  SvgPicture.asset('assets/icons/edit.svg'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildListDelegate([
                          _ProfileMenuItem(
                            icon: Icons.tune_rounded,
                            iconColor: const Color(0xFF7B1FA2),
                            iconBackground: const Color(0xFFF4E6FA),
                            label: l10n.settingsData,
                            onTap: () => context.push('/profile/data_settings'),
                          ),
                          const SizedBox(height: 12),
                          _ProfileMenuItem(
                            icon: Icons.language_rounded,
                            iconColor: const Color(0xFF1565C0),
                            iconBackground: const Color(0xFFE3F0FD),
                            label: l10n.settingsLanguage,
                            onTap: () => context.push('/profile/language_change'),
                          ),
                          const SizedBox(height: 12),
                          _ProfileMenuItem(
                            icon: Icons.notifications_rounded,
                            iconColor: const Color(0xFFEF6C00),
                            iconBackground: const Color(0xFFFDECD8),
                            label: 'Настройки уведомлений',
                            onTap:
                                () => context.push(
                                  '/profile/notification_settings',
                                ),
                          ),
                          const SizedBox(height: 12),
                          _ProfileMenuItem(
                            icon: Icons.history_rounded,
                            iconColor: const Color(0xFF00897B),
                            iconBackground: const Color(0xFFDCF3F0),
                            label: 'История тестов',
                            onTap: () => context.push('/profile/tests_history'),
                          ),
                          const SizedBox(height: 12),
                          _ProfileMenuItem(
                            icon: Icons.receipt_long_rounded,
                            iconColor: const Color(0xFF2E7D32),
                            iconBackground: const Color(0xFFE8F5E9),
                            label: 'Мои покупки',
                            onTap: () => context.push('/profile/purchases'),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

/// A settings/navigation row styled as an actual card — colored icon badge,
/// label, and a chevron — instead of a plain text row, so it clearly reads
/// as tappable.
class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: AppTextStyles.settingsItem),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9E9E9E),
            ),
          ],
        ),
      ),
    );
  }
}

void _showAvatarActionsSheet(
  BuildContext context,
  ProfileBloc bloc, {
  required bool hasAvatar,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      Future<void> pick(ImageSource source) async {
        Navigator.pop(sheetContext);
        final picked = await ImagePicker().pickImage(
          source: source,
          imageQuality: 90,
        );
        if (picked == null) return;
        bloc.add(UploadAvatarRequested(picked.path));
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Фото профиля', style: AppTextStyles.testCardTitle),
              const SizedBox(height: 16),
              _SheetActionButton(
                icon: Icons.photo_camera_outlined,
                label: 'Сделать фото',
                color: const Color(0xFF7B1FA2),
                background: const Color(0xFFF4E6FA),
                onTap: () => pick(ImageSource.camera),
              ),
              const SizedBox(height: 10),
              _SheetActionButton(
                icon: Icons.photo_library_outlined,
                label: 'Выбрать из галереи',
                color: const Color(0xFF7B1FA2),
                background: const Color(0xFFF4E6FA),
                onTap: () => pick(ImageSource.gallery),
              ),
              if (hasAvatar) ...[
                const SizedBox(height: 10),
                _SheetActionButton(
                  icon: Icons.delete_outline,
                  label: 'Удалить фото',
                  color: Colors.red,
                  background: const Color(0xFFFDEAEA),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    bloc.add(DeleteAvatarRequested());
                  },
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

class _SheetActionButton extends StatelessWidget {
  const _SheetActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.settingsItem.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// The avatar circle with an explicit edit button badge (bottom-right) that
/// opens the photo/gallery/delete sheet — tapping the photo itself does the
/// same, but the badge makes it obvious there's an action available. A
/// loader overlays the avatar while an upload/delete request is in flight.
/// Presigned `avatarUrl`s are cached in memory keyed by the object key
/// (the URL before `?`) rather than the full signed URL, since the
/// signature changes every time the profile is refetched.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.avatarPath,
    required this.isUpdating,
    required this.onTap,
  });

  final String? avatarPath;
  final bool isUpdating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarPath != null && avatarPath!.isNotEmpty;
    final isNetwork = hasAvatar && avatarPath!.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        height: 72,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(24),
                image:
                    hasAvatar
                        ? DecorationImage(
                          image:
                              isNetwork
                                  ? CachedNetworkImageProvider(
                                    avatarPath!,
                                    cacheKey: avatarPath!.split('?').first,
                                  )
                                  : FileImage(File(avatarPath!))
                                      as ImageProvider,
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child: !hasAvatar ? const Icon(Icons.person) : null,
            ),
            if (isUpdating)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF7B1FA2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
