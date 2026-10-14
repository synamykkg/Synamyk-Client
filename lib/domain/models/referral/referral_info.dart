import 'package:synamyk/domain/models/common/json_read.dart';

class ReferralReward {
  const ReferralReward({
    required this.rewardId,
    required this.friendName,
    required this.earnedAt,
    required this.available,
    required this.redeemedTestTitle,
    required this.redeemedAt,
  });

  final int rewardId;
  final String friendName;
  final DateTime? earnedAt;
  final bool available;
  final String? redeemedTestTitle;
  final DateTime? redeemedAt;

  factory ReferralReward.fromJson(Map<String, dynamic> json) {
    return ReferralReward(
      rewardId: readIntOr(json['rewardId']),
      friendName: readStringOr(json['friendName']),
      earnedAt: readDate(json['earnedAt']),
      available: readBool(json['available']),
      redeemedTestTitle: readString(json['redeemedTestTitle']),
      redeemedAt: readDate(json['redeemedAt']),
    );
  }
}

/// `GET /api/referrals/me` — «Пригласи друга».
class ReferralInfo {
  const ReferralInfo({
    required this.code,
    required this.inviteLink,
    required this.shareText,
    required this.invitedCount,
    required this.purchasedCount,
    required this.availableRewards,
    required this.canApplyCode,
    required this.referredByName,
    required this.rewards,
  });

  final String code;
  final String? inviteLink;
  final String shareText;
  final int invitedCount;
  final int purchasedCount;
  final int availableRewards;
  final bool canApplyCode;
  final String? referredByName;
  final List<ReferralReward> rewards;

  factory ReferralInfo.fromJson(Map<String, dynamic> json) {
    return ReferralInfo(
      code: readStringOr(json['code']),
      inviteLink: readString(json['inviteLink']),
      shareText: readStringOr(json['shareText']),
      invitedCount: readIntOr(json['invitedCount']),
      purchasedCount: readIntOr(json['purchasedCount']),
      availableRewards: readIntOr(json['availableRewards']),
      canApplyCode: readBool(json['canApplyCode']),
      referredByName: readString(json['referredByName']),
      rewards: readMapList(
        json['rewards'],
      ).map(ReferralReward.fromJson).toList(),
    );
  }
}
