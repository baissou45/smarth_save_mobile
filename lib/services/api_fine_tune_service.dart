import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smarth_save/services/api.dart';
import 'package:smarth_save/providers/userProvider.dart';

class ApiFineTuneService {
  final API api = API();
  final userProvider = UserProvider();

  Future<String?> getFineTuneSentence() async {
    await userProvider.loadToken();
    final token = await userProvider.token;
    String url = api.baseURL + "/fine_turn_sentence";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // On accepte les deux formats possibles
      if (data is Map && data['data'].containsKey('fine_turne_sentence')) {
        return data['data']['fine_turne_sentence']?.toString();
      } else if (data['data'].containsKey('fine_turn_sentence')) {
        return data['data']['fine_turn_sentence']?.toString();
      }
      return null;
    } else {
      return null;
    }
  }
}
