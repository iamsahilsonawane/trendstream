import 'package:flutter/widgets.dart';
import 'package:latest_movies/l10n/app_localisations.dart';

extension ContextUtils on BuildContext {
  AppLocalizations get localisations => AppLocalizations.of(this)!;
}
