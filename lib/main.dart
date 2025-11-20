import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribe/core/appwrite_service.dart';
import 'package:scribe/core/database_service.dart';
import 'package:scribe/core/file_picker.dart';
import 'package:scribe/core/router.dart';
import 'package:scribe/core/theme.dart';
import 'package:scribe/features/auth/services/auth_service.dart';
import 'package:scribe/features/books/books_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  runApp(Scribe());
}

class Scribe extends StatelessWidget {
  const Scribe({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(
            client: AppWriteService.instance,
            database: DatabaseService.instance,
          ),
        ),

        Provider<ScribeFilePicker>(create: (_) => FilePickerImpl()),
        ChangeNotifierProvider<BookService>(
          create: (context) => BookServiceImpl(
            client: AppWriteService.instance,
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
