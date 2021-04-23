// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

import 'package:uuid/uuid.dart' as uuid;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/error/unauthenticated_error.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/rest_api.dart';

class BeneficiariesService extends RestApiService {
  final String _apiPath = 'api/beneficiaries';

  static BeneficiariesService _instance = BeneficiariesService._internal();

  BeneficiariesService._internal();

  factory BeneficiariesService() {
    return _instance;
  }

  Future<Beneficiary?> getMyself() async {
    AuthUser? user = await Amplify.Auth.getCurrentUser();
    // ignore: unnecessary_null_comparison
    if (user == null)
      throw UnauthenticatedError(message: 'Trying to get current beneficiary');
    return await getById(user.userId);
  }

  Future<Beneficiary?> getById(String id) async {
    try {
      return Beneficiary.fromMap(await this.get("$_apiPath/$id"));
    } on HttpError catch (e) {
      if (e.statusCode == 404) {
        return null;
      } else {
        throw e;
      }
    }
  }

  Future<List<Beneficiary>> getAllFromGroup(
      String districtCode, String groupCode) async {
    List<dynamic> items = (await this.get(
            "api/districts/$districtCode/groups/$groupCode/beneficiaries/"))[
        "items"];
    return items.map<Beneficiary>((item) => Beneficiary.fromMap(item)).toList();
  }

  Future<void> joinGroup(String code) async {
    List<String> split = code.split('::');
    if (split.length != 3) {
      throw new AppError(message: 'Code does not have three parts');
    }
    final district = split[0];
    final group = split[1];
    final realCode = split[2];
    await this.post("api/districts/$district/groups/$group/beneficiaries/join",
        body: {"code": realCode});
  }

  Future<String> uploadPublicFile(String identityId, File file) async {
    String extension = file.path.split('.').last;
    String id = uuid.Uuid().v1();
    String filename = "$id.$extension";
    final String key = "$identityId/images/$filename";
    await Amplify.Storage.uploadFile(
        key: key, local: file, options: UploadFileOptions());
    return filename;
  }

  Future<String> uploadProfilePicture(File file) async {
    String userId = await AuthenticationService().authenticatedUserId;
    String identityId = await AuthenticationService().getIdentityId();
    String filename = await uploadPublicFile(identityId, file);
    String url = getImageUrl(identityId, filename);
    await put("api/beneficiaries/$userId", {
      "profile_picture": url
    });
    await AuthenticationService().updateAuthenticatedUser();
    return url;
  }

  String getImageUrl(String identityId, String filename) {
    return webUrl + "public/$identityId/images/$filename";
  }
}
