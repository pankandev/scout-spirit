import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/forms/login.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/themes/constants.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/widgets/scout_button.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool loading = false;

  bool wasEmailTouched = false;

  bool wasPasswordTouched = false;

  final LoginFormBloc _bloc = LoginFormBloc();

  @override
  Widget build(BuildContext context) {
    return _buildLoginForm(context, disabled: loading);
  }

  Widget _buildLoginForm(BuildContext context, {bool disabled = false}) {
    return Container(
        padding: Paddings.containerXFluid,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset('assets/imgs/logo.png'),
          VSpacings.xlarge,
          Text('Acceso',
              style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w600,
                  fontSize: FontSizes.xlarge,
                  color: Colors.white)),
          VSpacings.xxlarge,
          _buildEmailField(disabled: disabled),
          VSpacings.xlarge,
          _buildPasswordField(disabled: disabled),
          VSpacings.xxlarge,
          _buildLoginButton(context, disabled: disabled),
          VSpacings.small,
          ScoutButton(
            label: 'Crear cuenta',
            padding: Paddings.buttonLoose,
            onPressed: loading
                ? null
                : () => Navigator.of(context).pushNamed('/signup'),
            fillColor: loading ? Colors.grey[500]! : blueColor,
            accentColor: appTheme.accentColor,
            labelColor: Colors.white,
          ),
        ]));
  }

  Widget _buildLoginButton(BuildContext context, {bool disabled = true}) {
    return StreamBuilder<bool>(
        stream: _bloc.formValidStream,
        builder: (context, snapshot) {
          return ScoutButton(
            label: 'Entrar',
            padding: Paddings.buttonLoose,
            onPressed: disabled || snapshot.error != null
                ? null
                : () => _login(context),
            labelColor: Colors.white,
            fillColor: disabled || snapshot.error != null
                ? Colors.grey[500]!
                : appTheme.primaryColor,
            accentColor: appTheme.accentColor,
          );
        });
  }

  Widget _buildPasswordField({bool disabled = false}) {
    return StreamBuilder<String>(
        stream: _bloc.passwordStream,
        builder: (context, snapshot) {
          return TextField(
              enabled: !disabled,
              obscureText: true,
              autocorrect: false,
              style: TextStyles.inputLight,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  contentPadding: Paddings.inputLoose,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadii.max,
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadii.max,
                      borderSide: BorderSide.none),
                  fillColor: Colors.black45,
                  filled: true,
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Ubuntu',
                      fontSize: FontSizes.medium,
                      fontWeight: FontWeight.w600),
                  suffixIcon: Icon(
                    Icons.https,
                    color: Colors.white,
                    size: IconSizes.medium,
                  ),
                  errorStyle: TextStyles.error,
                  errorText:
                      wasPasswordTouched ? snapshot.error?.toString() : null),
              onChanged: (value) {
                if (!wasPasswordTouched)
                  setState(() => wasPasswordTouched = true);
                _bloc.changePassword(value);
              });
        });
  }

  Widget _buildEmailField({bool disabled = false}) {
    return StreamBuilder(
      stream: _bloc.emailStream,
      builder: (_, snapshot) => TextField(
        enabled: !disabled,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        style: TextStyles.inputLight,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            contentPadding: Paddings.inputLoose,
            border: OutlineInputBorder(
                borderRadius: BorderRadii.max, borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadii.max, borderSide: BorderSide.none),
            fillColor: Colors.black45,
            filled: true,
            labelStyle: TextStyle(
                color: Colors.white70,
                fontFamily: 'Ubuntu',
                fontSize: FontSizes.medium,
                fontWeight: FontWeight.w600),
            labelText: 'Correo',
            suffixIcon: Icon(
              Icons.alternate_email,
              color: Colors.white,
              size: IconSizes.medium,
            ),
            errorStyle: TextStyles.error,
            errorText: wasEmailTouched ? snapshot.error?.toString() : null),
        onChanged: (value) {
          if (!wasEmailTouched) setState(() => wasEmailTouched = true);
          _bloc.changeEmail(value);
        },
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    setState(() {
      this.loading = true;
    });

    bool errored = false;
    AuthenticationService service = AuthenticationService();
    try {
      errored =
          !await service.login(context, this._bloc.email, this._bloc.password);
    } on UserNotConfirmedException {
      await Navigator.of(context)
          .pushNamed('/confirm', arguments: this._bloc.email);
      setState(() {
        this.loading = false;
      });
      return;
    }

    if (errored) {
      setState(() {
        this.loading = false;
      });
    } else if (service.snapAuthenticatedUser?.beneficiary == null) {
      await Navigator.of(context).pushReplacementNamed('/join');
    } else {
      await Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
