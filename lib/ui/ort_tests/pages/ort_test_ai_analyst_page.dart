import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question_result.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/ort_tests/bloc/ai_analyst/ort_test_ai_analyst_bloc.dart';

class OrtTestAiAnalystPage extends StatelessWidget {
  const OrtTestAiAnalystPage({
    super.key,
    required this.results,
    required this.sessionId,
  });

  final List<OrtSubTestQuestionResult> results;
  final int sessionId;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return BlocProvider(
      create:
          (context) =>
              OrtTestAiAnalystBloc(GetIt.I<OrtTestsRepository>())
                ..add(LoadAiAnalysis(sessionId, results)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.aiAnalysis, style: AppTextStyles.appBarTitle),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: BlocBuilder<OrtTestAiAnalystBloc, OrtTestAiAnalystState>(
          builder: (context, state) {
            if (state is OrtTestAiAnalystLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            } else if (state is OrtTestAiAnalystFailure) {
              return Center(child: Text(state.message));
            } else if (state is OrtTestAiAnalystLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.results.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final result = state.results[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.questionNumber(index + 1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          result.question,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 16),
                        // User Answer
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                l10n.yourAnswer,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                result.userAnswer,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        // Correct Answer
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                l10n.correctAnswer,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                result.correctAnswer,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                         Text(
                          l10n.aiExplanation,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          result.explanation,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
