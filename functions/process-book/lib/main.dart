import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

Future<dynamic> main(final context) async {
  context.log('Function execution started');

  final client = Client()
    ..setEndpoint(Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'] ?? '')
    ..setProject(Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ?? '')
    ..setKey(Platform.environment['APPWRITE_FUNCTION_API_KEY']);

  try {
    // Read & parse body
    final data = jsonDecode(context.req.bodyRaw);
    context.log('Request body: $data');

    final fileId = data['fileId'];

    final storage = Storage(client);

    final file = await storage.getFile(
      bucketId: Platform.environment['BOOKS_BUCKET_ID'] ?? '',
      fileId: fileId,
    );

    context.log('Processing file: ${file.name} with ID: ${file.$id}');

    // Return proper RuntimeResponse
    return context.res
      ..statusCode = 200
      ..json({
        'success': true,
        'message': 'Book processing started for file ID: $fileId',
      });
  } catch (e, st) {
    context.error('Error processing book: $e\n$st');

    return context.res
      ..statusCode = 500
      ..json({
        'success': false,
        'error': e.toString(),
      });
  }
}
