class AppConfig {
  static const appName = "avatar_flow";

  // API Keys - Replace with your actual keys
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String elevenLabsApiKey = 'YOUR_ELEVENLABS_API_KEY';

  // API Endpoints
  static const String geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent';
  static const String elevenLabsEndpoint = 'https://api.elevenlabs.io/v1';
}
