import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const appName = "avatar_flow";

  // API Keys - Replace with your actual keys
  static String geminiApiKey = dotenv.env["GEMINI_API_KEY"] ?? '';
  static String elevenLabsApiKey = dotenv.env["ELEVENLABS_API_KEY"] ?? '';

  // API Endpoints
  static const String geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent';
  static const String elevenLabsEndpoint = 'https://api.elevenlabs.io/v1';
}
