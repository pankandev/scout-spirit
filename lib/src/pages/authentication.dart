import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/login_form.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class AuthenticationPage extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: <Widget>[
        Background(),
        SizedBox(
          height: screenSize.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Flex(direction: Axis.vertical, children: [
              SafeArea(
                  child: Container(
                height: screenSize.height * 0.1,
              )),
              _buildLoginContainer(context),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildLoginContainer(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(4, 4),
                  color: Colors.black26,
                  blurRadius: 16.0,
                  spreadRadius: 1.0)
            ]),
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoginForm()
          ],
        ));
  }

  Future<void> goToPage(int page) async {
    return await _pageController.animateToPage(page,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }
}
