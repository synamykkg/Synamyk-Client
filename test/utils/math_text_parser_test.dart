import 'package:flutter_test/flutter_test.dart';
import 'package:synamyk/utils/math_text_parser.dart';

void main() {
  group('parseMathText', () {
    test('text without formulas returns a single text segment', () {
      const input = 'Найдите значение выражения x при условии';
      expect(
        parseMathText(input),
        [const MathSegment(MathSegmentType.text, input)],
      );
    });

    test('only a formula returns a single inlineMath segment', () {
      expect(
        parseMathText(r'$\frac{3}{4}$'),
        [const MathSegment(MathSegmentType.inlineMath, r'\frac{3}{4}')],
      );
    });

    test('text + formula + text', () {
      expect(
        parseMathText(r'Найдите значение $\frac{3}{4} + \sqrt{16}$ при $x > 0$'),
        [
          const MathSegment(MathSegmentType.text, 'Найдите значение '),
          const MathSegment(
            MathSegmentType.inlineMath,
            r'\frac{3}{4} + \sqrt{16}',
          ),
          const MathSegment(MathSegmentType.text, ' при '),
          const MathSegment(MathSegmentType.inlineMath, 'x > 0'),
        ],
      );
    });

    test('block formula', () {
      expect(
        parseMathText(r'$$x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}$$'),
        [
          const MathSegment(
            MathSegmentType.blockMath,
            r'x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}',
          ),
        ],
      );
    });

    test('escaped dollar is not a formula and unescapes to \$', () {
      expect(
        parseMathText(r'Цена \$500 — это не формула'),
        [
          const MathSegment(
            MathSegmentType.text,
            'Цена \$500 — это не формула',
          ),
        ],
      );
    });

    test('unclosed dollar falls back to plain text, does not throw', () {
      const input = r'Незакрытая $\frac{1}{2 — тут доллар без пары';
      expect(
        () => parseMathText(input),
        returnsNormally,
      );
      expect(
        parseMathText(input),
        [const MathSegment(MathSegmentType.text, input)],
      );
    });

    test('empty inline formula is skipped', () {
      expect(
        parseMathText(r'до $ $ после'),
        [const MathSegment(MathSegmentType.text, 'до  после')],
      );
    });

    test('empty block formula is skipped', () {
      expect(
        parseMathText(r'до $$$$ после'),
        [const MathSegment(MathSegmentType.text, 'до  после')],
      );
    });

    test('several formulas in a row', () {
      expect(
        parseMathText(r'$\sum_{i=1}^{n} i^2$ и $\int_0^1 x\,dx$'),
        [
          const MathSegment(MathSegmentType.inlineMath, r'\sum_{i=1}^{n} i^2'),
          const MathSegment(MathSegmentType.text, ' и '),
          const MathSegment(MathSegmentType.inlineMath, r'\int_0^1 x\,dx'),
        ],
      );
    });

    test('block delimiters are checked before inline ones', () {
      expect(
        parseMathText(r'$$a+b$$'),
        [const MathSegment(MathSegmentType.blockMath, 'a+b')],
      );
    });

    test('fast path: string without \$ returns immediately as text', () {
      const input = 'обычный текст без формул';
      expect(
        parseMathText(input),
        [const MathSegment(MathSegmentType.text, input)],
      );
    });
  });
}
