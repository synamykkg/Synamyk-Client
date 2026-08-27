class SubjectList {
  SubjectList({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.image,
    this.price,
    this.subTestCount = 0,
    this.completedSubTestCount = 0,
    this.progressPercent = 0,
  });

  final String id;
  final String title;
  final String subTitle;
  final String image;
  final double? price;
  final int subTestCount;
  final int completedSubTestCount;
  final int progressPercent;
}
