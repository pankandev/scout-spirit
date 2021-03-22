import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/login_form.dart';
import 'package:scout_spirit/src/widgets/register_form.dart';
import 'package:scout_spirit/src/widgets/clickable_text.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class AuthenticationPage extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Background(),
        SafeArea(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: _buildLoginContainer(context)),
              Center(child: _buildRegisterContainer(context))
            ],
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
            LoginForm(),
            SizedBox(
              height: 18.0,
            ),
            ClickableText(
                label: '¿Aún no tienes cuenta?', onTap: () => goToPage(1))
          ],
        ));
  }

  Future<void> goToPage(int page) async {
    return await _pageController.animateToPage(page,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  Widget _buildRegisterContainer(BuildContext context) {
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
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 12.0),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RegisterForm(),
              SizedBox(
                height: 18.0,
              ),
              ClickableText(
                  label: '¿Ya tienes cuenta?',
                  onTap: () => goToPage(0))
            ],
          ),
        ));
  }
}
