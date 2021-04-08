import '../Utils/Utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'BaseResponse.dart';
import 'ApiEndPoints.dart';
import 'DioFactory.dart';

enum HttpMethod { delete, get, patch, post, put }

extension HttpMethods on HttpMethod {
  String? get value {
    switch (this) {
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
      default:
        return null;
    }
  }
}

class Api {
  Api._();

  static final catchError = _catchError;

  static void _catchError(e, stackTrace, OnError onError) {
    if (!kReleaseMode) {
      print(e);
    }
    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.other) {
        onError('Server unreachable', {});
      } else if (e.type == DioErrorType.response) {
        final response = e.response;
        if (response != null) {
          final data = response.data;
          if (data != null && data is Map<String, dynamic>) {
            showSessionDialog();
            onError('Failed to get response: ${e.message}', data);
            return;
          }
        }
        onError('Failed to get response: ${e.message}', {});
      } else {
        onError('Request cancelled', {});
      }
    } else {
      onError(e?.toString() ?? 'Unknown error occurred', {});
    }
  }

  //General Post Request
  static Future<void> request(
      {@required HttpMethod? method,
      @required String? path,
      @required Map? params,
      @required OnResponse<BaseResponse>? onResponse,
      @required OnError? onError}) async {
    // if (path != ApiEndPoints.getToken &&
    //     path != ApiEndPoints.bookmark_candidate &&
    //     path != ApiEndPoints.like_candidate) {
    //   showLoading();
    // }
    showLoading();
    var response;
    switch (method) {
      case HttpMethod.post:
        response = await DioFactory.dio!
            .post(
              path!,
              data: params,
            )
            .catchError(
                (e, stackTrace) => _catchError(e, stackTrace, onError!));
        break;
      case HttpMethod.delete:
        response = await DioFactory.dio!
            .delete(
              path!,
              data: params,
            )
            .catchError(
                (e, stackTrace) => _catchError(e, stackTrace, onError!));
        break;
      case HttpMethod.get:
        response = await DioFactory.dio!
            .get(
              path!,
            )
            .catchError(
                (e, stackTrace) => _catchError(e, stackTrace, onError!));
        break;
      case HttpMethod.patch:
        response = await DioFactory.dio!
            .patch(
              path!,
              data: params,
            )
            .catchError(
                (e, stackTrace) => _catchError(e, stackTrace, onError!));
        break;
      case HttpMethod.put:
        response = await DioFactory.dio!
            .put(
              path!,
              data: params,
            )
            .catchError(
                (e, stackTrace) => _catchError(e, stackTrace, onError!));
        break;
      default:
        return null;
    }
    hideLoading();
    if (response != null) {
      if (response.data["success"] == 0) {
        onError!(response.data["error"][0], {});
      } else if (response.statusCode == 401) {
        showSessionDialog();
      } else {
        onResponse!(BaseResponse.fromJson(response.data));
      }
    }
  }
}
