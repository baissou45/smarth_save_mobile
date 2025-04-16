import 'dart:convert'; // Pour jsonDecode
import 'package:http/http.dart' as http;
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/services/api.dart';

import 'api_routes.dart';

class ApiTransactionService {
  final API api = API();
  final userProvider = UserProvider();

  Future<dynamic> getTransaction() async {
    await userProvider.loadToken();
    final token = await userProvider.token;
    print('le token $token');
    String url = api.baseURL + transactionGet;
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'trie': 'asc',
        'type': 'debit',
        'categorie': 0,
        'date': '2019-08-24T14:15:22Z',
        'filter': 'day',
        'groupe_by': 'categorie',
        'limit': 0,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('les transaction ${response.body}');
  }

  Future<dynamic> findTransaction(int transation) async {
    await userProvider.loadToken();
    final token = await userProvider.token;
    print('le token $token');
    String url = api.baseURL + transactionFind + transation.toString();
    print('le url $url');
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'transaction': 2}),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('les transaction ${response.body}');
  }
}
