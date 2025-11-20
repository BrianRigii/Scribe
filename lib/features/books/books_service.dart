import 'dart:developer';
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

      final selectedFile = files[0];

      // Validate file exists and has content
      if (!await selectedFile.exists()) {
        throw Exception("Selected file does not exist");
      }

      final fileBytes = await selectedFile.readAsBytes();
      if (fileBytes.isEmpty) {
        throw Exception("Selected file is empty");
      }

      log(
        "Uploading file: ${selectedFile.path}, size: ${fileBytes.length} bytes",
      );

      await client.storage.createFile(
        bucketId: Config.booksBucketId,
        fileId: generateUuid(),
        file: InputFile.fromBytes(
          bytes: fileBytes,
          filename: selectedFile.path.split('/').last,
        ),
        onProgress: _setUploadProgress,
      );
      return selectedFile;
    } catch (e) {
      log("Error picking or uploading book file: $e");
      rethrow;
    }
  }
}
