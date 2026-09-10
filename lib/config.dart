class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'OMOWE_API_BASE_URL',
    defaultValue: 'https://omowe-backend.onrender.com',
  );

  static Uri get runBookEndpoint =>
      Uri.parse('$apiBaseUrl/api/upload/run_book');
}
