import 'package:smarth_save/services/api_routes.dart';
import 'package:smarth_save/services/dio_client.dart';

class ApiTransactionService {
  final DioClient _dio = DioClient.instance;

  Future<dynamic> getTransaction() async {
    return _dio.post(transactionGet, data: {'trie': 'desc'});
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
