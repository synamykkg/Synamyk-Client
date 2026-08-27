import 'dart:io';

import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/domain/enums/otp_type.dart';
import 'package:synamyk/domain/models/auth/auth_token.dart';
import 'package:synamyk/domain/models/auth/registration_info.dart';

abstract class AuthRepository {
  /// Sign in with phone and password
  Future<AuthToken> signIn(String phone, String password);

  /// Request SMS for phone confirmation (sign in flow)
  Future<bool> sendSignUpPhoneConfirmationSms(String phone, AppLanguage lang);

  /// Save user information and return session token
  Future<AuthResponse> saveUserInfo(RegistrationInfo info);

  /// Sign up with phone and password, returns session token
  Future<AuthResponse> signUp(String phone, String password);

  /// Refresh session using existing token (implied or passed)
  Future<AuthToken> refreshSession();

  /// Get currently saved session from local storage, if any
  Future<AuthToken?> getSavedSession();

  /// Clear session (logout)
  Future<void> logout();

  /// Reset password: Check if phone exists/is valid for reset
  // Future<bool> checkResetPasswordPhone(String phone);

  /// Send SMS code
  Future<bool> sendOtpSms(String phone, OtpType type, AppLanguage lang);

  /// Resend new OTP code
  Future<bool> resendOtpSms(String phone, OtpType type, AppLanguage lang);

  /// Reset password: Verify SMS code and get a reset token
  Future<OtpVerifyResponse> verifyResetPasswordCode(String phone, String code);

  /// Set new password using the reset token
  Future<void> setNewPassword(
    String resetToken,
    String newPassword,
    String confirmPassword,
  );

  /// Confirm sign up with code, returns session token
  Future<OtpVerifyResponse> confirmSignUp(String code, String phone);

  /// Confirm Reset Password with code, returns session token
  Future<OtpVerifyResponse> confirmResetPassword(String phone, String code);

  /// Change user's phone number
  Future<void> changePhoneNumber(String oldPhone, String newPhone);

  // /// Upload user's avatar
  // Future<void> uploadAvatar(File file);

  /// Pick and save user's avatar
  Future<File?> pickAndSaveAvatar();

  /// policy site 
  Future<void> openPrivacyPolicy();

  /// terms of service
  Future<void> openTermsOfService();
}
