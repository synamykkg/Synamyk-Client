enum JoinGameStatus { waiting, matched }

class JoinGameResult {
  JoinGameResult({
    required this.status,
    required this.roomId,
    required this.message,
  });

  final JoinGameStatus status;
  final int roomId;
  final String message;

  factory JoinGameResult.fromJson(Map<String, dynamic> json) {
    return JoinGameResult(
      status:
          json['status'] == 'MATCHED'
              ? JoinGameStatus.matched
              : JoinGameStatus.waiting,
      roomId: json['roomId'] as int,
      message: json['message'] as String? ?? '',
    );
  }
}
