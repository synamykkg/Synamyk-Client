import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:synamyk/utils/math_text_parser.dart';

/// Renders [data] as plain text, transparently rendering any `$...$` /
/// `$$...$$` LaTeX segments (see [parseMathText]) as math. Falls back to a
/// plain [Text] when there's no math, so lists that mostly show ordinary
/// text don't pay for a RichText tree.
class MathText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;

  const MathText(
    this.data, {
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final segments = parseMathText(data);
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;

    if (segments.length == 1 && segments.first.type == MathSegmentType.text) {
      return Text(data, style: effectiveStyle, textAlign: textAlign, maxLines: maxLines);
    }

    // Block formulas need their own centered line, so consecutive
    // text/inlineMath segments are grouped into paragraphs and block
    // formulas become standalone entries between them.
    final children = <Widget>[];
    var run = <InlineSpan>[];

    void flushRun() {
      if (run.isEmpty) return;
      children.add(
        Text.rich(TextSpan(children: run), textAlign: textAlign, maxLines: maxLines),
      );
      run = [];
    }

    for (final segment in segments) {
      switch (segment.type) {
        case MathSegmentType.text:
          run.add(TextSpan(text: segment.content, style: effectiveStyle));
        case MathSegmentType.inlineMath:
          run.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Math.tex(
                segment.content,
                mathStyle: MathStyle.text,
                textStyle: effectiveStyle,
                onErrorFallback: (_) => Text('\$${segment.content}\$', style: effectiveStyle),
              ),
            ),
          );
        case MathSegmentType.blockMath:
          flushRun();
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(
                    segment.content,
                    mathStyle: MathStyle.display,
                    textStyle: effectiveStyle,
                    onErrorFallback: (_) => Text('\$\$${segment.content}\$\$', style: effectiveStyle),
                  ),
                ),
              ),
            ),
          );
      }
    }
    flushRun();

    if (children.length == 1) return children.first;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: children);
  }
}
