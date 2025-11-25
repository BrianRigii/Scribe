import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

// This Appwrite function will be executed every time your function is triggered
Future<dynamic> main(final context) async {
  context.log('Function execution started');
  final endpoint = Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'];
  final project = Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'];
  final apiKey = Platform.environment['APPWRITE_API_KEY'];
  final bucketId = Platform.environment['BOOKS_BUCKET_ID'];

  context.log("endpoint=$endpoint");
  context.log("project=$project");
  context.log("apiKeyExists=${apiKey != null}");
  context.log("bucketId=$bucketId");

  final client = Client()
      .setEndpoint(Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'] ?? '')
      .setProject(Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ?? '')
      .setKey(Platform.environment['APPWRITE_FUNCTION_API_KEY']);

  try {
    context.log('Function execution started');
    Map<String, dynamic> body = jsonDecode(context.req.body);
    String fileId = body['fileId'];
    Storage storage = Storage(client);
    final file = await storage.getFile(
      bucketId: Platform.environment['BOOKS_BUCKET_ID'] ?? '',
      fileId: fileId,
    );
    context.log('Processing file: ${file.name} with ID: ${file.$id}');
    // Add your book processing logic here
    context.res = {
      'status': 200,
      'body': 'Book processing started for file ID: $fileId',
    };
  } catch (e) {
    context.error('Error processing book: $e');
  }
}
