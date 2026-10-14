import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_tests/bloc/ort_test_bloc.dart';

class OrtTestBottomBarView extends StatelessWidget {
  const OrtTestBottomBarView({super.key, required this.state});

  final OrtTestLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SyButton(
          label: l10n.next,
          icon: Icons.arrow_forward_rounded,
          loading: state.isLoading,
          onPressed:
              state.variants.isEmpty
                  ? null
                  : () => context.read<OrtTestBloc>().add(SubmitOrtTest()),
        ),
        const SizedBox(height: 6),
        SyButton(
          label: l10n.skipQuestion,
          style: SyButtonStyle.ghost,
          height: 44,
          onPressed:
              state.isLoading
                  ? null
                  : () => context.read<OrtTestBloc>().add(SkipOrtTest()),
        ),
      ],
    );
  }
}
