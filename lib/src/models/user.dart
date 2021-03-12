import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';

enum Unit { Guides, Scouts }

class User {
  final String id;
  final String email;
  final Unit unit;
  final Beneficiary beneficiary;

  static Unit unitFromName(String name) {
    switch (name.toLowerCase()) {
      case 'scouts':
        return Unit.Scouts;
      case 'guides':
        return Unit.Guides;
    }
    throw ArgumentError('Unknown unit name: $name');
  }

  User.fromAuthUser(AuthUser user, Beneficiary beneficiary,
      List<AuthUserAttribute> attributes)
      : id = user.userId,
        email = user.username,
        unit = unitFromName(attributes
            .firstWhere((element) => element.userAttributeKey == "gender")
            .value),
        beneficiary = beneficiary;
}
