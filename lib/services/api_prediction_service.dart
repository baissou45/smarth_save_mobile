import 'package:dio/dio.dart';
import 'package:smarth_save/models/prediction_model.dart';
import 'package:smarth_save/models/transation_model.dart' show TransactionModel;

class ApiPredictionService {
  static const String _baseUrl = 'http://10.0.2.2:8001';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ),
  );

  Future<PredictionModel?> getPrediction(
    List<TransactionModel> transactions,
  ) async {
    final monthly = _aggregateByMonth(transactions);
    if (monthly.length < 3) return null;

    final body = {
      'user_id': 0,
      'months': monthly,
    };

    try {
      final response = await _dio.post('/predict', data: body);
      if (response.statusCode == 200) {
        return PredictionModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> _aggregateByMonth(
    List<TransactionModel> transactions,
  ) {
    final Map<String, Map<String, dynamic>> byMonth = {};

    for (final t in transactions) {
      final date = t.dateEmission;
      if (date == null) continue;
      final key =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';

      byMonth.putIfAbsent(
        key,
        () => {
          'mois_annee': key,
          'total_credit': 0.0,
          'total_debit': 0.0,
          'nb_transactions': 0,
        },
      );

      final amount = double.tryParse(t.montant ?? '0') ?? 0.0;
      if (t.type == 'credit') {
        byMonth[key]!['total_credit'] =
            (byMonth[key]!['total_credit'] as double) + amount;
      } else {
        byMonth[key]!['total_debit'] =
            (byMonth[key]!['total_debit'] as double) + amount;
      }
      byMonth[key]!['nb_transactions'] =
          (byMonth[key]!['nb_transactions'] as int) + 1;
    }

    final sorted = byMonth.keys.toList()..sort();
    return sorted.map((k) => byMonth[k]!).toList();
  }
}
