import 'package:synamyk/domain/models/home/subject_tests.dart';

class SubjectModel {
  SubjectModel({
    required this.id,
    required this.title,
    required this.tarif,
    required this.testsList,
    required this.hasPaidAccess,
  });

  final String id;
  final String title;
  final String tarif;
  final List<SubjectTests> testsList;
  final bool hasPaidAccess;
}
