import 'package:flutter/material.dart';

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
      children: const [
        LanguageSettingsTile()
      ],
    );
  }
}
