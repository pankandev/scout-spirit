import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:amplify_flutter/amplify.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/error/unauthenticated_error.dart';
import 'package:http/http.dart' as http;

abstract class RestApiService {
  Future<String?> _getToken() async {
    CognitoAuthSession session = await Amplify.Auth.fetchAuthSession(
            options: CognitoSessionOptions(getAWSCredentials: true))
        as CognitoAuthSession;
    return session.userPoolTokens.idToken;
  }

  Future<Map<String, String>> _getAuthorizedHeader() async {
    String? token = await _getToken();
    if (token == null) return {};
    return {"Authorization": "Bearer $token"};
  }

  Future<AuthUser> throwIfUnauthenticated() async {
    AuthUser? user = await Amplify.Auth.getCurrentUser();
    // ignore: unnecessary_null_comparison
    if (user == null)
      throw UnauthenticatedError(message: 'No authenticated user found');
    return user;
  }

  Future<Map<String, dynamic>> _handleJsonOperation(
      Future<http.Response> responseFuture) async {
    http.Response response = await responseFuture;
    if (response.statusCode >= 400) {
      throw new HttpError(statusCode: response.statusCode, response: response);
    }
    return json.decode(response.body);
  }

  Uri getApiUri(String path) {
    if (path.length > 0 && path[0] == '/') {
      path = path.substring(1);
    }
    return Uri.parse(
        "https://5ls6ka1vg1.execute-api.us-west-2.amazonaws.com/Prod/" + path);
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? queryParams}) async {
    Map<String, String> headers = await _getAuthorizedHeader();
    Uri apiUri = getApiUri(path).replace(queryParameters: queryParams);
    return await _handleJsonOperation(http.get(apiUri, headers: headers));
  }

  Future<Map<String, dynamic>> put(String path, Map body) async {
    Map<String, String> headers = await _getAuthorizedHeader();
    Uri apiUri = getApiUri(path);
    return await _handleJsonOperation(
        http.put(apiUri, body: json.encode(body), headers: headers));
  }

  Future<Map<String, dynamic>> post(String path, {Map? body}) async {
    Map<String, String> headers = await _getAuthorizedHeader();
    Uri apiUri = getApiUri(path);
    return await _handleJsonOperation(http.post(apiUri,
        body: body != null ? json.encode(body) : null, headers: headers));
  }

  Future<Map<String, dynamic>> delete(String path) async {
    Map<String, String> headers = await _getAuthorizedHeader();
    Uri apiUri = getApiUri(path);
    return await _handleJsonOperation(http.delete(apiUri, headers: headers));
  }
}
