/// What a push notification / inbox entry deep-links to.
enum PushDataType {
  none,
  test,
  subTest,
  game,
  broadcast,
  unknown;

  static PushDataType fromJson(String? value) => switch (value) {
    'NONE' => none,
    'TEST' => test,
    'SUB_TEST' => subTest,
    'GAME' => game,
    'BROADCAST' => broadcast,
    _ => unknown,
  };
}
