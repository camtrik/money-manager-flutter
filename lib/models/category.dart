import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon;

  @HiveField(3)
  int colorValue;

  Category({
    String? id, 
    required this.name, 
    required this.icon, 
    int? colorValue
  })
    : id = id ?? const Uuid().v4(),
      colorValue = colorValue ?? Colors.blue.toARGB32();

}
