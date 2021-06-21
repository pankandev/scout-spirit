import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:scout_spirit/src/models/district.dart';
import 'package:scout_spirit/src/models/group.dart';
import 'package:uuid/uuid.dart' as uuid;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify.dart';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/error/unauthenticated_error.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/rest_api.dart';

Beneficiary testUser = Beneficiary(
    lastClaimedToken: -1,
    unitUser: '',
    boughtItems: BoughtItems(),
    birthdate: '01-01-2000',
    nickname: 'Test User',
    target: null,
    profilePicture: null,
    nTasks: TasksCount(
        corporality: 3,
        spirituality: 5,
        character: 4,
        creativity: 2,
        affectivity: 8,
        sociability: 2),
    score: TasksCount(
        corporality: 3,
        spirituality: 5,
        character: 4,
        creativity: 2,
        affectivity: 8,
        sociability: 2),
    userId: '',
    fullName: 'Test User',
    groupCode: 'group',
    districtCode: 'district');

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
      throw UnauthenticatedError(message: 'Trying to get current beneficiary while logged out');
    if (!kReleaseMode) {
      return testUser;
    }
    return await getById(user.userId);
  }

  Future<Beneficiary?> getById(String id) async {
    try {
      return Beneficiary.fromMap(await this.get("$_apiPath/$id"));
    } on HttpError catch (e) {
      if (e.statusCode == 404) {
        return null;
      } else {
        rethrow;
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

  Future<void> joinGroup(District district, Group group, String code) async {
    String districtCode = district.code;
    String groupCode = group.code;
    await this.post("api/districts/$districtCode/groups/$groupCode/beneficiaries/join",
        body: {"code": code});
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
    String userId = AuthenticationService().authenticatedUserId;
    String identityId = await AuthenticationService().getIdentityId();
    String filename = await uploadPublicFile(identityId, file);
    String url = getImageUrl(identityId, filename);
    await put("api/beneficiaries/$userId", {"profile_picture": url});
    await AuthenticationService().updateAuthenticatedUser();
    return url;
  }

  String getImageUrl(String identityId, String filename) {
    return webUrl + "public/$identityId/images/$filename";
  }
}
