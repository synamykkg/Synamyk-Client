/// Thin domain-side view of a Spring `Page<T>` response, built from the
/// already-typed swagger `PageXxxResponse` wrapper for a given content type.
/// Named `PagedResult` (not `Page`) to avoid colliding with
/// `package:flutter/widgets.dart`'s `Page<T>`.
class PagedResult<T> {
  PagedResult({
    required this.content,
    required this.totalElements,
    required this.number,
    required this.last,
  });

  final List<T> content;
  final int totalElements;
  final int number;
  final bool last;
}
