import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_spirit/src/modals/objective-select.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/services/districts.dart';
import 'package:scout_spirit/src/services/groups.dart';
import 'package:scout_spirit/src/utils/development_area.dart';

class ActiveTaskContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double aspectRatio = 1.918;
    double width = size.width * 0.9;
    double height = size.width * 0.9 / aspectRatio;

    return StreamBuilder<User>(
        stream: AuthenticationService().userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          User user = snapshot.data;
          return user.beneficiary.target == null
              ? _buildEmptyContainer(height, width, context)
              : _buildTaskContainer(height, width, context);
        });
  }

  Widget _buildTaskContainer(
      double height, double width, BuildContext context) {
    return Container();
  }

  Widget _buildEmptyContainer(
      double height, double width, BuildContext context) {
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
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.1, vertical: height * 0.1),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () => _onCreate(context),
                    elevation: 2.0,
                    fillColor: Color.fromRGBO(71, 48, 207, 1),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    shape: CircleBorder(),
                  ),
                ),
                SizedBox(
                  width: 24.0,
                ),
                Expanded(
                  flex: 12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¡Atención!',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Neucha',
                              fontSize: 21.0)),
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
    showDialog(
        context: context,
        child: ObjectiveSelectModal(
            onSelect: (area) => _onAreaSelect(context, area)));
  }

  Future<void> _onAreaSelect(BuildContext context, DevelopmentArea area) async {
    await Navigator.of(context).pushNamed('/tasks/start', arguments: area);
  }

  Future<void> goToTask(BuildContext context) async {
    BeneficiariesService service =
        Provider.of<BeneficiariesService>(context, listen: false);
    DistrictsService dService =
        Provider.of<DistrictsService>(context, listen: false);
    GroupsService gService = Provider.of<GroupsService>(context, listen: false);
    Beneficiary beneficiary = await service.getMyself();
  }
}
