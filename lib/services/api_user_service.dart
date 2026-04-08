import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/services/dio_client.dart';
import 'api_routes.dart';

class ApiUserService {
  final DioClient _dio = DioClient.instance;

  Future<dynamic> register(UserModel user) async {
    final response = await _dio.post(
      registerRoute,
      data: user.toMap(),
    );
    return response['status'] == 'success';
  }

  Future<dynamic> login(String email, String password) async {
    final response = await _dio.post(
      loginRoute,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  Future<dynamic> modifmotdepasse(String email) async {
    final response = await _dio.post(
      modifmotdepassefRoute,
      data: {
        'email': email,
      },
    );
    return response;
  }

  Future<dynamic> updateProfile({
    required String? nom,
    required String? prenom,
    required String? email,
  }) async {
    final data = <String, dynamic>{};
    if (nom != null) data['nom'] = nom;
    if (prenom != null) data['prenom'] = prenom;
    if (email != null) data['email'] = email;

    final response = await _dio.put(
      updateProfileRoute,
      data: data,
    );
    return response;
  }

  Future<dynamic> changePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.put(
      changePasswordRoute,
      data: {
        'old_password': oldPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response;
  }
}
