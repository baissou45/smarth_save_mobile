import 'package:smarth_save/models/account_model.dart';
import 'package:smarth_save/services/dio_client.dart';

class ApiAccountService {
  final DioClient _dio = DioClient.instance;

  /// Récupère les comptes groupés par banque
  Future<PatrimoineResponse> getAccountsGroupedByBank() async {
    final response = await _dio.get('/accounts/grouped');
    return PatrimoineResponse.fromJson(response);
  }

  /// Récupère uniquement le patrimoine total
  Future<double> getPatrimoine() async {
    final response = await _dio.get('/accounts/patrimoine');
    return (response['patrimoine'] as num).toDouble();
  }

  /// Échange le public token Plaid contre un accès à la banque
  Future<dynamic> exchangePlaidToken(String publicToken) async {
    final response = await _dio.post(
      '/plaid/exchange-token',
      data: {'public_token': publicToken},
    );
    return response;
  }

  /// Force la resynchronisation de tous les comptes Plaid
  Future<dynamic> resyncAccounts() async {
    final response = await _dio.post('/plaid/resync', data: {});
    return response;
  }
}
