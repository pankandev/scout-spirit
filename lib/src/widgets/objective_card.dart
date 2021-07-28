import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/themes/constants.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/services/authentication.dart';

class ObjectiveCard extends StatelessWidget {
  final Objective objective;
  final void Function()? onSelect;

  ObjectiveCard({required this.objective, this.onSelect});

  AreaDisplayData get areaData => ObjectivesDisplay.getAreaIconData(
      AuthenticationService().authenticatedUser.unit, objective.area);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[Shadows.glow],
          borderRadius: BorderRadii.medium),
      child: RawMaterialButton(
        onPressed: this.onSelect,
        padding: Paddings.cardFluid,
        fillColor: Color.lerp(Colors.white, areaData.color, 0.1),
        splashColor: areaData.color.withOpacity(0.5),
        shape: Shapes.rounded,
        child: Stack(
          children: [
            if (onSelect != null)
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.chevron_right,
                  color: areaData.color.withOpacity(0.3),
                  size: IconSizes.xlarge,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(right: Dimensions.xxlarge + 36.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    objective.authorizedObjective,
                    style: TextStyles.buttonDark.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
