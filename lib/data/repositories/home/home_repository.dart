import 'package:synamyk/domain/models/home/subject_list.dart';
import 'package:synamyk/domain/models/home/subject_model.dart';
import 'package:synamyk/domain/models/news/news_details.dart';

abstract class HomeRepository {
  Future<List<SubjectList>> getHomeSubjectsList();

  Future<SubjectModel> getSubjectTests(String subjectId);

  Future<SubjectModel> changeTarif(String subjectId);

  
}
