import 'package:dio/dio.dart';
import 'package:smarth_save/services/api.dart';
import 'package:smarth_save/providers/userProvider.dart';

class ApiChatService {
  final _api = API();
  final _userProvider = UserProvider();

  /// Envoie un message au backend SmartBot (RAG + Ollama).
  ///
  /// [message]  : question de l'utilisateur
  /// [history]  : historique de conversation [{'role': 'user'|'assistant', 'content': '...'}]
  ///
  /// Retourne la réponse textuelle du bot.
  Future<String> send({
    required String message,
    List<Map<String, String>> history = const [],
  }) async {
    await _userProvider.loadToken();
    final token = _userProvider.token;

    final dio = Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // Timeout généreux car le modèle peut mettre du temps
    dio.options.receiveTimeout = const Duration(seconds: 180);
    dio.options.connectTimeout = const Duration(seconds: 30);

    final response = await dio.post(
      '${_api.baseURL}/chat',
      data: {
        'message': message,
        'history': history,
      },
    );

    final data = response.data;
    if (response.statusCode == 200) {
      return data['data']['answer']?.toString() ?? '';
    } else {
      throw Exception(data['message'] ?? 'Erreur inconnue');
    }
  }
}
