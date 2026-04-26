import 'package:smarth_save/models/categorie.dart';
import 'package:smarth_save/services/api_routes.dart';
import 'package:smarth_save/services/dio_client.dart';

class ApiCategorieService {
  final DioClient _dio = DioClient.instance;

  List<Categorie> _parseCategories(dynamic response) {
    List<Categorie> categories = [];
    for (var item in response['data']) {
      categories.add(Categorie.fromJson(item));
    }
    return categories;
  }

  Future<dynamic> getAllCategories() async {
    final response = await _dio.get(categoriesRoute);
    return _parseCategories(response);
  }

  Future<dynamic> getMyCategories() async {
    final response = await _dio.get(categoriesGetMine);
    return _parseCategories(response);
  }

  Future<dynamic> addCategoryToUser(int categorieId, double plafond) async {
    final response = await _dio.post(
      '$categoriesGetMine/$categorieId',
      data: {'plafond': plafond},
    );
    return response['data'];
  }

  Future<dynamic> updatePlafond(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('$categoriesGetMine/$id', data: data);
    return _parseCategories(response);
  }

  Future<dynamic> deleteCategory(int id) async {
    final response = await _dio.delete('$categoriesGetMine/$id');
    return _parseCategories(response);
  }

  Future<List<Categorie>> getBudgetDashboard() async {
    final response = await _dio.get('/budget_dashboard');
    return _parseCategories(response);
  }
}
