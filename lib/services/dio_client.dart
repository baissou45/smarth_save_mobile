import 'package:dio/dio.dart';
import 'package:smarth_save/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  late Dio _dio;

  factory DioClient() {
    return _instance;
  }

  static DioClient get instance => _instance;

  DioClient._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: API().baseURL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.bytes,
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
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          // Handle 401 — auto logout
          if (error.response?.statusCode == 401) {
            _handleUnauthorized();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    try {
      // Read token from SharedPreferences
      // This is done inline instead of via UserProvider to avoid context dependency
      // In a real app, consider using GetIt or a similar service locator
      final prefs = await _getSharedPreferences();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  void _handleUnauthorized() {
    // Clear token and redirect to login
    _clearToken();
    // Navigate via GoRouter global context
    // This requires access to the navigatorKey from the router
    // For now, we'll handle this in the app's router setup
  }

  Future<void> _clearToken() async {
    try {
      final prefs = await _getSharedPreferences();
      await prefs.remove('auth_token');
      await prefs.remove('user');
    } catch (e) {
      // Silent fail
    }
  }

  // Helper to decode response from bytes to Map/List
  dynamic _decodeResponse(List<int> bytes) {
    try {
      final String decoded = utf8.decode(bytes);
      return jsonDecode(decoded);
    } catch (e) {
      throw Exception('Failed to decode response: $e');
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
      return _decodeResponse(response.data);
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
      return _decodeResponse(response.data);
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
      return _decodeResponse(response.data);
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
      return _decodeResponse(response.data);
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
