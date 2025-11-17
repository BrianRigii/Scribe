import 'package:hive_ce_flutter/hive_flutter.dart';

class DatabaseService {
  //singleton pattern
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();

  void init() {
    Hive.initFlutter();
    _registerAdapters();
    _openBoxes();
  }

  void _registerAdapters() {
    // Register your Hive adapters here
  }

  void _openBoxes() async {
    // Open your Hive boxes here
  }
}
