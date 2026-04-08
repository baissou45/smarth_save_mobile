import 'package:smarth_save/services/dio_client.dart';
import 'package:smarth_save/services/api_routes.dart';

class ApiChatService {
  final DioClient _dio = DioClient.instance;

  /// Sends a message to the backend SmartBot (RAG + Ollama).
  ///
  /// [message]  : user question
  /// [history]  : conversation history [{'role': 'user'|'assistant', 'content': '...'}]
  ///
  /// Returns the text response from the bot.
  Future<String> send({
    required String message,
    List<Map<String, String>> history = const [],
  }) async {
    try {
      final response = await _dio.post(
        chatRoute,
        data: {
          'message': message,
          'history': history,
        },
      );

      if (response['status'] == 'success') {
        return response['data']['answer']?.toString() ?? '';
      } else {
        throw Exception(response['message'] ?? 'Unknown error');
      }
    } catch (e) {
      throw Exception('Chat error: $e');
    }
  }
}
