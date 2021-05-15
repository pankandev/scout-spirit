// ignore: import_of_legacy_library_into_null_safe
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/utils/development_stage.dart';
import 'package:intl/intl.dart';

enum Unit { Guides, Scouts }

class User {
  final String id;
  final String email;

  final String name;
  final String familyName;

  final String nickname;
  final DateTime birthDate;
  final Unit unit;
  final Beneficiary? beneficiary;

  static Unit unitFromName(String name) {
    switch (name.toLowerCase()) {
      case 'scouts':
        return Unit.Scouts;
      case 'guides':
        return Unit.Guides;
    }
    throw ArgumentError('Unknown unit name: $name');
  }

  int get age {
    DateTime now = DateTime.now();
    int age = now.year - birthDate.year;
    int currentMonth = now.month;
    int birthMonth = birthDate.month;
    if (birthMonth > currentMonth) {
      age--;
    } else if (currentMonth == birthMonth) {
      int currentDay = now.day;
      int birthDay = birthDate.day;
      if (birthDay > currentDay) {
        age--;
      }
    }
    return age;
  }

  DevelopmentStage get stage =>
      age < 13 ? DevelopmentStage.Prepuberty : DevelopmentStage.Puberty;

  String get stageName => stageToString(stage);

  static String? getAttribute(String key, List<AuthUserAttribute> attributes) =>
      attributes.cast<AuthUserAttribute?>()
          .firstWhere((element) => element?.userAttributeKey == key,
              orElse: () => null)?.value;

  static DateFormat get birthDateFormat => new DateFormat("dd-MM-yyyy");

  User.fromAuthUser(AuthUser user, Beneficiary? beneficiary,
      List<AuthUserAttribute> attributes)
      : id = user.userId,
        email = user.username,
        nickname = getAttribute('nickname', attributes) ?? '',
        name = getAttribute('name', attributes) ?? '',
        familyName = getAttribute('family_name', attributes) ?? '',
        birthDate = birthDateFormat
            .parse(getAttribute('birthdate', attributes) ?? '01-01-2021'),
        unit = unitFromName(getAttribute('gender', attributes) ?? 'scouts'),
        beneficiary = beneficiary;

  @override
  String toString() {
    return "User(email: $email, name: '$name', familyName: '$familyName', stage: $stage, age: $age, birthdate: ${birthDateFormat.format(birthDate)}, unit: $unit)";
  }
}
