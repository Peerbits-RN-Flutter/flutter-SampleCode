import 'dart:developer' show log;
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../config/Config.dart';

enum ApiEnvironment { UAT, Dev, Prod }

extension APIEnvi on ApiEnvironment {
  String? get endpoint {
    switch (this) {
      case ApiEnvironment.UAT:
        return 'http://35.180.154.93:3005/api/v1/';
      case ApiEnvironment.Dev:
        return '';
      case ApiEnvironment.Prod:
        return 'https://api.hireplus.app/api/v1/';
      default:
        return null;
    }
  }
}

typedef void OnError(String error, Map<String, dynamic> data);
typedef void OnResponse<BaseResponse>(BaseResponse response);

class DioFactory {
  static final _singleton = DioFactory._instance();

  static Dio? get dio => _singleton._dio;
  static var _deviceName = 'Generic Device';
  static var _authorization = '';

  static Future<bool> computeDeviceInfo() async {
    if (Platform.isAndroid || Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = '${androidInfo.brand} ${androidInfo.model}';
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
      }
    } else if (Platform.isFuchsia) {
      _deviceName = 'Generic Fuchsia Device';
    } else if (Platform.isLinux) {
      _deviceName = 'Generic Linux Device';
    } else if (Platform.isMacOS) {
      _deviceName = 'Generic Macintosh Device';
    } else if (Platform.isWindows) {
      _deviceName = 'Generic Windows Device';
    }
    return true;
  }

  static void initialiseHeaders(String token) {
    _authorization = token;
    dio!.options.headers[HttpHeaders.authorizationHeader] = _authorization;
  }

  static void initFCMToken(String token) {
    var _token = token;
    dio!.options.headers["device_id"] = _token;
  }

  Dio? _dio;

  DioFactory._instance() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEnvironment.UAT.endpoint!,
        headers: {
          HttpHeaders.userAgentHeader: _deviceName,
          HttpHeaders.authorizationHeader: _authorization,
          "device_id": Config.FCM_TOKEN,
          "device_type": Platform.isIOS ? "I" : "A",
          "language": Get.deviceLocale!.languageCode
        },
        connectTimeout: Config.timeout,
        receiveTimeout: Config.timeout,
        sendTimeout: Config.timeout,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (!kReleaseMode) {
      _dio!.interceptors.add(LogInterceptor(
        request: Config.logNetworkRequest,
        requestHeader: Config.logNetworkRequestHeader,
        requestBody: Config.logNetworkRequestBody,
        responseHeader: Config.logNetworkResponseHeader,
        responseBody: Config.logNetworkResponseBody,
        error: Config.logNetworkError,
        logPrint: (Object object) {
          log(object.toString(), name: 'dio');
        },
      ));
    }
    if (Config.selfSignedCert) {
      final httpClientAdapter =
          _dio!.httpClientAdapter as DefaultHttpClientAdapter;
      httpClientAdapter.onHttpClientCreate = _onHttpClientCreate;
    }
  }

  dynamic _onHttpClientCreate(HttpClient client) {
    client.badCertificateCallback = _badCertificateCallback;
  }

  bool _badCertificateCallback(X509Certificate cert, String host, int port) {
    return true;
  }
}
