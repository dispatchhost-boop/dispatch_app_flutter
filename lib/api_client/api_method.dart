import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/common_methods.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/services/login_credentials/login_credentials.dart';
import 'package:dispatch/prefs/share_pref.dart';
import 'package:dispatch/views/auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../connectivity/internet_controller.dart';
import '../const/loader/loader_controller.dart';
import '../services/login_credentials/user_authentications.dart';

class ApiMethods {
  static final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  //   validateStatus: (status) {
  //     return status != null && status < 500;
  //   },
    ),
    );

  static Future<dynamic> getPost({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    required WidgetRef loaderRef,
    bool loader = true,
    // required Map<String, String> clientDetails
  }) async {
    DebugConfig.debugLog("Bodyyy :: $body \nAnd $headers");
    final hasConnection = loaderRef.watch(internetProvider).hasConnection;
    if(hasConnection == true){
      try {
        if (loader) {
          loaderRef.refresh(loadingProvider.notifier).state = true;
        }
        final token = await LoginCredentials().getToken();
        final res = await _dio.post(
          url,
          data: body != null ? jsonEncode(body) : null,
          options: dio.Options(
            headers: headers ?? {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              // 'x-selected-client-id': clientDetails['client_id'],
              // 'x-selected-level': clientDetails['level'],
            },
          ),
        );
        DebugConfig.debugLog('Status Code success : ${res.statusCode}');
        return res;
      }on dio.DioException catch(e){
        DebugConfig.debugLog('Status Code error : ${e.response?.statusCode}');
        if (e.response != null) {
          // String msg = e.response?.data['message'].toString().replaceAll('{', '').replaceAll('}', '') ?? '';
          String msg = errorMsg(e);
          DebugConfig.debugLog('Post Api Error bodyyy: $msg');
          if(e.response?.statusCode == 401){
            CommonMethods.showSnackBar(title: AppStrings.logout, message: msg);
            LoginCredentials().userLogout();
          }else{
            CommonMethods.showErrorDialog(msg: msg);
          }
        } else {
          CommonMethods.showErrorDialog(msg: showDioException(e));

        }
        return null;
      }finally{
        if(loader){
          loaderRef.refresh(loadingProvider.notifier).state = false;
        }
      }
    }
  }

  static Future<dynamic> getGetApi({
    required String url,
    Map<String, String>? headers,
    required WidgetRef loaderRef,
    bool loader = true,
    // required Map<String, String> clientDetails
  }) async {
    final hasConnection = loaderRef.watch(internetProvider).hasConnection;
    if(hasConnection == true){
      try {
        if (loader) {
          loaderRef.refresh(loadingProvider.notifier).state = true;
        }

        final token = await LoginCredentials().getToken();

        DebugConfig.debugLog('Tokendf xaya :: $token');
        final res = await _dio.get(
          url,
          options: dio.Options(
            headers: headers ?? {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              // 'x-selected-client-id': clientDetails['client_id'],
              // 'x-selected-level': clientDetails['level'],
            },
          ),
        );
        return res;
      } on dio.DioException catch (e) {
        if (e.response != null) {
          DebugConfig.debugLog('Get Api Error bodyyy: ${e.response?.data}');
          DebugConfig.debugLog('Error body2: ${e.response?.data}');
          // String msg = e.response?.data['message'].toString().replaceAll('{', '').replaceAll('}', '') ?? '';
          String msg = errorMsg(e);
          if(e.response?.statusCode == 401){
            CommonMethods.showSnackBar(title: AppStrings.logout, message: msg);
            LoginCredentials().userLogout();
          }else{
            CommonMethods.showErrorDialog(msg: msg);
          }
        } else {
          DebugConfig.debugLog('No server response');
          CommonMethods.showErrorDialog(msg: showDioException(e));
        }
        return null;
      } finally {
        if (loader) {
          loaderRef.refresh(loadingProvider.notifier).state = false;
        }
      }
    }
  }

  static Future<dynamic> postMultipart({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? fields,        // normal key-value fields
    Map<String, File>? files,            // file uploads
    required WidgetRef loaderRef,
    bool loader = true,
  }) async {
    DebugConfig.debugLog("Fields :: $fields \nHeaders :: $headers \nFiles :: $files");
    final hasConnection = loaderRef.watch(internetProvider).hasConnection;

    if (hasConnection == true) {
      try {
        if (loader) {
          loaderRef.refresh(loadingProvider.notifier).state = true;
        }

        final token = await LoginCredentials().getToken();

        // Build FormData
        final formData = dio.FormData();

        // Add text fields
        fields?.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });

        // Add files
        if (files != null) {
          for (final entry in files.entries) {
            formData.files.add(MapEntry(
              entry.key,
              await dio.MultipartFile.fromFile(entry.value.path, filename: entry.value.path.split('/').last),
            ));
          }
        }

        DebugConfig.debugLog('Multi urllll :: $url');
        DebugConfig.debugLog('Form ka data :: ${formData.fields}');
        DebugConfig.debugLog('Form ka data f :: ${formData.files}');

        final res = await _dio.post(
          url,
          data: formData,
          options: dio.Options(
            headers: headers ?? {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        DebugConfig.debugLog('Multipart success: ${res.statusCode}');
        return res;
      } on dio.DioException catch (e) {
        DebugConfig.debugLog('Multipart error: ${e.response?.statusCode}');
        if (e.response != null) {
          String msg = errorMsg(e);
          if (e.response?.statusCode == 401) {
            CommonMethods.showSnackBar(title: AppStrings.logout, message: msg);
            LoginCredentials().userLogout();
          } else {
            CommonMethods.showErrorDialog(msg: msg);
          }
        } else {
          CommonMethods.showErrorDialog(msg: showDioException(e));
        }
        return null;
      } finally {
        if (loader) {
          loaderRef.refresh(loadingProvider.notifier).state = false;
        }
      }
    }
  }


  static String showDioException(dio.DioException e) {
    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
        return "Connection Timeout";
      case dio.DioExceptionType.sendTimeout:
        return "Send Timeout";
      case dio.DioExceptionType.receiveTimeout:
        return "Receive Timeout";
      case dio.DioExceptionType.badResponse:
        return "Server error: ${e.response?.statusCode}";
      case dio.DioExceptionType.cancel:
        return "Request cancelled";
      case dio.DioExceptionType.connectionError:
        return "Connection Error";
      default:
        return e.toString();
    }
  }

  static String errorMsg(dio.DioException e){
    return (() {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) {
          return data['message'].toString();
        } else if (data.containsKey('error')) {
          return data['error'].toString();
        }
      }

      return data?.toString() ?? 'Unknown error';
          })().replaceAll('{', '').replaceAll('}', '');

  }

}
