class Config {
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
  static const String appwriteUrl = String.fromEnvironment('APPWRITE_URL');
  static const String appwriteProjectId = String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
  );
  static const String oneSignalKey = String.fromEnvironment('ONE_SIGNAL_KEY');

  // Add other configuration constants here as needed

  static const String booksBucketId = String.fromEnvironment('BOOKS_BUCKET_ID');
}
