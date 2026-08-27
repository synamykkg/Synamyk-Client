import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/auth/widgets/text_field_for_auth.dart';
import 'package:synamyk/ui/core/ui/widgets/reusable_modal.dart';
import 'package:synamyk/ui/profile/bloc/change_password/change_password_bloc.dart';
import 'package:synamyk/ui/profile/bloc/change_password/change_password_event.dart';
import 'package:synamyk/ui/profile/bloc/change_password/change_password_state.dart';
import 'package:synamyk/utils/app_messenger.dart';

class ChangePasswordModal extends StatelessWidget {
  const ChangePasswordModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => BlocProvider(
            create: (context) => ChangePasswordBloc(),
            child: const ChangePasswordModal(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.status == ChangePasswordStatus.success) {
          Navigator.pop(context);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Пароль успешно изменен')),
          // );
          AppMessenger.showSuccess(context, l10n.passwordChanged);
        }
        if (state.status == ChangePasswordStatus.failure) {
          AppMessenger.showError(
            context,
            state.errorMessage ?? l10n.errorOccurred,
          );
        }
      },
      builder: (context, state) {
        return ReusableModal(
          title: l10n.changePassword,
          heightFactor: 0.8,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Old phone input
                  TextFieldForAuth(
                    text: l10n.oldPassword,
                    isPassword: true,
                    obscureText: state.isOldPasswordObscured,
                    onVisibilityToggle: () {
                      context.read<ChangePasswordBloc>().add(
                        ChangeToggleOldPasswordVisibility(),
                      );
                    },
                    onChanged: (value) {
                      context.read<ChangePasswordBloc>().add(
                        ChangePasswordOldPasswordChanged(value),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  TextFieldForAuth(
                    text: l10n.newPassword,
                    isPassword: true,
                    obscureText: state.isNewPasswordObscured,
                    onVisibilityToggle: () {
                      context.read<ChangePasswordBloc>().add(
                        ChangeToggleNewPasswordVisibility(),
                      );
                    },
                    onChanged: (value) {
                      context.read<ChangePasswordBloc>().add(
                        ChangePasswordNewPasswordChanged(value),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  TextFieldForAuth(
                    text: l10n.confirmNewPassword,
                    isPassword: true,
                    obscureText: state.isConfirmPasswordObscured,
                    onVisibilityToggle: () {
                      context.read<ChangePasswordBloc>().add(
                        ChangeToggleConfirmPasswordVisibility(),
                      );
                    },
                    onChanged: (value) {
                      context.read<ChangePasswordBloc>().add(
                        ChangePasswordConfirmPasswordChanged(value),
                      );
                    },
                    errorText:
                        state.errorMessage?.isNotEmpty == true
                            ? state.errorMessage
                            : null,
                  ),

                  const SizedBox(height: 24),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ChangePasswordBloc>().add(
                          ChangePasswordSubmitted(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            state.oldPassword.isEmpty ||
                                    state.newPassword.isEmpty ||
                                    state.confirmPassword.isEmpty
                                ? Colors.grey
                                : Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          state.status == ChangePasswordStatus.loading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
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
