enum AttemptStatus {
  inProgress,
  paused,
  completed,
  abandoned,
  expired,
  unknown;

  static AttemptStatus fromJson(String? value) => switch (value) {
    'IN_PROGRESS' => inProgress,
    'PAUSED' => paused,
    'COMPLETED' => completed,
    'ABANDONED' => abandoned,
    'EXPIRED' => expired,
    _ => unknown,
  };
}
