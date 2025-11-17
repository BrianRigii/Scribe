import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribe/core/appwrite_service.dart';
import 'package:scribe/core/file_picker.dart';
import 'package:scribe/core/router.dart';
import 'package:scribe/core/theme.dart';
import 'package:scribe/features/auth/services/auth_service.dart';
import 'package:scribe/features/books/books_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final appWrite = AppWriteService();

  runApp(Scribe(appWriteService: appWrite));
}

class Scribe extends StatelessWidget {
  final AppWriteService appWriteService;
  const Scribe({super.key, required this.appWriteService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppWriteService>.value(value: appWriteService),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(client: appWriteService),
        ),
        Provider<ScribeFilePicker>(create: (_) => FilePickerImpl()),
        ChangeNotifierProvider<BookService>(
          create: (context) => BookServiceImpl(
            client: appWriteService,
            filePicker: Provider.of<ScribeFilePicker>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Scribe',
        routerConfig: AppRouter.routes,
        theme: ScribeTheme.light,
      ),
    );
  }
}
