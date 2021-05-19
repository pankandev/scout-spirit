import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/themes/theme.dart';

class LogCard extends StatelessWidget {
  final Log log;

  const LogCard({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.8,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.white54, blurRadius: 12.0)
            ]),
        child: Stack(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 1,
                    child: Icon(log.display.icon,
                        size: 48.0, color: appTheme.primaryColor)),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.timestampLabel,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color.fromRGBO(139, 139, 139, 1),
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              log.displayLog,
                              style: TextStyle(
                                  fontSize: 21.0,
                                  fontFamily: 'ConcertOne',
                                  color: appTheme.primaryColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
