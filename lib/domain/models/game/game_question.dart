import 'package:synamyk/domain/models/figure/figure.dart';

class GameOption {
  GameOption({required this.id, required this.text});

  final int id;
  final String text;

  factory GameOption.fromJson(Map<String, dynamic> json) {
    return GameOption(id: json['id'] as int, text: json['text'] as String? ?? '');
  }
}

class GameQuestion {
  GameQuestion({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.options,
    this.figure,
  });

  final int id;
  final String text;
  final String? imageUrl;
  final List<GameOption> options;

  /// Drawing (coordinate plane / geometry); `null` if none.
  final Figure? figure;

  factory GameQuestion.fromJson(Map<String, dynamic> json) {
    return GameQuestion(
      id: json['id'] as int,
      text: json['text'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      options:
          ((json['options'] as List?) ?? [])
              .map((e) => GameOption.fromJson(e as Map<String, dynamic>))
              .toList(),
      figure: Figure.tryParse(json['figure']),
    );
  }
}
