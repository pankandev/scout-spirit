import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            children: [_buildLoginContainer(context)],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
      ),
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
                spreadRadius: 1.0
              )
            ]),
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            LoginForm(),
          ],
        ));
  }
}
