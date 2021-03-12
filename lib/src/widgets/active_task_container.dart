import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_spirit/src/modals/objective-select.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/services/districts.dart';
import 'package:scout_spirit/src/services/groups.dart';

class ActiveTaskContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double aspectRatio = 1.618;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.white,
          radius: Radius.circular(12.0),
          strokeWidth: 1.2,
          dashPattern: [8, 3],
          child: Container(
            height: size.width * 0.9 / aspectRatio,
            width: size.width * 0.9,
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 58.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RawMaterialButton(
                  onPressed: () => _onCreate(context),
                  elevation: 2.0,
                  fillColor: Color.fromRGBO(71, 48, 207, 1),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  shape: CircleBorder(),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¡Atención!', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 12.0),
                      Text(
                        'No tienes seleccionado un objetivo de progresión activo',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onCreate(BuildContext context) async {
    showDialog(context: context, child: ObjectiveSelectModal());
  }

  Future<void> goToTask(BuildContext context) async {
    BeneficiariesService service =
        Provider.of<BeneficiariesService>(context, listen: false);
    DistrictsService dService =
        Provider.of<DistrictsService>(context, listen: false);
    GroupsService gService = Provider.of<GroupsService>(context, listen: false);
    Beneficiary beneficiary = await service.getMyself();
    print(beneficiary);
  }
}
