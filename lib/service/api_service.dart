import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';

class ApiService {
  final String baseUrl;
  Logger logger = Logger();
  Dio dio = Dio();

  ApiService(this.baseUrl);

  Future<ApiResponse> get({
    required String endpoint,
    String? token,
  }) async {
    logger.i("Url -> $baseUrl/$endpoint");

    try {
      final response = await dio.get(
        '$baseUrl/$endpoint',
        options: token == null
            ? null
            : Options(
                followRedirects: false,
                validateStatus: (status) => true,
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $token",
                },
              ),
      );
      logger.i(response.statusCode);
      if (response.statusCode == 200) {
        logger.i(response.data);
        return ApiResponse(
            appLoadingStatus: AppLoadingStatus.success, data: response.data);
      } else {
        logger.e(response.data);
        return ApiResponse(
            appLoadingStatus: AppLoadingStatus.error, data: response.data);
      }
    } on DioException catch (e) {
      logger.e(e.message);
      return ApiResponse(
          appLoadingStatus: AppLoadingStatus.error,
          data: e,
          message: e.message);
    }
  }

  Future<ApiResponse> post(
      {required String endpoint, required dynamic body, String? token, CancelToken? cancelToken}) async {
    logger.i("Url ->  $baseUrl/$endpoint");
    logger.i("Body -> $body");
    try {
      final response = await dio.post(
        '$baseUrl/$endpoint',
        data: body,
        options: token == null
            ? null
            : Options(
                followRedirects: false,
                validateStatus: (status) => true,
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $token",
                },
              ),
        cancelToken: cancelToken,
      );
      logger.i(response.statusCode);
      if (response.statusCode == 200) {
        logger.i(response.data);
        return ApiResponse(
            appLoadingStatus: AppLoadingStatus.success, data: response.data);
      } else {
        logger.e(response.data);
        return ApiResponse(
            appLoadingStatus: AppLoadingStatus.error, data: response.data);
      }
    } on DioException catch (e) {
      logger.e(e.message);
      return ApiResponse(
          appLoadingStatus: AppLoadingStatus.error,
          data: e,
          message: e.message);
    }
  }
}

class ApiResponse {
  final dynamic data;
  final AppLoadingStatus appLoadingStatus;
  final String? message;

  ApiResponse({
    required this.appLoadingStatus,
    required this.data,
    this.message,
  });
}
