import 'package:scout_spirit/src/models/rewards/reward.dart';

enum AvatarPartEnum { LEFT_EYE, RIGHT_EYE, NECKERCHIEF, SHIRT, PANTS, MOUTH }

class Avatar {
  final AvatarEye? leftEye;
  final AvatarEye? rightEye;
  final AvatarNeckerchief? neckerchief;
  final AvatarShirt? shirt;
  final AvatarPants? pants;
  final AvatarMouth? mouth;

  Avatar(
      {this.leftEye,
      this.rightEye,
      this.neckerchief,
      this.shirt,
      this.pants,
      this.mouth});

  Map<String, dynamic> toMap() {
    return {
      "left_eye": leftEye?.toMap()['description'],
      "right_eye": rightEye?.toMap()['description'],
      "mouth": mouth?.toMap()['description'],
      "top": shirt?.toMap()['description'],
      "bottom": pants?.toMap()['description'],
      "neckerchief": neckerchief?.toMap()['description'],
    };
  }

  Map<String, dynamic> toIdMap() {
    return {
      "left_eye": leftEye?.id,
      "right_eye": rightEye?.id,
      "mouth": mouth?.id,
      "top": shirt?.id,
      "bottom": pants?.id,
      "neckerchief": neckerchief?.id,
    };
  }

  Avatar copyChanging(AvatarPartEnum type, AvatarPart? part) {
    AvatarEye? newLeftEye = leftEye;
    AvatarEye? newRightEye = rightEye;
    AvatarNeckerchief? newNeckerchief = neckerchief;
    AvatarShirt? newShirt = shirt;
    AvatarPants? newPants = pants;
    AvatarMouth? newMouth = mouth;

    switch (type) {
      case AvatarPartEnum.LEFT_EYE:
        newLeftEye = part as AvatarEye?;
        break;
      case AvatarPartEnum.RIGHT_EYE:
        newRightEye = part as AvatarEye?;
        break;
      case AvatarPartEnum.NECKERCHIEF:
        newNeckerchief = part as AvatarNeckerchief?;
        break;
      case AvatarPartEnum.SHIRT:
        newShirt = part as AvatarShirt?;
        break;
      case AvatarPartEnum.PANTS:
        newPants = part as AvatarPants?;
        break;
      case AvatarPartEnum.MOUTH:
        newMouth = part as AvatarMouth?;
        break;
    }

    return Avatar(
        leftEye: newLeftEye,
        rightEye: newRightEye,
        neckerchief: newNeckerchief,
        shirt: newShirt,
        pants: newPants,
        mouth: newMouth);
  }

  Avatar.fromMap(Map<String, dynamic> map)
      : leftEye = map['left_eye'] != null
            ? Reward.fromMap(map['left_eye']) as AvatarEye
            : null,
        rightEye = map['right_eye'] != null
            ? Reward.fromMap(map['right_eye']) as AvatarEye
            : null,
        neckerchief = map['neckerchief'] != null
            ? Reward.fromMap(map['neckerchief']) as AvatarNeckerchief
            : null,
        mouth = map['mouth'] != null
            ? Reward.fromMap(map['mouth']) as AvatarMouth
            : null,
        shirt = map['top'] != null
            ? Reward.fromMap(map['top']) as AvatarShirt
            : null,
        pants = map['bottom'] != null
            ? Reward.fromMap(map['bottom']) as AvatarPants
            : null;

  @override
  String toString() {
    return "Avatar(leftEye: $leftEye, rightEye: $rightEye, neckerchief: $neckerchief, mouth: $mouth, top: $shirt, bottom: $pants)";
  }
}
