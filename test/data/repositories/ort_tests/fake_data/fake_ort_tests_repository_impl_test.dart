import 'package:flutter_test/flutter_test.dart';
import 'package:synamyk/data/repositories/ort_tests/fake_data/fake_ort_test.dart';
import 'package:synamyk/data/repositories/ort_tests/fake_data/fake_ort_tests_repository_impl.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';

void main() {
  group('FakeOrtTestsRepositoryImpl', () {
    late FakeOrtTestsRepositoryImpl repository;

    setUp(() {
      repository = FakeOrtTestsRepositoryImpl();
    });

    test('implements OrtTestsRepository', () {
      expect(repository, isA<OrtTestsRepository>());
    });

    test(
      'getOrtTest returns correct list of OrtTest mapped from fake data',
      () async {
        final result = await repository.getOrtTest('any_id', 'any_language');

        expect(result.length, fakeOrtTest.length);

        for (int i = 0; i < result.length; i++) {
          final expected = fakeOrtTest[i];
          final actual = result[i];

          expect(actual.id, expected['id']);
          expect(actual.question, expected['question']);
          expect(actual.image, expected['image']);
          expect(actual.correctAnswer, expected['correctAnswer']);

          // Verify options
          // Note: fakeOrtTest defines options as a List of Maps.
          final expectedOptions = expected['options'] as List;
          expect(actual.options.length, expectedOptions.length);

          for (int j = 0; j < actual.options.length; j++) {
            final exOpt = expectedOptions[j];
            final acOpt = actual.options[j];
            expect(acOpt.variant, exOpt['variant']);
            expect(acOpt.optionsAnswer, exOpt['optionsAnswer']);
          }
        }
      },
    );
  });
}
