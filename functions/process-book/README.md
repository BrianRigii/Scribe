# Process Book Function

Appwrite Cloud Function that listens to storage events and sends uploaded books to an external API for processing.

## Setup

1. **Install Appwrite CLI** (if not already installed):
```bash
npm install -g appwrite-cli
```

2. **Login to Appwrite**:
```bash
appwrite login
```

3. **Initialize your project** (if not done):
```bash
appwrite init project
```

4. **Deploy the function**:
```bash
appwrite deploy function
```

## Configuration

### Environment Variables

Set these variables in your Appwrite Console → Functions → process-book → Settings:

- `PROCESSING_API_URL` (required): The URL of your processing API endpoint
- `APPWRITE_API_KEY` (auto-set): API key for accessing Appwrite services

### Event Trigger

Configure the function to trigger on storage events:
- Event: `buckets.*.files.*.create`
- Or specifically for your books bucket: `buckets.[YOUR_BUCKET_ID].files.*.create`

## How It Works

1. When a file is uploaded to your storage bucket, Appwrite triggers this function
2. The function extracts file metadata (ID, name, size, type)
3. It prepares a payload with file information
4. Sends the payload to your configured processing API
5. Returns success/error response

## Customization

Update the HTTP call section in `lib/main.dart` to match your processing API requirements:

```dart
final httpClient = HttpClient();
final request = await httpClient.postUrl(Uri.parse(processingApiUrl));
request.headers.set('Content-Type', 'application/json');
request.headers.set('Authorization', 'Bearer YOUR_API_TOKEN');
request.write(jsonEncode(payload));
final response = await request.close();
```

## Testing

Test the function manually:
```bash
appwrite functions createExecution \
  --functionId=[YOUR_FUNCTION_ID] \
  --data='{"$id":"test-file-id","name":"test.pdf","sizeOriginal":1024,"mimeType":"application/pdf"}'
```

## Logs

View function logs:
```bash
appwrite functions listExecutions --functionId=[YOUR_FUNCTION_ID]
```
