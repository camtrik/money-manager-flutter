import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/view_models/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();    
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language), 
            title: Text(l10n.language), 
            subtitle: Text(_getLanguageName(settingsProvider.locale.languageCode, l10n)),
            onTap:() => _showLanguageDialog(context, settingsProvider, l10n),
          ),

          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.attach_money), 
            title: Text(l10n.currency), 
            subtitle: Text("Chinese yuan (TODO: implement other currency )"),
          )
        ],
      )
    );
  }

  String _getLanguageName(String languageCode, AppLocalizations l10n) {
    switch (languageCode) {
      case 'en': return l10n.english;
      case 'zh': return l10n.chinese;
      case 'jp': return l10n.japanese;
      default: return l10n.english;
    }
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settingsProvider, AppLocalizations l10n) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, settingsProvider, "English", "en"), 
            _buildLanguageOption(context, settingsProvider, "中文", "zh"), 
            _buildLanguageOption(context, settingsProvider, "日本語", "jp")
          ],
        )
      );
    });
  }

  Widget _buildLanguageOption(
    BuildContext context, 
    SettingsProvider settingsProvider, 
    String languageName, 
    String languageCode, 
  ) {
    final isSelected = settingsProvider.locale.languageCode == languageCode; 

    return ListTile(
      title: Text(languageName), 
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () {
        settingsProvider.setLocale(Locale(languageCode));
        Navigator.of(context).pop();
      },
    );
  }
}
