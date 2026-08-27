import 'package:synamyk/data/repositories/home/fake_data/fake_home.dart';
import 'package:synamyk/data/repositories/home/fake_data/fake_subject_tests.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/domain/models/home/subject_list.dart';
import 'package:synamyk/domain/models/home/subject_model.dart';
import 'package:synamyk/domain/models/home/subject_tests.dart';

class FakeHomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<SubjectList>> getHomeSubjectsList() async {
    final data = fakeHome;

    return data.map((e) {
      return SubjectList(
        id: e["id"],
        title: e["title"],
        subTitle: e["subTitle"],
        image: e["image"],
      );
    }).toList();
  }

  @override
  Future<SubjectModel> getSubjectTests(String subjectId) async {
    final data = fakeSubjectTests;
    for (var element in data) {
      if (element["id"] == subjectId) {
        final List testsJson = element["testsList"] as List;
        final List<SubjectTests> testsList = testsJson
        .map((e) => SubjectTests.fromJson(e as Map<String, dynamic>))
        .toList();
        return SubjectModel(
          id: element["id"],
          title: element["title"],
          tarif: element["tarif"],
          testsList: testsList,
          hasPaidAccess: false
        );
      }
    }

    throw UnimplementedError();
  }

  @override
  Future<SubjectModel> changeTarif(String subjectId) {
    throw UnimplementedError();
  }
}
