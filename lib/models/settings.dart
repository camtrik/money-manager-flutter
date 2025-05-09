
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 2)
class Settings {
  @HiveField(0)
  String languageCode;

  @HiveField(1)
  String currencyCode;

  Settings({
    this.languageCode = 'en',
    this.currencyCode = 'CNY',
  });
}