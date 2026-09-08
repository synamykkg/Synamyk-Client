import 'package:equatable/equatable.dart';

enum MathSegmentType { text, inlineMath, blockMath }

class MathSegment extends Equatable {
  final MathSegmentType type;
  final String content;

  const MathSegment(this.type, this.content);

  @override
  List<Object?> get props => [type, content];

  @override
  String toString() => 'MathSegment($type, $content)';
}

const int _maxParseCacheSize = 200;
final Map<String, List<MathSegment>> _parseCache = {};

/// Splits [input] into plain-text and LaTeX segments.
///
/// `$$...$$` is parsed as a block formula, `$...$` as an inline formula
/// (block delimiters are checked first so `$$` isn't read as two empty
/// inline formulas). `\$` is an escaped literal dollar sign. A `$` with no
/// matching closing delimiter is not an error — it and the rest of the
/// string are treated as plain text. Empty formulas (`$$`, `$ $`) are
/// dropped rather than rendered.
List<MathSegment> parseMathText(String input) {
  if (!input.contains(r'$')) {
    return [MathSegment(MathSegmentType.text, input)];
  }

  final cached = _parseCache[input];
  if (cached != null) return cached;

  final segments = <MathSegment>[];
  final buffer = StringBuffer();
  final len = input.length;
  var i = 0;

  void flushText() {
    if (buffer.isNotEmpty) {
      segments.add(MathSegment(MathSegmentType.text, buffer.toString()));
      buffer.clear();
    }
  }

  while (i < len) {
    final ch = input[i];

    if (ch == r'\' && i + 1 < len && input[i + 1] == r'$') {
      buffer.write(r'$');
      i += 2;
      continue;
    }

    if (ch == r'$') {
      if (i + 1 < len && input[i + 1] == r'$') {
        final closeIdx = input.indexOf(r'$$', i + 2);
        if (closeIdx != -1) {
          final content = input.substring(i + 2, closeIdx);
          if (content.trim().isNotEmpty) {
            flushText();
            segments.add(MathSegment(MathSegmentType.blockMath, content));
          }
          i = closeIdx + 2;
          continue;
        }
      }

      final closeIdx = input.indexOf(r'$', i + 1);
      if (closeIdx != -1) {
        final content = input.substring(i + 1, closeIdx);
        if (content.trim().isNotEmpty) {
          flushText();
          segments.add(MathSegment(MathSegmentType.inlineMath, content));
        }
        i = closeIdx + 1;
        continue;
      }

      // No closing delimiter anywhere in the rest of the string: this `$`
      // can't be a formula, so it's just a literal character.
      buffer.write(r'$');
      i += 1;
      continue;
    }

    buffer.write(ch);
    i += 1;
  }

  flushText();

  if (_parseCache.length >= _maxParseCacheSize) {
    _parseCache.remove(_parseCache.keys.first);
  }
  _parseCache[input] = segments;

  return segments;
}
