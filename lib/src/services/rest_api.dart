import 'dart:convert';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

abstract class RestApiService {
  Future<String> getToken() async {
    CognitoAuthSession session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true));
    return session.userPoolTokens.idToken;
  }

  Future<Map<String, String>> getAuthorizedHeader() async {
    String token = await getToken();
    if (token == null)
      return {};
    return {"Authorization": token};
  }

  Future<Map> _handleJsonOperation(RestOperation operation) async {
    RestResponse response = await operation.response;
    return json.decode(String.fromCharCodes(response.data));
  }

  Future<Map> get(String path, {Map<String, String> queryParams}) async {
    RestOptions options = RestOptions(
      path: path,
      headers: await getAuthorizedHeader()
    );
    if (queryParams != null) options.queryParameters = queryParams;
    try {
      return await _handleJsonOperation(Amplify.API.get(restOptions: options));
    } on ApiException catch (e) {
      throw e;
    }
  }

  Future<void> put(String path, Map body) async {
    try {
      RestOptions options = RestOptions(
          path: path, body: Uint8List.fromList(json.encode(body).codeUnits));
      return await _handleJsonOperation(Amplify.API.put(restOptions: options));
    } on ApiException catch (e) {
      throw e;
    }
  }

  Future<void> post(String path, Map body) async {
    try {
      RestOptions options = RestOptions(
          path: path, body: Uint8List.fromList(json.encode(body).codeUnits));
      return await _handleJsonOperation(Amplify.API.post(restOptions: options));
    } on ApiException catch (e) {
      throw e;
    }
  }

  Future<void> delete(String path) async {
    try {
      RestOptions options = RestOptions(
        path: path,
      );
      return await _handleJsonOperation(
          Amplify.API.delete(restOptions: options));
    } on ApiException catch (e) {
      throw e;
    }
  }
}
