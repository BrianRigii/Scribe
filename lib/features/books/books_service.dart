import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:scribe/core/appwrite_service.dart';
import 'package:scribe/core/config.dart';
import 'package:scribe/core/uuid.dart';

import '../../core/file_picker.dart';

abstract class BookService extends ChangeNotifier {
  /// Opens file picker to select a book file and uploads it to AppWrite Storage
  Future<File> pickAndUploadBook();
}

class BookServiceImpl extends BookService {
  final AppWriteService client;
  final ScribeFilePicker filePicker;
  BookServiceImpl({required this.client, required this.filePicker});
  @override
  Future<File> pickAndUploadBook() async {
    List<File> files = await filePicker.pickFile();
    if (files.isEmpty) {
      throw Exception("No file selected");
    }
    client.storage.createFile(
      bucketId: Config.booksBucketId,
      fileId: generateUuid(),
      file: InputFile.fromPath(path: files[0].path),
    );
    return files[0];
  }
}
