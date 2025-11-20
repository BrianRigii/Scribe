import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:scribe/features/auth/models/user.dart';
import 'package:scribe/hive/hive_adapters.dart';

class DatabaseService {
  static final instance = DatabaseService._internal();
  DatabaseService._internal();

  late Box<User> userBox;

  Future<void> init() async {
    await Hive.initFlutter();
    // Register Hive adapters before opening boxes.
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    userBox = await Hive.openBox<User>('userBox');
  }
}
