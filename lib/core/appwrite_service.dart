import 'package:appwrite/appwrite.dart';
import 'package:scribe/core/config.dart';

class AppWriteService {
  static final AppWriteService instance = AppWriteService._internal();
  factory AppWriteService() => instance;

  late final Account account;
  late final Databases databases;
  late final Client client;
  late final Storage storage;

  AppWriteService._internal() {
    client = Client()
        .setEndpoint(Config.appwriteUrl) // Your Appwrite Endpoint
        .setProject(Config.appwriteProjectId); // Your project ID

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
  }
}
