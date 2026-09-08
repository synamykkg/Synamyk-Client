import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question_result.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/ort_tests/pages/ort_test_page.dart';
import 'package:synamyk/utils/format_duration.dart';

/// Renders a finished sub-test session's result. Used both right after
/// finishing a test and when revisiting a past attempt from its history
/// (fetched by sessionId).
class OrtTestCompletedView extends StatelessWidget {
  const OrtTestCompletedView({
    super.key,
    required this.finishResult,
    required this.language,
    required this.id,
  });

  final OrtSubTestFinishResult finishResult;
  final String language;
  final int id;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          // actionsPadding: EdgeInsets.all(0)
          titleSpacing: 0,
          actionsPadding: EdgeInsets.zero, //

          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(l10n.levelOne, style: AppTextStyles.appBarTitle),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Text(l10n.yourResult, style: AppTextStyles.resultTitle),
              Text(
                l10n.resultSuccessMessage,
                style: AppTextStyles.resultSubtitle,
              ),
              //
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 100, // высота = половина ширины для полукруга
                  child: CustomPaint(
                    painter: SemiCircleProgressPainter(
                      progress:
                          (finishResult.correctAnswers /
                              finishResult.totalQuestions),
                    ), // 50%
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.orange,
                              size: 30,
                            ),
                            Text(
                              '${finishResult.percentage}%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(l10n.correctAnswers),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      l10n.correctAnswersOf(
                        finishResult.correctAnswers,
                        finishResult.totalQuestions,
                      ),
                      style: AppTextStyles.statValueGreen,
                    ),
                    Text(l10n.testLabel, style: AppTextStyles.statLabel),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      formatDuration(finishResult.timeTakenSeconds),
                      style: AppTextStyles.statValueGreen,
                    ),
                    Text(l10n.timeLabel, style: AppTextStyles.statLabel),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return _OrtTestResultsModal(
                        results: finishResult.questionResults,
                        language: language,
                        id: id,
                        sessionId: finishResult.sessionId,
                      );
                    },
                  );
                },
                child: Container(
                  width: 166,
                  height: 102,
                  decoration: BoxDecoration(
                    color: Color(0xFFF4E6FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Color(0xFF4527A0).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 15),
                      ),
                      Text(
                        l10n.viewErrors,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.modalText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrtTestResultsModal extends StatefulWidget {
  final List<OrtSubTestQuestionResult> results;
  final String language;
  final int id;
  final int sessionId;

  const _OrtTestResultsModal({
    required this.results,
    required this.language,
    required this.id,
    required this.sessionId,
  });

  @override
  State<_OrtTestResultsModal> createState() => _OrtTestResultsModalState();
}

class _OrtTestResultsModalState extends State<_OrtTestResultsModal> {
  final Set<String> selectedIds = {};

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap:
                selectedIds.isEmpty
                    ? null
                    : () {
                      final selectedResults =
                          widget.results
                              .where(
                                (r) => selectedIds.contains(
                                  r.questionId.toString(),
                                ),
                              )
                              .toList();
                      GoRouter.of(context).push(
                        '/ort_test/${widget.language}/${widget.id}/ai_analyst',

                        // extra: selectedResults,
                        extra: {
                          'sessionId': widget.sessionId,
                          'results': selectedResults,
                        },
                      );
                    },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: selectedIds.isEmpty ? Colors.grey : Colors.black,
              ),
              child:  Center(
                child: Text(
                  l10n.analyzeWithAi,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                pinned: false,
                floating: false,
                snap: false,
                titleSpacing: 0,
                title: Text(l10n.results, style: AppTextStyles.headlineLarge),
              ),
              SliverGrid.builder(
                itemCount: widget.results.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final result = widget.results[index];
                  final isSelected = selectedIds.contains(
                    result.questionId.toString(),
                  );
                  final isSkipped = result.isSkipped;
                  // AI analysis only makes sense for wrong answers: a
                  // correct or skipped question has no "error" to explain,
                  // and the backend returns an empty analysis for it.
                  final isSelectable = !isSkipped && !result.isCorrect;

                  return GestureDetector(
                    onTap:
                        isSelectable
                            ? () =>
                                _toggleSelection(result.questionId.toString())
                            : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelectable
                                ? Colors.white
                                : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isSelected
                                  ? Colors.purple
                                  : const Color(
                                    0xFF252525,
                                  ).withOpacity(isSelectable ? 0.5 : 0.2),
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isSkipped
                                            ? Colors.orange
                                            : result.isCorrect
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  child: Icon(
                                    isSkipped
                                        ? Icons.emoji_events
                                        : result.isCorrect
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                Text(
                                  '№${index + 1}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Color(
                                      result.isCorrect
                                          ? 0xFF08A64A
                                          : 0xFFE34444,
                                    ).withOpacity(isSelectable ? 0.5 : 0.2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
