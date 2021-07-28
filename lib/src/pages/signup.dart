import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scout_spirit/src/forms/register.dart';
import 'package:scout_spirit/src/models/credentials.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/validators/email.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/utils/datetime.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool loading = false;

  bool wasEmailTouched = false;

  bool wasPasswordTouched = false;

  final GlobalKey<FormState> _credentialsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _basicDataFormKey = GlobalKey<FormState>();

  final RegisterFormBloc form = RegisterFormBloc();

  int _currentStep = 0;

  Widget _buildLoginForm(BuildContext context, {bool disabled = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Crear cuenta',
          style: appTheme.textTheme.headline2?.copyWith(fontSize: 24.0),
        ),
        Stepper(
          type: StepperType.vertical,
          physics: NeverScrollableScrollPhysics(),
          controlsBuilder: (context,
                  {void Function()? onStepCancel,
                  void Function()? onStepContinue}) =>
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 16.0),
                  child: RawMaterialButton(
                      elevation: !loading ? 2 : 0,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(64.0)),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: loading
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.start,
                          children: [
                            Text(
                              'Continuar',
                              style: TextStyle(color: Colors.white),
                            ),
                            if (loading)
                              SizedBox(
                                  height: 18.0,
                                  width: 18.0,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white)))
                          ],
                        ),
                      ),
                      onPressed: !loading ? onStepContinue : null,
                      fillColor: !loading
                          ? appTheme.primaryColor
                          : appTheme.primaryColor.withOpacity(0.8)),
                ),
              )
            ],
          ),
          currentStep: _currentStep,
          steps: <Step>[
            Step(
                title: Text('Credenciales'),
                isActive: true,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.disabled,
                content: _buildCredentialsPage(context, disabled: disabled)),
            Step(
                title: Text('Datos básicos'),
                isActive: _currentStep > 0,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.disabled,
                content: _buildBasicDataPage(context, disabled: disabled)),
          ],
          onStepContinue: _continue,
          onStepCancel: _cancel,
          onStepTapped: (int step) {
            setState(() {
              _currentStep = step;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCredentialsPage(BuildContext context, {bool disabled = false}) {
    return Form(
        key: _credentialsFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.0,
            ),
            _buildEmailField(disabled: disabled),
            SizedBox(
              height: 10.0,
            ),
            _buildPasswordField(disabled: disabled),
            SizedBox(
              height: 10.0,
            ),
            _buildConfirmPasswordField(disabled: disabled),
          ],
        ));
  }

  Widget _buildBasicDataPage(BuildContext context, {bool disabled = false}) {
    return Form(
      key: _basicDataFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          _buildDatePicker(disabled: disabled),
          SizedBox(
            height: 10.0,
          ),
          _buildUnitPicker(disabled: disabled)
        ],
      ),
    );
  }

  Widget _buildPasswordField({bool disabled = false}) {
    return TextFormField(
        controller: form.passwordController,
        enabled: !disabled,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autocorrect: false,
        decoration: getInputDecoration('Contraseña', Icons.https),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          if (value.length < 6) {
            return 'La contraseña debe tener al menos 6 carácteres';
          }

          bool containsUppercase = RegExp('[A-Z]').hasMatch(value);
          bool containsLowercase = RegExp('[a-z]').hasMatch(value);

          if (!containsUppercase || !containsLowercase) {
            return 'La contraseña debe tener al menos una letra minúscula y un número';
          }

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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autocorrect: false,
        decoration: getInputDecoration('Repetir contraseña', Icons.https),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          if (value != form.passwordController.text) {
            return 'Las contraseñas no coinciden';
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
        decoration: getInputDecoration('Correo', Icons.alternate_email),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
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
        decoration:
            getInputDecoration('Nombre', Icons.person, isRequired: true),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
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
        decoration:
            getInputDecoration('Apellidos', Icons.person, isRequired: true),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
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
        decoration: getInputDecoration('Apodo', Icons.person, isRequired: true),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        });
  }

  InputDecoration getInputDecoration(String label, IconData icon,
      {bool isRequired = false}) {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        labelText: label + (isRequired ? '*' : ''),
        labelStyle: TextStyle(fontFamily: 'Ubuntu'),
        errorMaxLines: 3,
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(64.0)));
  }

  final TextEditingController birthDateTextController = TextEditingController();

  Widget _buildDatePicker({required bool disabled}) {
    return ProviderConsumer(
      controller: form.birthDateController,
      builder: (controller) {
        return TextFormField(
            controller: birthDateTextController,
            enabled: !disabled,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            style: TextStyle(fontFamily: 'Ubuntu'),
            decoration: getInputDecoration(
                'Fecha de nacimiento', Icons.date_range,
                isRequired: true),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: true,
            onTap: () async {
              DateTime now = DateTime.now();
              DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: now.subtract(Duration(days: 365 * 15)),
                  firstDate: DateTime(now.year - 20),
                  lastDate: now);
              if (date != null) {
                birthDateTextController.text = dateToString(date);
                form.birthDateController.value = date;
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            });
      },
    );
  }

  bool triedToValidateDate = false;

  Widget _buildUnitPicker({bool disabled = false}) {
    Color? unselectedColor = appTheme.textTheme.caption?.color;
    Color selectedColor = Colors.white;
    return ProviderConsumer<Unit?>(
      controller: form.unitController,
      builder: (controller) => InputDecorator(
          decoration: InputDecoration(
              labelText: 'Unidad',
              errorText:
                  !triedToValidateDate || form.unitController.value != null
                      ? null
                      : 'Este campo es obligatorio',
              border: InputBorder.none),
          child: LayoutBuilder(builder: (context, constraints) {
            return ToggleButtons(
              borderRadius: BorderRadius.circular(128.0),
              fillColor: appTheme.primaryColor,
              splashColor: appTheme.primaryColor.withOpacity(0.9),
              color: Colors.black,
              constraints:
                  BoxConstraints(minWidth: constraints.maxWidth / 2.05),
              isSelected: [
                controller.value == Unit.Scouts,
                controller.value == Unit.Guides
              ],
              onPressed: (int value) {
                switch (value) {
                  case 0:
                    controller.value = Unit.Scouts;
                    break;
                  case 1:
                    controller.value = Unit.Guides;
                    break;
                }
              },
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(ScoutSpiritIcons.fleur_de_lis,
                          color: controller.value == Unit.Scouts
                              ? selectedColor
                              : unselectedColor),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text('Tropa',
                          style: TextStyle(fontFamily: 'Ubuntu').copyWith(
                              color: controller.value == Unit.Scouts
                                  ? selectedColor
                                  : unselectedColor)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(ScoutSpiritIcons.trebol,
                          color: controller.value == Unit.Guides
                              ? selectedColor
                              : unselectedColor),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text('Compañía',
                          style: TextStyle(fontFamily: 'Ubuntu').copyWith(
                              color: controller.value == Unit.Guides
                                  ? selectedColor
                                  : unselectedColor)),
                    ],
                  ),
                )
              ],
            );
          })),
    );
  }

  Future<void> _register(BuildContext context) async {
    setState(() {
      this.loading = true;
    });
    SignUpCredentials credentials = form.credentials;
    bool errored = false;
    try {
      errored = !await AuthenticationService().register(
          email: credentials.email,
          password: credentials.password,
          nickname: credentials.nickname,
          name: credentials.name,
          lastName: credentials.lastName,
          birthDate: credentials.birthDate,
          unit: credentials.unit);
    } on UsernameExistsException {
      SnackBarProvider.showMessage(
          context, 'Un usuario con este correo ya existe', color: appTheme.errorColor, gravity: ToastGravity.TOP);
      errored = true;
    }

    if (errored) {
      setState(() {
        this.loading = false;
      });
    } else {
      await Navigator.of(context)
          .pushReplacementNamed('/confirm', arguments: credentials.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _cancel,
      child: Scaffold(
          body: Stack(
        children: [
          Background(),
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
                child: Container(
                    padding: EdgeInsets.only(top: 24.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.white70, blurRadius: 12.0)
                        ]),
                    child: _buildLoginForm(context, disabled: loading)),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _continue() {
    if (_currentStep == 0) {
      if (_credentialsFormKey.currentState!.validate()) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else {
      if (_basicDataFormKey.currentState!.validate() &&
          form.unitController.value != null) {
        _register(context);
      } else {
        setState(() {
          triedToValidateDate = true;
        });
      }
    }
  }

  Future<bool> _cancel() async {
    if (_currentStep == 0) {
      bool response = await SnackBarProvider.showConfirmAlert(
          context, '¿Seguro que quieres cancelar el registro?');
      if (response) {
        Navigator.pop(context);
      }
      return response;
    }
    setState(() {
      _currentStep = 0;
    });
    return false;
  }
}
