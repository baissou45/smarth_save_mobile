import 'package:dio/dio.dart';
import 'package:smarth_save/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  static Function(String)? _onUnauthorized;

  late Dio _dio;

  factory DioClient() {
    return _instance;
  }

  static DioClient get instance => _instance;

  DioClient._internal() {
    _initializeDio();
  }

  /// Register the 401 handler callback (typically from GoRouter)
  static void setUnauthorizedHandler(Function(String) handler) {
    _onUnauthorized = handler;
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: API().baseURL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        validateStatus: (status) => true, // Handle all status codes
      ),
    );

    // Request Interceptor — inject auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            options.headers['Content-Type'] = 'application/json';
            options.headers['Accept'] = 'application/json';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Check response status for 401
          if (response.statusCode == 401) {
            _handleUnauthorized('Votre session a expiré. Veuillez vous reconnecter.');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          // Handle 401 — auto logout
          if (error.response?.statusCode == 401) {
            _handleUnauthorized('Authentification échouée. Veuillez vous reconnecter.');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    try {
      final prefs = await _getSharedPreferences();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  Future<void> _handleUnauthorized(String message) async {
    // Clear token
    await _clearToken();

    // Trigger the registered callback if available
    if (_onUnauthorized != null) {
      _onUnauthorized!(message);
    }
  }

  Future<void> _clearToken() async {
    try {
      final prefs = await _getSharedPreferences();
      await prefs.remove('auth_token');
      await prefs.remove('user');

      prefs.getKeys().forEach((key) {
        print(key);
      });
    } catch (e) {
      // Silent fail
    }
  }

  void checkResponse(Response response) {
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Request failed with status: ${response.statusCode}');
    } 
  }

  // GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      checkResponse(response);
      return response.data;
    } catch (e) {
      throw _handleError(e as DioException);
    }
  }

  // POST request
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      checkResponse(response);
      return response.data;
    } catch (e) {
      throw _handleError(e as DioException);
    }
  }

  // PUT request
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      checkResponse(response);
      return response.data;
    } catch (e) {
      throw _handleError(e as DioException);
    }
  }

  // DELETE request
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      checkResponse(response);
      return response.data;
    } catch (e) {
      throw _handleError(e as DioException);
    }
  }

  Exception _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return Exception('Connection timeout');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return Exception('Receive timeout');
    } else if (error.type == DioExceptionType.badResponse) {
      return Exception('Bad response: ${error.response?.statusCode}');
    }
    return Exception(error.message);
  }
}
