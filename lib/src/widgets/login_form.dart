import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/forms/login.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/themes/theme.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          SizedBox(height: 10.0),
          Text('Acceso', style: appTheme.textTheme.headline1),
          SizedBox(
            height: 10.0,
          ),
          _buildEmailField(disabled: disabled),
          SizedBox(
            height: 10.0,
          ),
          _buildPasswordField(disabled: disabled),
          SizedBox(
            height: 50.0,
          ),
          _buildLoginButton(context, disabled: disabled),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, {bool disabled = true}) {
    return StreamBuilder<bool>(
        stream: _bloc.formValidStream,
        builder: (context, snapshot) {
          return Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RaisedButton(
                  onPressed: disabled || snapshot.error != null
                      ? null
                      : () => _login(context),
                  disabledColor: appTheme.accentColor.withAlpha(150),
                  color: appTheme.accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      if (loading)
                        SizedBox(
                            width: 12.0,
                            height: 12.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ))
                    ],
                  ),
                ),
              ],
            ),
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
              decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: Icon(Icons.https),
                  errorText: wasPasswordTouched ? snapshot.error : null),
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
        decoration: InputDecoration(
            labelText: 'Correo',
            suffixIcon: Icon(Icons.alternate_email,
                color: wasEmailTouched && snapshot.error != null
                    ? appTheme.errorColor
                    : null),
            errorText: wasEmailTouched ? snapshot.error : null),
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
    try {
      await AuthenticationService().login(this._bloc.email, this._bloc.password);
    } on NotAuthorizedException catch (e) {
      SnackBarProvider.showMessage(context, 'Contraseña incorrecta');
      throw e;
    } on UserNotFoundException catch (e) {
      SnackBarProvider.showMessage(context, 'Correo electrónico no registrado');
      throw e;
    } on UserNotConfirmedException catch (e) {
      SnackBarProvider.showMessage(context, 'Usuario no confirmado');
      throw e;
    } catch (e) {
      setState(() {
        this.loading = false;
      });
    }
    await Navigator.of(context).pushReplacementNamed('/');
  }
}
