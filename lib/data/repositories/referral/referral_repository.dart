import 'package:synamyk/data/api/dio/synamyk_rest_client.dart';
import 'package:synamyk/domain/models/referral/referral_info.dart';

/// «Пригласи друга»: a friend's first purchase earns a reward that opens any
/// one paid test for free.
abstract class ReferralRepository {
  Future<ReferralInfo> getMyInfo();

  /// Once, and only before the user's first purchase.
  Future<ReferralInfo> applyCode(String code);

  /// Spends one available reward and permanently opens [testId].
  Future<ReferralInfo> redeemReward(int testId);
}

class ReferralRepositoryImpl implements ReferralRepository {
  ReferralRepositoryImpl({required SynamykRestClient client})
    : _client = client;

  final SynamykRestClient _client;

  @override
  Future<ReferralInfo> getMyInfo() async {
    final response = await _client.get('/api/referrals/me');
    return ReferralInfo.fromJson(response.map);
  }

  @override
  Future<ReferralInfo> applyCode(String code) async {
    final response = await _client.post(
      '/api/referrals/apply',
      body: {'code': code.trim()},
    );
    return ReferralInfo.fromJson(response.map);
  }

  @override
  Future<ReferralInfo> redeemReward(int testId) async {
    final response = await _client.post(
      '/api/referrals/rewards/redeem',
      body: {'testId': testId},
    );
    return ReferralInfo.fromJson(response.map);
  }
}
