import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
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

  Future<Beneficiary> getMyself() async {
    AuthUser user = await Amplify.Auth.getCurrentUser();
    if (user == null) throw UnauthenticatedError();
    return await getById(user.userId);
  }

  Future<Beneficiary> getById(String id) async {
    return Beneficiary.fromMap(await this.get("$_apiPath/$id"));
  }

  Future<List<Beneficiary>> getAllFromGroup(
      String districtCode, String groupCode) async {
    List<dynamic> items = (await this.get(
            "api/districts/$districtCode/groups/$groupCode/beneficiaries/"))[
        "items"];
    return items.map<Beneficiary>((item) => Beneficiary.fromMap(item)).toList();
  }
}
