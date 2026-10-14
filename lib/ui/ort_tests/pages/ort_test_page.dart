import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/ui/ort_tests/bloc/ort_test_bloc.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_body_content.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_bottom_bar_content.dart';
import 'package:synamyk/utils/format_duration.dart';
import 'dart:math';

import 'package:synamyk/utils/ticker.dart';

class OrtTestPage extends StatelessWidget {
  const OrtTestPage({super.key, required this.language, required this.id});

  final String language;
  final int id;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => OrtTestBloc(
                ortTestRepository: GetIt.I<OrtTestsRepository>(),
                ticker: Ticker(),
              )..add(LoadOrtTest(language: language, id: id)),
        ),
      ],
      child: BlocConsumer<OrtTestBloc, OrtTestState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: BlocBuilder<OrtTestBloc, OrtTestState>(
                  builder: (context, state) {
                    return OrtTestBottomBarContent(
                      state: state,
                      language: language,
                      id: id,
                    );
                  },
                ),
              ),
            ),
            body: BlocConsumer<OrtTestBloc, OrtTestState>(
              listener: (context, state) {},
              builder: (context, state) {
                return OrtTestBodyContent(
                  state: state,
                  language: language,
                  id: id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SemiCircleProgressPainter extends CustomPainter {
  final double progress;

  SemiCircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 17.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final startAngle = pi;
    final sweepAngle = pi * progress;

    final bgPaint =
        Paint()
          ..color = Colors.grey[300]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final progressPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.green, Colors.blue],
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, pi, pi, false, bgPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
