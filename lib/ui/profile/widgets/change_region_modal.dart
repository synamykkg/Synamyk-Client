import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/domain/enums/region.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/auth/widgets/select_option_for_auth.dart';
import 'package:synamyk/ui/core/ui/widgets/reusable_modal.dart';
import 'package:synamyk/ui/profile/bloc/change_region/change_region_bloc.dart';
import 'package:synamyk/utils/app_messenger.dart';

class ChangeRegionModal extends StatelessWidget {
  final RegionEnum? initialRegion;
  const ChangeRegionModal({super.key, this.initialRegion});

  static void show(BuildContext context, RegionEnum? currentRegion) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ChangeRegionModal(initialRegion: currentRegion),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ChangeRegionBloc(
            userRepository: GetIt.I<UserRepository>(),
            profileRepository: GetIt.I<ProfileRepository>(),
            regionsRepository: GetIt.I<RegionsRepository>(),
          )..add(ChangeRegionList()),
      child: const _ChangeRegionModalContent(),
    );
  }
}

class _ChangeRegionModalContent extends StatelessWidget {
  const _ChangeRegionModalContent();

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocConsumer<ChangeRegionBloc, ChangeRegionState>(
      listener: (context, state) {
        if (state.status == ChangeRegionStatus.success) {
          Navigator.of(context).pop();
          AppMessenger.showSuccess(context, l10n.regionChanged);
        } else if (state.status == ChangeRegionStatus.failure) {
          AppMessenger.showError(
            context,
            state.errorMessage?.isNotEmpty == true
                ? state.errorMessage!
                : l10n.errorOccurred,
          );
        }
      },
      builder: (context, state) {
        return ReusableModal(
          title: l10n.changeRegion,
          heightFactor: 0.5,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  // Region selector
                  if (state.regions == null)
                    const Center(child: CircularProgressIndicator())
                  else
                    SelectOptionForAuth(
                      value: state.selectedRegion?.name,
                      region: state.selectedRegion,
                      items: state.regions ?? [],
                      onChanged: (index) {
                        if (index != null && state.regions != null) {
                          context.read<ChangeRegionBloc>().add(
                            ChangeRegionSelected(region: state.regions![index]),
                          );
                        }
                      },
                      label: l10n.region,
                    ),
                  const SizedBox(height: 24),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          state.selectedRegion == null
                              ? null
                              : () {
                                context.read<ChangeRegionBloc>().add(
                                  ChangeRegionSubmitted(),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            state.selectedRegion == null
                                ? Colors.grey
                                : Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          state.status == ChangeRegionStatus.loading
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
