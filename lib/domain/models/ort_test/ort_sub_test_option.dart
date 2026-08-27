// class OrtSubTestOption {
//   OrtSubTestOption({required this.variant, required this.optionsAnswer, required this.id});

//   final String variant;
//   final String optionsAnswer;
//   final int id;
// }


class OrtSubTestOption {
  OrtSubTestOption({
    required this.id,
    required this.label,
    required this.text,
    required this.orderIndex,
  });

  final int id;
  final String label;
  final String text;
  final int orderIndex;

  factory OrtSubTestOption.fromJson(Map<String, dynamic> json) {
    return OrtSubTestOption(
      id: json['id'] as int,
      label: json['label'] as String,
      text: json['text'] as String,
      orderIndex: json['orderIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'text': text,
      'orderIndex': orderIndex,
    };
  }
}