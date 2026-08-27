enum PaymentStatus {
  pending,
  completed,
  expired,
  cancelled,
  unknown;

  static PaymentStatus fromJson(String? value) => switch (value) {
    'PENDING' => pending,
    'COMPLETED' => completed,
    'EXPIRED' => expired,
    'CANCELLED' => cancelled,
    _ => unknown,
  };
}
