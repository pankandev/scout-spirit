import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';

class _RewardImage {
  final String assetName;
  final bool fill;

  const _RewardImage(this.assetName, this.fill);
}

class RewardCard extends StatelessWidget {
  final Reward? reward;

  const RewardCard({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _RewardImage? image = _getRewardImage();
    return ClipPath(
      clipper: RewardClipper(),
      child: Container(
          child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                  decoration: BoxDecoration(
                      color: (image?.fill ?? false) ? null : Colors.white),
                  child: Center(
                      child: image != null
                          ? _buildImage(image)
                          : Text(
                              'Auto',
                              style: TextStyle(
                                fontFamily: 'UbuntuCondensed',
                                  color: Colors.black, fontSize: 16.0),
                            ))))),
    );
  }

  _RewardImage getAvatarImage(AvatarPart reward) {
    String parent;
    String extension = 'jpg';
    bool fill = false;
    switch (reward.type) {
      case AvatarRewardType.PANTS:
        parent = 'clothes/';
        fill = true;
        break;
      case AvatarRewardType.SHIRT:
        parent = 'clothes/';
        fill = true;
        break;
      case AvatarRewardType.EYE:
        parent = 'eyes/';
        extension = 'png';
        break;
      case AvatarRewardType.MOUTH:
        parent = 'mouths/';
        extension = 'png';
        break;
      case AvatarRewardType.NECKERCHIEF:
        parent = 'clothes/';
        fill = true;
        break;
      default:
        parent = '';
        break;
    }
    return _RewardImage("assets/imgs/avatar/$parent${reward.material}.$extension", fill);
  }

  _RewardImage? _getRewardImage() {
    String image;
    if (reward is ZoneReward) {
      image = 'zones/default.png';
    } else if (reward is AvatarPart) {
      return getAvatarImage(reward as AvatarPart);
    } else if (reward is Points) {
      image = 'points.png';
    } else if (reward is DecorationReward) {
      image = 'decoration/${(reward as DecorationReward).code}.png';
    } else {
      return null;
    }
    return _RewardImage("assets/imgs/$image", false);
  }

  Widget _buildImage(_RewardImage image) {
    return Image.asset(image.assetName, fit: BoxFit.cover);
  }
}

class RewardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width * 0.04, size.height * 0.1);
    path.cubicTo(size.width * 0.04, size.height * 0.06, size.width * 0.07,
        size.height * 0.03, size.width * 0.11, size.height * 0.03);
    path.cubicTo(size.width / 4, size.height * 0.01, size.width / 3, 0,
        size.width / 2, size.height * 0.01);
    path.cubicTo(size.width * 0.66, size.height * 0.03, size.width * 0.75,
        size.height * 0.03, size.width * 0.9, size.height * 0.01);
    path.cubicTo(size.width * 0.94, size.height * 0.01, size.width * 0.97,
        size.height * 0.04, size.width * 0.97, size.height * 0.08);
    path.cubicTo(size.width, size.height * 0.26, size.width, size.height * 0.35,
        size.width * 0.97, size.height / 2);
    path.cubicTo(size.width * 0.95, size.height * 0.66, size.width * 0.96,
        size.height * 0.75, size.width * 0.97, size.height * 0.91);
    path.cubicTo(size.width * 0.97, size.height * 0.95, size.width * 0.94,
        size.height * 0.98, size.width * 0.9, size.height * 0.98);
    path.cubicTo(size.width * 0.73, size.height * 0.96, size.width * 0.64,
        size.height * 0.97, size.width / 2, size.height * 0.98);
    path.cubicTo(size.width * 0.26, size.height, size.width * 0.19, size.height,
        size.width * 0.09, size.height * 0.98);
    path.cubicTo(size.width * 0.05, size.height * 0.98, size.width * 0.02,
        size.height * 0.95, size.width * 0.02, size.height * 0.91);
    path.cubicTo(0, size.height * 0.75, -0.01, size.height * 0.66,
        size.width * 0.02, size.height / 2);
    path.cubicTo(size.width * 0.04, size.height * 0.34, size.width * 0.04,
        size.height * 0.26, size.width * 0.04, size.height * 0.1);
    path.cubicTo(size.width * 0.04, size.height * 0.1, size.width * 0.04,
        size.height * 0.1, size.width * 0.04, size.height * 0.1);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
