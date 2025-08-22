import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smarth_save/services/api_fine_tune_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenIABot {
  final String apiKey;
  final ApiFineTuneService _fineTuneService = ApiFineTuneService();

  OpenIABot() : apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  /// Envoie toute la liste de messages à l'API OpenAI (contexte complet)
  Future<String> sendMessageWithHistory(
      List<Map<String, String>> history) async {
    if (apiKey.isEmpty) {
      throw Exception('Clé API OpenAI manquante. Vérifie ton fichier .env.');
    }

    // Récupère la phrase fine-tune
    // final fineTuneSentence = await _fineTuneService.getFineTuneSentence();

    // Construit la liste des messages à envoyer à OpenAI
    // final List<Map<String, String>> messages = [
    //   if (fineTuneSentence != null && fineTuneSentence.isNotEmpty)
    //     {"role": "system", "content": fineTuneSentence},
    //   ...history
    // ];

    const endpoint = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "model": 'gpt-4.1-nano-2025-04-14',
      "messages": history,
    });

    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return utf8.decode(content.trim().codeUnits);
    } else {
      throw Exception('Erreur OpenAI: [31m${response.body}[0m');
    }
  }

  /// Raccourci pour envoyer un seul message utilisateur (non utilisé dans l'UI)
  Future<String> sendMessage(String message) async {
    return sendMessageWithHistory([
      {'role': 'user', 'content': message}
    ]);
  }
}
