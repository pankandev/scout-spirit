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
    return LoginForm();
  }

  Future<void> goToPage(int page) async {
    return await _pageController.animateToPage(page,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }
}
