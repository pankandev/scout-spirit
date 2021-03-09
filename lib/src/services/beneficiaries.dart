import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/services/rest_api.dart';

class BeneficiariesService extends RestApiService {
  final String _apiPath = 'api/beneficiaries';

  Future<Beneficiary> getMyself() async {
    AuthUser user = await Amplify.Auth.getCurrentUser();
    return Beneficiary.fromJson(await this.get("$_apiPath/${user.userId}"));
  }
}