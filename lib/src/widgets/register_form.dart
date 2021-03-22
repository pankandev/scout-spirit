import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/forms/register.dart';
import 'package:scout_spirit/src/models/credentials.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/validators/email.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool loading = false;

  bool wasEmailTouched = false;
  bool wasPasswordTouched = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegisterFormBloc form = RegisterFormBloc();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey, child: _buildLoginForm(context, disabled: loading));
  }

  Widget _buildLoginForm(BuildContext context, {bool disabled = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          SizedBox(height: 10.0),
          Text('Crear cuenta', style: appTheme.textTheme.headline1),
          SizedBox(
            height: 10.0,
          ),
          _buildEmailField(disabled: disabled),
          SizedBox(
            height: 10.0,
          ),
          _buildNicknameField(disabled: disabled),
          SizedBox(
            height: 10.0,
          ),
          _buildNameField(disabled: disabled),
          SizedBox(
            height: 10.0,
          ),
          _buildLastNameField(disabled: disabled),
          SizedBox(
            height: 10.0,
          ),
          _buildPasswordField(disabled: disabled),
          SizedBox(
            height: 10.0,
          ),
          _buildConfirmPasswordField(disabled: disabled),
          SizedBox(
            height: 50.0,
          ),
          _buildLoginButton(context, disabled: disabled),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, {bool disabled = true}) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RaisedButton(
            onPressed: disabled ? null : () => _register(context),
            disabledColor: appTheme.accentColor.withAlpha(150),
            color: appTheme.accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Crear cuenta',
                  style: TextStyle(color: Colors.white),
                ),
                if (loading)
                  SizedBox(
                      width: 12.0,
                      height: 12.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.8,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({bool disabled = false}) {
    return TextFormField(
        controller: form.passwordController,
        enabled: !disabled,
        obscureText: true,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: 'Contraseña', suffixIcon: Icon(Icons.https)),
        validator: (String value) {
          return value.isEmpty ? 'Este campo es obligatorio' : null;
        },
        onChanged: (value) {
          if (!wasPasswordTouched) setState(() => wasPasswordTouched = true);
        });
  }

  Widget _buildConfirmPasswordField({bool disabled = false}) {
    return TextFormField(
        controller: form.repeatPasswordController,
        enabled: !disabled,
        obscureText: true,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: 'Repetir contraseña', suffixIcon: Icon(Icons.https)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          if (value != form.passwordController.text) {
            return 'Este campo debe ser igual a la contraseña anterior';
          }
          return null;
        });
  }

  Widget _buildEmailField({bool disabled = false}) {
    return TextFormField(
        controller: form.emailController,
        enabled: !disabled,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: 'Correo',
          suffixIcon: Icon(Icons.alternate_email),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          if (!validateEmailFunc(value)) {
            return 'Debe ingresar un correo válido';
          }
          return null;
        });
  }

  Widget _buildNameField({bool disabled = false}) {
    return TextFormField(
        controller: form.nameController,
        enabled: !disabled,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: 'Nombre', suffixIcon: Icon(Icons.person)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        });
  }

  Widget _buildLastNameField({bool disabled = false}) {
    return TextFormField(
        controller: form.lastNameController,
        enabled: !disabled,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: 'Apellidos',
          suffixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        });
  }

  Widget _buildNicknameField({bool disabled = false}) {
    return TextFormField(
        controller: form.nicknameController,
        enabled: !disabled,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: 'Apodo',
            suffixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        });
  }

  Future<void> _register(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      SnackBarProvider.showMessage(
          context, 'Alguno de los campos está incorrecto');
      return;
    }
    setState(() {
      this.loading = true;
    });
    try {
      SignUpCredentials credentials = form.credentials;
      await AuthenticationService().register(
          email: credentials.email,
          password: credentials.password,
          nickname: credentials.nickname,
          name: credentials.name,
          lastName: credentials.lastName,
          birthDate: credentials.birthDate,
          unit: credentials.unit);
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
