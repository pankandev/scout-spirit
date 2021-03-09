
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';

class ActiveTaskContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.white,
          radius: Radius.circular(12.0),
          strokeWidth: 1.2,
          dashPattern: [8, 3],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      IconButton(icon: Icon(Icons.add), color: Colors.white, onPressed: () => goToTask(context))
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> goToTask(BuildContext context) async {
    BeneficiariesService service = Provider.of<BeneficiariesService>(context, listen: false);
    Beneficiary beneficiary = await service.getMyself();
    print(beneficiary);
  }
}
