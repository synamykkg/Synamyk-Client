import 'package:flutter/material.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/ort_tests/bloc/ort_test_bloc.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_bottom_bar_completed_view.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_bottom_bar_view.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_completed_view.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_view.dart';

class OrtTestBottomBarContent extends StatelessWidget {
  const OrtTestBottomBarContent({
    super.key,
    required this.state,
    required this.language,
    required this.id,
  });

  final OrtTestState state;
  final String language;
  final int id;

  @override
  Widget build(BuildContext context) {
    if (state is OrtTestLoaded) {
      return OrtTestBottomBarView(state: state as OrtTestLoaded);
    }

    if (state is OrtTestCompleted) {
      return OrtTestBottomBarCompletedView(
        language: language,
        id: id,
      );
    }
    
    return SizedBox();
  }
}
