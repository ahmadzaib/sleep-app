import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const appName = "avatar_flow";

  // API Keys - Replace with your actual keys
  static String geminiApiKey = dotenv.env["GEMINI_API_KEY"] ?? '';
  static String elevenLabsApiKey = dotenv.env["ELEVENLABS_API_KEY"] ?? '';
  static String pollinationsApiKey = dotenv.env["POLLINATIONS_API_KEY"] ?? '';
  static String removeBgApiKey = dotenv.env["REMOVE_BG_API_KEY"] ?? '';

  // API Endpoints
  static const String geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent';
  static const String elevenLabsEndpoint = 'https://api.elevenlabs.io/v1';

  // Pollinations AI - Free image generation (no key required for basic use)
  // Format: https://image.pollinations.ai/prompt/{encoded_prompt}?params
  static const String pollinationsEndpoint =
      'https://image.pollinations.ai/prompt';

  // remove.bg - Background removal API
  static const String removeBgEndpoint = 'https://api.remove.bg/v1.0/removebg';

  // Supabase Storage
}
