// ignore: import_of_legacy_library_into_null_safe
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:amplify_flutter/amplify.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/error/unauthenticated_error.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
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
}
