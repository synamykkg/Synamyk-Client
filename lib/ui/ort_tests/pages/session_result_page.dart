import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_completed_view.dart';

/// Read-only view of an already-finished session's result, reached from
/// [SubTestHistoryPage] by sessionId (as opposed to [OrtTestCompletedView]
/// shown right after finishing a test, which comes from live bloc state).
class SessionResultPage extends StatefulWidget {
  const SessionResultPage({
    super.key,
    required this.sessionId,
    required this.testId,
    required this.subTestId,
  });

  final int sessionId;
  final String testId;
  final int subTestId;

  @override
  State<SessionResultPage> createState() => _SessionResultPageState();
}

class _SessionResultPageState extends State<SessionResultPage> {
  late Future<OrtSubTestFinishResult> _future;

  @override
  void initState() {
    super.initState();
    _future = GetIt.I<OrtTestsRepository>().getSessionResult(
      widget.sessionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder<OrtSubTestFinishResult>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text(
                      'Не удалось загрузить результат',
                      style: AppTextStyles.bodyMedium,
                    ),
                  );
                }

                return OrtTestCompletedView(
                  finishResult: snapshot.data!,
                  language: widget.testId,
                  id: widget.subTestId,
                );
              },
            ),
            Positioned(
              top: 4,
              left: 4,
              child: BackButton(
                color: Colors.black,
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
