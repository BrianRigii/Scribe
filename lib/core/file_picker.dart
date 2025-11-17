import 'dart:io';

import 'package:file_picker/file_picker.dart';

abstract class ScribeFilePicker {
  Future<List<File>> pickFile([bool allowMultiple = false]);
}

class FilePickerImpl extends ScribeFilePicker {
  static final FilePickerImpl _instance = FilePickerImpl._internal();
  factory FilePickerImpl() => _instance;
  FilePickerImpl._internal();
  @override
  Future<List<File>> pickFile([bool allowMultiple = false]) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
    );

    return result?.paths.map((path) => File(path!)).toList() ?? [];
  }
}
