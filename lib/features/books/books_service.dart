import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:scribe/core/appwrite_service.dart';
import 'package:scribe/core/config.dart';
import 'package:scribe/core/uuid.dart';

import '../../core/file_picker.dart';

abstract class BookService extends ChangeNotifier {
  /// Opens file picker to select a book file and uploads it to AppWrite Storage
  double get uploadProgress;
  Future<File> pickAndUploadBook();
}

class BookServiceImpl extends BookService {
  final AppWriteService client;
  final ScribeFilePicker filePicker;
  BookServiceImpl({required this.client, required this.filePicker});
  double _uploadProgress = 0;
  @override
  double get uploadProgress => _uploadProgress;

  void _setUploadProgress(UploadProgress progress) {
    _uploadProgress = progress.progress;
    notifyListeners();
  }

  @override
  Future<File> pickAndUploadBook() async {
    try {
      List<File> files = await filePicker.pickFile();
      if (files.isEmpty) {
        throw Exception("No file selected");
      }
      client.storage.createFile(
        bucketId: Config.booksBucketId,
        fileId: generateUuid(),
        file: InputFile.fromPath(path: files[0].path),
        onProgress: _setUploadProgress,
      );
      return files[0];
    } catch (e) {
      rethrow;
    }
  }
}
