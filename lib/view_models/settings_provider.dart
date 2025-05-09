import 'package:flutter/material.dart';
import 'package:money_manager/models/settings.dart';
import 'package:money_manager/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final _storage = StorageService();
  late Settings _settings;

  SettingsProvider() {
    final _settings = _storage.getSettings();
  }

  Locale get locale => Locale(_settings.languageCode);

  Future<void> _saveSettings() async {
    await _storage.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == _settings.languageCode) return;

    _settings.languageCode = locale.languageCode;
    await _saveSettings();
  }

  String get currencyCode => _settings.currencyCode;

  Future<void> setCurrencyCode(String code) async {
    if (code == _settings.currencyCode) return;

    _settings.currencyCode = code;
    await _saveSettings();
  }
}