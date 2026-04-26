import 'package:smarth_save/services/api_account_service.dart';

class PlaidLinkService {
  static final PlaidLinkService _instance = PlaidLinkService._internal();
  final ApiAccountService _apiService = ApiAccountService();

  factory PlaidLinkService() {
    return _instance;
  }

  PlaidLinkService._internal();

  /// Génère l'URL pour lancer Plaid Link en mode sandbox
  /// À utiliser avec une WebView pour afficher le flow
  String generatePlaidLinkUrl({
    required String clientId,
    required String publicKey,
    required String env, // sandbox, development, production
  }) {
    return 'https://$env.plaid.com/link?clientName=SmartSave&clientId=$clientId&publicKey=$publicKey&env=$env&product=auth,transactions&countryCodes=FR&language=fr&redirect_uri=smartsave://plaid/callback';
  }

  /// Échange le public token après le succès du flow Plaid
  Future<bool> exchangePublicToken(String publicToken) async {
    try {
      await _apiService.exchangePlaidToken(publicToken);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
