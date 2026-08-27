// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:get_it/get_it.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
// import 'package:synamyk/data/repositories/auth/auth_repository.dart';
// import 'package:synamyk/data/repositories/user/user_repository.dart';
// import 'package:synamyk/data/services/image_storage.dart';
// import 'package:synamyk/data/services/app_token_storage.dart';
// import 'package:synamyk/domain/enums/region.dart';
// import 'package:synamyk/domain/models/auth/auth_token.dart';
// import 'package:synamyk/domain/models/auth/registration_info.dart';
// import 'package:synamyk/domain/models/user/user_model.dart';
// import 'package:synamyk/utils/image_picker_util.dart';

// class FakeAuthRepositoryImpl implements AuthRepository {
//   final AppTokenStorage _tokenStorage;
//   final UserRepository _userRepository;
//   final ImageStorage _imagePicker;

//   FakeAuthRepositoryImpl({
//     AppTokenStorage? tokenStorage,
//     UserRepository? userRepository,
//     ImageStorage? imageStorage,
//   }) : _tokenStorage = tokenStorage ?? AppTokenStorage(),
//        _userRepository = userRepository ?? GetIt.I<UserRepository>(),
//        _imagePicker = imageStorage ?? ImageStorage();

//   // Mock state for password reset
//   String? _resetPhone;
//   String? _resetCode;
//   String? _resetToken;

//   @override
//   Future<AuthToken> signIn(String phone, String password) async {
//     // ... existing signIn ...
//     await Future.delayed(const Duration(seconds: 1));
//     final user = UserModel(
//       firstName: 'Джо',
//       lastName: 'Джонсон',
//       region: 'Талас',
//       description: "",
//       avatarPath: "",
//     );
//     await _userRepository.saveUser(user);

//     final token = AuthToken(
//       accessToken: "fake_access_token_signin",
//       refreshToken: "fake_refresh_token_signin",
//     );
//     await _tokenStorage.saveToken(token);
//     return token;
//   }

//   @override
//   Future<bool> sendSignUpPhoneConfirmationSms(String phone, String lang) async {
//     await Future.delayed(const Duration(seconds: 1));
//     return true; // Simulate SMS sent
//   }

//   // ... (sendSignInPhoneConfirmationSms is unchanged)

//   @override
//   Future<AuthResponse> saveUserInfo(RegistrationInfo info) async {
//     await Future.delayed(const Duration(seconds: 1));

//     // Save user to repository
//     final user = UserModel(
//       firstName: info.firstName,
//       lastName: info.lastName,
//       region: RegionEnum.talas.label,
//       description: "",
//       avatarPath: "",
//     );
//     await _userRepository.saveUser(user);

//     // Create and save token
//     final token = AuthToken(
//       accessToken: "fake_access_token_signup_complete",
//       refreshToken: "fake_refresh_token_signup_complete",
//     );
//     await _tokenStorage.saveToken(token);

//     return AuthResponse();
//   }

//   @override
//   Future<AuthResponse> signUp(String phone, String password) async {
//     await Future.delayed(const Duration(seconds: 2));
//     final token = AuthToken(
//       accessToken: "fake_access_token_signup",
//       refreshToken: "fake_refresh_token_signup",
//     );
//     await _tokenStorage.saveToken(token);
//     return AuthResponse();
//   }

//   @override
//   Future<AuthToken> refreshSession() async {
//     await Future.delayed(const Duration(seconds: 1));
//     // Simulate refresh using stored token
//     final currentToken = await _tokenStorage.getToken();
//     if (currentToken != null) {
//       final newToken = AuthToken(
//         accessToken: "refreshed_${currentToken.accessToken}",
//         refreshToken: "refreshed_${currentToken.refreshToken}",
//       );
//       await _tokenStorage.saveToken(newToken);
//       return newToken;
//     }
//     throw Exception("No session to refresh");
//   }

//   @override
//   Future<AuthToken?> getSavedSession() async {
//     return await _tokenStorage.getToken();
//   }

//   @override
//   Future<void> logout() async {
//     await _tokenStorage.clearToken();
//   }

//   @override
//   Future<bool> checkResetPasswordPhone(String phone) async {
//     await Future.delayed(const Duration(seconds: 1));
//     // In a real app, check if user exists.
//     // For mock, just return true if phone is not empty.
//     return phone.isNotEmpty;
//   }

//   @override
//   Future<bool> sendResetPasswordSms(String phone) async {
//     await Future.delayed(const Duration(seconds: 1));
//     _resetPhone = phone;
//     _resetCode = "1234"; // Fixed code for testing
//     debugPrint("Reset code for $phone is $_resetCode");
//     return true;
//   }

//   @override
//   Future<String> verifyResetPasswordCode(String phone, String code) async {
//     await Future.delayed(const Duration(seconds: 1));
//     if (_resetPhone == phone && _resetCode == code) {
//       _resetToken = "mock_reset_token_${DateTime.now().millisecondsSinceEpoch}";
//       return _resetToken!;
//     }
//     throw Exception("Invalid code or phone number mismatch");
//   }

//   @override
//   Future<void> setNewPassword(
//     String resetToken,
//     String newPassword,
//     String confirmPassword,
//   ) async {
//     await Future.delayed(const Duration(seconds: 1));
//     if (_resetToken == resetToken) {
//       if (newPassword != confirmPassword) {
//         throw Exception("Passwords do not match");
//       }
//       debugPrint("Password updated successfully to $newPassword");
//       // Clear reset state
//       _resetPhone = null;
//       _resetCode = null;
//       _resetToken = null;
//       return;
//     }
//     throw Exception("Invalid reset token");
//   }

//   @override
//   Future<OtpVerifyResponse> confirmSignUp(String code, String phone) async {
//     await Future.delayed(const Duration(seconds: 1));
//     if (code == "1111") {
//       final token = AuthToken(
//         accessToken: "fake_access_token_signup_confirmed",
//         refreshToken: "fake_refresh_token_signup_confirmed",
//       );
//       await _tokenStorage.saveToken(token);
//       // return token;
//       return OtpVerifyResponse();
//     }
//     throw Exception("Invalid code");
//   }

//   @override
//   Future<void> changePhoneNumber(String oldPhone, String newPhone) async {
//     await Future.delayed(const Duration(seconds: 1));
//     debugPrint("Phone number changed from $oldPhone to $newPhone");
//     // In a real implementation, this would update the phone number in the backend
//     // For fake implementation, we just simulate success
//   }

//   @override
//   Future<File?> pickAndSaveAvatar() async {
//     final picked = await ImagePickerUtil.pick();
//     if (picked == null) return null;

//     return _imagePicker.saveAvatar(picked);
//   }
// }
