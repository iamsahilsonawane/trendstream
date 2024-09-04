import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/shared_providers/locale_provider.dart';

class LanguageSettingsTile extends ConsumerStatefulWidget {
  const LanguageSettingsTile({
    super.key,
    required this.tileTitle,
    this.languagePrefKey = SharedPreferencesService.language,
  });

  final String tileTitle;
  final String languagePrefKey;

  @override
  ConsumerState<LanguageSettingsTile> createState() =>
      _LanguageSettingsTileState();
}

class _LanguageSettingsTileState extends ConsumerState<LanguageSettingsTile> {
  late String _selectedLanguage = ref.read(localeProvider).languageCode;
  final List<String> _languages = ['en', 'es'];

  void _updateLanguagePreference(String language) async {
    final prefs = ref.read(sharedPreferencesServiceProvider).sharedPreferences;

    await prefs.setString(widget.languagePrefKey, language);
    setState(() => _selectedLanguage = language);
    ref.invalidate(localeProvider); //update the provider
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.tileTitle),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        items: _languages.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue == null) return;
          _updateLanguagePreference(newValue);
        },
      ),
    );
  }
}
