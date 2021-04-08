import 'dart:io';

//import '../../src/Account/Models/CMSPages.dart';
//import 'package:company/src/Account/Views/CMSPageView.dart';
//import 'package:company/src/Authentication/Controllers/LoginController.dart';
//import 'package:company/src/Authentication/Models/LoginRequest.dart';
//import 'package:company/src/Authentication/Models/UserModel.dart';
//import 'package:company/src/Home/Models/NotificationModel.dart';
import 'package:Common/common/ApiFactory/Models/Cms.dart';
import 'package:flutter/material.dart';

import '../../config/prefs/PrefUtils.dart';
import '../../utils/Utils.dart';
import '../Api.dart';
import '../ApiEndPoints.dart';
import '../DioFactory.dart';
import '../models/TokenModel.dart';

getToken({required String token}) {
  Api.request(
    method: HttpMethod.post,
    path: ApiEndPoints.getToken,
    params: {
      "device_id": token,
      "device_type": Platform.isIOS ? "I" : "A",
    },
    onResponse: (response) {
      if (response.success == 1) {
        Token _token = Token.fromJson(response.data["auth"]);
        DioFactory.initialiseHeaders(_token.type! + " " + _token.token!);
        PrefUtils.setToken(_token.type! + " " + _token.token!);

        /*getCMSPagesAPI(
          onError: (error, data) {
            handleApiError(error);
          },
          onResponse: (response) {
            objCms.value = response;
            PrefUtils.setCMS(jsonEncode(response));
          },
        );*/
      }
    },
    onError: (error, data) {
      handleApiError(error);
    },
  );
}

Future<void> getCMSPagesAPI({
  @required OnResponse<Cms>? onResponse,
  @required OnError? onError,
}) async {
  Api.request(
    method: HttpMethod.post,
    path: ApiEndPoints.get_cms,
    params: {"type": 4},
    onResponse: (response) {
      if (onResponse == null) return;
      if (response.success == 1) {
        onResponse(Cms.fromJson(response.data['cms']));
      }
    },
    onError: (error, data) {
      if (onError == null) return;
      onError(error, {});
    },
  );
}

/*
Future<void> signinAPI({
  @required LoginRequest data,
  @required OnResponse<UserModel> onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.post,
    path: ApiEndPoints.signin,
    params: data.toJson(),
    onResponse: (response) {
      if (response.success == 1) {
        //String token = response.data["auth"]["type"] +
        //    " " + response.data["auth"]["token"];
        //DioFactory.initialiseHeaders(token);
        //PrefUtils.setToken(token);
        PrefUtils.setIsLoggedIn(true);
        onResponse(UserModel.fromJson(response.data["user"]));
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> forgotpasswordAPI({
  @required String email,
  @required OnResponse onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.post,
    path: ApiEndPoints.forgot_password,
    params: {
      "email": email
    },
    onResponse: (response) {
      if (response.success == 1) {
        onResponse(response.data);
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> signupAPI({
  @required SignupRequest data,
  @required OnResponse<UserModel> onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.post,
    path: ApiEndPoints.signup,
    params: data.toJson(),
    onResponse: (response) {
      if (response.success == 1) {
        PrefUtils.setIsLoggedIn(true);
        onResponse(UserModel.fromJson(response.data["user"]));
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> updateProfileAPI({
  @required UserModel data,
  @required OnResponse<UserModel> onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.post,
    path: ApiEndPoints.update_profile,
    params: data.updateProfiletoJson(),
    onResponse: (response) {
      if (response.success == 1) {
        onResponse(UserModel.fromJson(response.data["user"]));
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> logout({
  @required OnResponse onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.get,
    path: ApiEndPoints.logout,
    params: null,
    onResponse: (response) {
      if (response.success == 1) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(KcurrentUser.value.id.toString().setChatId)
            .update({
          "fcmToken": null,
        });

        onResponse(response.data);
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> changePasswordAPI({
  @required String old_password,
  @required String new_password,
  @required OnResponse onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.post,
    path: ApiEndPoints.change_password,
    params: {
      "old_password": old_password,
      "new_password": new_password
    },
    onResponse: (response) {
      if (response.success == 1) {
        onResponse(response.data);
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> getNotificationsAPI({
  @required int start,
  @required int limit,
  @required OnResponse<List<NotificationModel>> onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.post,
    params: {"start": start, "limit": limit},
    path: ApiEndPoints.getNotifications,
    onResponse: (response) {
      if (response.success == 1) {
        var items = response.data["notification"];
        List<NotificationModel> objList = items.map<NotificationModel>((e) => NotificationModel.fromJson(e)).toList();
        onResponse(objList);
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> deleteAccountAPI({
  @required OnResponse onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.delete,
    path: ApiEndPoints.deleteApi,
    params: {},
    onResponse: (response) {
      if (response.success == 1) {
        onResponse(response.data);
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> resendEmailAPI({
  @required OnResponse onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.get,
    path: ApiEndPoints.resendEmail,
    params: {},
    onResponse: (response) {
      if (response.success == 1) {
        onResponse(response.data);
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}

Future<void> getProfileAPI({
  @required OnResponse<UserModel> onResponse,
  @required OnError onError,
}) async {
  Api.request(
    method: HttpMethod.get,
    path: ApiEndPoints.profile_details,
    params: {},
    onResponse: (response) {
      if (response.success == 1) {
        onResponse(UserModel.fromJson(response.data["user"]));
      }
    },
    onError: (error, data) {
      onError(error, {});
    },
  );
}*/
