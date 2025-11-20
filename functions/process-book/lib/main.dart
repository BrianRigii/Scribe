import 'dart:async';
import 'dart:convert';
import 'package:dart_appwrite/dart_appwrite.dart';

/// This function is triggered when a file is uploaded to storage
/// It retrieves the file metadata and sends it to an external API for processing
Future<dynamic> main(final context) async {
  try {
    // Get environment variables
    final endpoint = context.req.variables['APPWRITE_FUNCTION_API_ENDPOINT'] ??
        context.req.variables['APPWRITE_FUNCTION_ENDPOINT'];
    final projectId =
        context.req.variables['APPWRITE_FUNCTION_PROJECT_ID'] ?? '';
    final apiKey = context.req.variables['APPWRITE_API_KEY'] ?? '';
    final processingApiUrl = context.req.variables['PROCESSING_API_URL'] ?? '';

    // Validate required variables
    if (processingApiUrl.isEmpty) {
      return context.res.json({
        'success': false,
        'error': 'PROCESSING_API_URL environment variable not set',
      }, statusCode: 500);
    }

    // Parse the incoming event data
    final eventData = context.req.bodyJson;
    context.log('Event received: ${jsonEncode(eventData)}');

    // Extract file information from the event
    final String? bucketId = eventData['\$id'];
    final String? fileId = eventData['\$id'];
    final String? fileName = eventData['name'];
    final int? fileSize = eventData['sizeOriginal'];
    final String? mimeType = eventData['mimeType'];

    if (bucketId == null || fileId == null) {
      return context.res.json({
        'success': false,
        'error': 'Missing bucketId or fileId in event data',
      }, statusCode: 400);
    }

    context.log('Processing file: $fileName ($fileId) from bucket: $bucketId');

    // Initialize Appwrite client to get file details if needed
    final client =
        Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);

    final storage = Storage(client);

    // Get file download URL (requires proper permissions)
    // You can also get file view URL or download the file content
    final fileUrl =
        '$endpoint/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';

    // Prepare payload to send to processing API
    final payload = {
      'fileId': fileId,
      'bucketId': bucketId,
      'fileName': fileName,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'fileUrl': fileUrl,
      'timestamp': DateTime.now().toIso8601String(),
    };

    context.log('Sending to processing API: $processingApiUrl');

    // Call the external processing API
    // TODO: Replace with actual HTTP client call when you define the API
    // Example using dart:io HttpClient:
    /*
    final httpClient = HttpClient();
    final request = await httpClient.postUrl(Uri.parse(processingApiUrl));
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonEncode(payload));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    httpClient.close();
    
    context.log('Processing API response: $responseBody');
    */

    return context.res.json({
      'success': true,
      'message': 'Book processing initiated',
      'fileId': fileId,
      'fileName': fileName,
      'payload': payload,
      'note':
          'Update the HTTP call section with your actual processing API endpoint',
    });
  } catch (e, stackTrace) {
    context.error('Error processing book: $e');
    context.error('Stack trace: $stackTrace');

    return context.res.json({
      'success': false,
      'error': e.toString(),
    }, statusCode: 500);
  }
}
