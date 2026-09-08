import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/ort_tests/bloc/ort_test_bloc.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_exit_modal.dart';
import 'package:synamyk/utils/format_duration.dart';
import 'package:synamyk/widgets/math_text.dart';

class OrtTestView extends StatelessWidget {
  const OrtTestView({super.key, required this.state});

  final OrtTestLoaded state;

  void _showExitModal(BuildContext context, S l10n) {
    final bloc = context.read<OrtTestBloc>();

    bloc.add(OpenExitModal());

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => OrtTestExitModal(
            onConfirm: () {
              bloc.add(SubmitExitModal());
              Navigator.pop(context, 'confirmed');
              context.go('/home');
            },
            onCancel: () {
              bloc.add(CloseExitModal());
              Navigator.pop(context, 'cancelled');
            },
            onDismiss: () {
              bloc.add(CloseExitModal());
            },
            title: l10n.exitTestTitle,
            subTitle: l10n.exitTestMessage,
            confirmText: l10n.exitTestConfirm,
            cancelText: l10n.exitTestCancel,
          ),
    ).then((result) {
      if (result == null) {
        bloc.add(CloseExitModal());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ortTest = state.ortTestList;
    final l10n = S.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          // actionsPadding: EdgeInsets.all(0)
          leadingWidth: 20,
          titleSpacing: 0,
          actionsPadding: EdgeInsets.zero, //
          leading: GestureDetector(
            onTap: () {
              // context.go('/home/');
              _showExitModal(context, l10n);
            },
            child: Container(child: Icon(Icons.close, color: Colors.black)),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(l10n.levelOne, style: AppTextStyles.appBarTitle),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Column(
              spacing: 8,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 4,
                  width: 350,
                  child: LinearProgressIndicator(
                    value: ortTest.index / ortTest.totalQuestions,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.contact_support, size: 16),
                        Text(
                          '${ortTest.index}/${ortTest.totalQuestions}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          formatDuration(state.duration),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                          ),
                        ),
                        Icon(Icons.access_time_outlined, size: 16),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MathText(ortTest.text, style: AppTextStyles.questionTitle),
              // Text(
              //   state.ortTestList[state.pages].question,
              //   style: AppTextStyles.questionText,
              // ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            final isSelected = state.variants.contains(ortTest.options[index]);
            return Card(
              // borderOnForeground: false,
              elevation: 0,
              // margin: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () {
                  context.read<OrtTestBloc>().add(
                    SelectVariantTest(variant: ortTest.options[index]),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      style: isSelected ? BorderStyle.solid : BorderStyle.none,
                      color: const Color.fromARGB(255, 147, 37, 167),
                    ),
                    color: Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 350,
                  constraints: const BoxConstraints(minHeight: 52),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: isSelected ? 7 : 2,
                              color: const Color.fromARGB(255, 147, 37, 167),
                            ),
                          ),
                        ),
                        Text(
                          ortTest.options[index].label,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Expanded(
                          child: MathText(
                            ortTest.options[index].text,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }, childCount: state.ortTestList.options.length),
        ),
      ],
    );
  }
}
