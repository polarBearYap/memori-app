import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:memori_app/firebase/remote_config/remote_config.dart';

class BaseApi {
  final _dioOption = BaseOptions(
    // baseUrl: 'https://jhengkhinyap.dev:8443/',
    baseUrl: FirebaseRemoteConfig.instance.getString(
      RemoteConfigKey.syncBackendUrl,
    ),
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    // receiveTimeout: const Duration(minutes: 3),
    headers: {
      HttpHeaders.authorizationHeader: "",
    },
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );

  Future<Dio> getDio() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Firebase auth current user is null.");
    }
    final token = await user.getIdToken();
    return Dio(
      _dioOption.copyWith(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ),
    );
  }

  Future<Response?> performRequest(
    final Future<Response> Function(Dio) requestFunction,
  ) async {
    Dio? dio;
    Response? response;
    try {
      dio = await getDio();
      response = await requestFunction(dio);
      if (response.statusCode != null && response.statusCode == 200) {
        return response;
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message);
        print(response?.data);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      dio?.close(force: true);
    }
    return null;
  }
}
