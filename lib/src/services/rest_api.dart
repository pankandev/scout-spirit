import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:device_info/device_info.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/error/unauthenticated_error.dart';
import 'package:http/http.dart' as http;
import 'package:scout_spirit/src/providers/logger.dart';

const WEB_URL = "https://d43k9sss5csvt.cloudfront.net/";
const LOCALHOST_URL = "http://localhost:3000/";
const EMULATOR_URL = "http://10.0.2.2:3000/";

abstract class RestApiService {
  static bool _isEmulator = false;

  static Future<void> updateEmulatorCheck() async {
    AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
    _isEmulator = !info.isPhysicalDevice;
  }

  Future<String?> _getToken() async {
    CognitoAuthSession session = await Amplify.Auth.fetchAuthSession(
            options: CognitoSessionOptions(getAWSCredentials: true))
        as CognitoAuthSession;
    return session.userPoolTokens!.idToken;
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
      Future<http.Response> responseFuture,
      {List<int> expectedStatus = const [404]}) async {
    http.Response response = await responseFuture;
    if (response.statusCode >= 400) {
      HttpError error = new HttpError(
          statusCode: response.statusCode,
          isAuthorized: response.request?.headers['Authorization'] != null,
          response: response,
          endpoint: response.request?.url.toString() ?? 'unknown');
      try {
        throw error;
      } catch (e, s) {
        if (!expectedStatus.contains(response.statusCode)) {
          await LoggerService().error(e, s);
        }
        rethrow;
      }
    }
    return json.decode(response.body);
  }

  Uri getApiUri(String path) {
    if (path.length > 0 && path[0] == '/') {
      path = path.substring(1);
    }
    // String baseUrl = kReleaseMode ? webUrl : testUrl;
    return Uri.parse(webUrl + path);
  }

  String get webUrl {
    return WEB_URL;
  }

  String get testUrl {
    return _isEmulator ? EMULATOR_URL : LOCALHOST_URL;
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? queryParams,
      List<int> expectedStatus = const [404]}) async {
    Map<String, String> headers = await _getAuthorizedHeader();
    Uri apiUri = getApiUri(path).replace(queryParameters: queryParams);
    return await _handleJsonOperation(http.get(apiUri, headers: headers),
        expectedStatus: expectedStatus);
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
