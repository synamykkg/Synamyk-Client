import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/features/otp/models/otp_config.dart';
import 'package:synamyk/ui/core/ui/widgets/reusable_modal.dart';
import 'package:synamyk/ui/profile/bloc/change_phone/change_phone_bloc.dart';

class ChangePhoneModal extends StatelessWidget {
  const ChangePhoneModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ChangePhoneModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ChangePhoneBloc(
            authRepository: GetIt.I<AuthRepository>(),
            profileRepository: GetIt.I<ProfileRepository>(),
          ),
      child: const _ChangePhoneModalContent(),
    );
  }
}

class _ChangePhoneModalContent extends StatefulWidget {
  const _ChangePhoneModalContent();

  @override
  State<_ChangePhoneModalContent> createState() =>
      _ChangePhoneModalContentState();
}

class _ChangePhoneModalContentState extends State<_ChangePhoneModalContent> {
  final _oldPhoneController = TextEditingController();
  final _newPhoneController = TextEditingController();

  @override
  void dispose() {
    _oldPhoneController.dispose();
    _newPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return BlocConsumer<ChangePhoneBloc, ChangePhoneState>(
      listener: (context, state) {
        if (state.status == ChangePhoneStatus.success) {
          // Navigator.of(context).pop();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Номер телефона успешно изменен'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
          context.go(
            '/otp',
            extra: OtpConfig(
              phone: state.oldPhone,
              onConfirm:
                  (code, phone) => GetIt.I<ProfileRepository>()
                      .changePhoneConfirm(phone, code),
              onResend:
                  (phone) => GetIt.I<ProfileRepository>().changePhone(
                    state.oldPhone,
                    state.newPhone,
                  ),
              successRoute: '/profile',
            ),
          );
        } else if (state.status == ChangePhoneStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? l10n.errorOccurred),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return ReusableModal(
          title: l10n.changePhone,
          heightFactor: 0.8,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Old phone input
                  TextField(
                    controller: _oldPhoneController,
                    decoration: InputDecoration(
                      labelText: l10n.oldPhone,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      context.read<ChangePhoneBloc>().add(
                        ChangePhoneOldPhoneChanged(value),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newPhoneController,
                    decoration: InputDecoration(
                      labelText: l10n.newPhone,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      context.read<ChangePhoneBloc>().add(
                        ChangePhoneNewPhoneChanged(value),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ChangePhoneBloc>().add(
                          ChangePhoneSubmitted(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            state.oldPhone.isEmpty || state.newPhone.isEmpty
                                ? Colors.grey
                                : const Color(0xFF6D35E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.saveData,
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
