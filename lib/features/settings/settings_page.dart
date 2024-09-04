import 'package:flutter/material.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';

import 'package:latest_movies/features/settings/widgets/language_settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LanguageSettingsTile(tileTitle: context.localisations.language),
        verticalSpaceRegular,
        LanguageSettingsTile(
          tileTitle: context.localisations.audioSubtitleLanguage,
          languagePrefKey: SharedPreferencesService.mediaLanguage,
        ),
      ],
    );
  }
}
