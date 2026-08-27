import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/ort_tests/bloc/ort_test_bloc.dart';

class OrtTestBottomBarView extends StatelessWidget {
  const OrtTestBottomBarView({super.key, required this.state});

  final OrtTestLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap:
              (state.variants.isEmpty || state.isLoading)
                  ? null
                  : () => context.read<OrtTestBloc>().add(SubmitOrtTest()),
          child: Container(
            width: 350,
            height: 48,
            decoration: BoxDecoration(
              color:
                  state.variants.isNotEmpty
                      ? Color(0xFF7B1FA2)
                      : Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child:
                  state.isLoading
                      ? CircularProgressIndicator()
                      : Text(l10n.next, style: AppTextStyles.buttonText),
            ),
          ),
        ),
        Container(
          width: 350,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () => {context.read<OrtTestBloc>().add(SkipOrtTest())},
            child: Center(
              child: Text(
                l10n.skipQuestion,
                style: AppTextStyles.buttonTextPurple,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
