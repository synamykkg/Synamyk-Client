import 'package:flutter/widgets.dart';

/// Inline RU/KY strings for the ОРТ screens: the API already returns content
/// in the user's language, and these screens only add short UI labels.
extension TrContext on BuildContext {
  bool get isKy => Localizations.localeOf(this).languageCode == 'ky';

  String tr(String ru, String ky) => isKy ? ky : ru;
}
