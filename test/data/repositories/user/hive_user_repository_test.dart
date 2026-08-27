import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:synamyk/data/repositories/user/hive_user_repository_impl.dart';
import 'package:synamyk/domain/models/user/user_model.dart';

void main() {
  group('HiveUserRepositoryImpl', () {
    late HiveUserRepositoryImpl repository;

    setUp(() async {
      Hive.init('./test/hive_testing_path');
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
      }
      repository = HiveUserRepositoryImpl();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('should save and get user', () async {
      final user = UserModel(
        firstName: 'John',
        lastName: 'Doe',
        region: 'US',
        description: 'Test user',
        avatarPath: 'path/to/avatar',
      );

      await repository.saveUser(user);

      final retrievedUser = await repository.getUser();

      expect(retrievedUser, isNotNull);
      expect(retrievedUser!.firstName, user.firstName);
      expect(retrievedUser.lastName, user.lastName);
    });

    test('should delete user', () async {
      final user = UserModel(
        firstName: 'Jane',
        lastName: 'Doe',
        region: 'UK',
        description: 'Another test user',
        
      );

      await repository.saveUser(user);
      await repository.deleteUser();

      final retrievedUser = await repository.getUser();

      expect(retrievedUser, isNull);
    });

    test('should save user avatar', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Mock path_provider channel
      const channel = MethodChannel('plugins.flutter.io/path_provider');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            return './test/tmp';
          });

      // Create mock directory
      await Directory('./test/tmp').create(recursive: true);

      // Create a dummy file
      final file = File('./test/test_avatar.png');
      await file.create(recursive: true);

      final savedPath = await repository.saveUserAvatar(file.path);

      expect(savedPath, contains('test_avatar.png'));
      expect(File(savedPath).existsSync(), true);

      // Cleanup
      if (await file.exists()) await file.delete();
      final savedFile = File(savedPath);
      if (await savedFile.exists()) await savedFile.delete();
    });
  });
}
