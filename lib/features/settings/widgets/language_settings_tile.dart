import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/shared_providers/locale_provider.dart';
import 'package:latest_movies/core/utilities/app_utility.dart';

class LanguageSettingsTile extends ConsumerStatefulWidget {
  const LanguageSettingsTile({super.key});

  @override
  ConsumerState<LanguageSettingsTile> createState() =>
      _LanguageSettingsTileState();
}

class _LanguageSettingsTileState extends ConsumerState<LanguageSettingsTile> {
  late String _selectedLanguage = ref.watch(localeProvider).languageCode;
  final List<String> _languages = ['en', 'es'];

  @override
  void initState() {
    super.initState();
    // _loadLanguagePreference();
  }

  void _loadLanguagePreference() async {
    final prefs = ref.read(sharedPreferencesServiceProvider).sharedPreferences;

    setState(() {
      _selectedLanguage =
          (prefs.getString(SharedPreferencesService.language) ?? 'en');
    });
  }

  void _updateLanguagePreference(String language) async {
    final prefs = ref.read(sharedPreferencesServiceProvider).sharedPreferences;

    await prefs.setString(SharedPreferencesService.language, language);
    setState(() {
      _selectedLanguage = language;
    });
    ref.invalidate(localeProvider); //update the provider
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Language'),
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
