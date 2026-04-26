import 'package:smarth_save/models/transation_model.dart';
import 'package:smarth_save/services/api_routes.dart';
import 'package:smarth_save/services/dio_client.dart';

class ApiTransactionService {
  final DioClient _dio = DioClient.instance;

  Future<List<TransactionModel>> getTransaction() async {
    final response = await _dio.post(transactionGet, data: {'trie': 'desc'});

    List<TransactionModel> data = List<TransactionModel>.from(
      (response['data'] as List).map((e) => TransactionModel.fromJson(e))
    );
    
    return data;
  }

  Future<dynamic> getTransactionByDate(String filter) async {
    return _dio.post(
      transactionGet,
      data: {
        'trie': 'desc',
        'filter': filter,
      },
    );
  }

  Future<dynamic> findTransaction(int transactionId) async {
    return _dio.post(
      '$transactionFind$transactionId',
      data: {'transaction': transactionId},
    );
  }
}
