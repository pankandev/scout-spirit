import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
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

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int currentPage = _pageController.page!.round();
        if (currentPage == 0) return true;
        await _pageController.animateToPage(currentPage - 1,
            duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
            child: SignUpForm(pageController: _pageController)),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final PageController pageController;

  SignUpForm({required this.pageController});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool loading = false;

  bool wasEmailTouched = false;

  bool wasPasswordTouched = false;

  final GlobalKey<FormState> _credentialsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _basicDataFormKey = GlobalKey<FormState>();

  final RegisterFormBloc form = RegisterFormBloc();

  Widget _buildLoginForm(BuildContext context, {bool disabled = false}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: PageView(
            controller: widget.pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildCredentialsPage(context, disabled: disabled),
              _buildBasicDataPage(context, disabled: disabled),
            ]),
      ),
    );
  }

  Widget _buildCredentialsPage(BuildContext context, {bool disabled = false}) {
    return Form(
        key: _credentialsFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 36.0),
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
                      _buildConfirmPasswordField(disabled: disabled),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 36.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_credentialsFormKey.currentState!.validate()) {
                            goToPage(1);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Continuar'),
                            Icon(Icons.arrow_right_alt_sharp)
                          ],
                        )),
                  ],
                ))
          ],
        ));
  }

  Future<void> goToPage(int page) async {
    await widget.pageController.animateToPage(page,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  Widget _buildBasicDataPage(BuildContext context, {bool disabled = false}) {
    return Form(
      key: _basicDataFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 36.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    _buildDatePicker(disabled: disabled),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildUnitPicker(disabled: disabled)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 36.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                    onPressed: !loading
                        ? () {
                            if (_basicDataFormKey.currentState!.validate() && form.unitController.value != null) {
                              _register(context);
                            } else {
                              setState(() {
                                triedToValidate = true;
                              });
                            }
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Crear cuenta'),
                        Icon(Icons.arrow_right_alt_sharp)
                      ],
                    )),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          )
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
        validator: (String? value) {
          if (value == null ||value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          if (value.length < 6) {
            return 'La contraseña debe tener al menos 6 carácteres';
          }

          bool containsNumber = RegExp('[0-9]').hasMatch(value);
          bool containsUppercase = RegExp('[A-Z]').hasMatch(value);
          bool containsLowercase = RegExp('[a-z]').hasMatch(value);

          if (!containsNumber || !containsUppercase || !containsLowercase) {
            return 'La contraseña debe tener un número, mayúsculas y minúsculas';
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
        autocorrect: false,
        decoration: InputDecoration(
            labelText: 'Repetir contraseña', suffixIcon: Icon(Icons.https)),
        validator: (String? value) {
          if (value == null ||value.isEmpty) {
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
        decoration: InputDecoration(
          labelText: 'Correo',
          suffixIcon: Icon(Icons.alternate_email),
        ),
        validator: (String? value) {
          if (value == null ||value.isEmpty) {
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
        decoration: InputDecoration(
          labelText: 'Apellidos',
          suffixIcon: Icon(Icons.person),
        ),
        validator: (String? value) {
          if (value == null ||value.isEmpty) {
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
        validator: (String? value) {
          if (value == null ||value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        });
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
            decoration: InputDecoration(
              labelText: 'Fecha de nacimiento',
              suffixIcon: Icon(Icons.date_range),
            ),
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

  bool triedToValidate = false;

  Widget _buildUnitPicker({bool disabled = false}) {
    return ProviderConsumer<Unit?>(
      controller: form.unitController,
      builder: (controller) => InputDecorator(
        decoration: InputDecoration(
            labelText: 'Unidad',
            errorText: !triedToValidate || form.unitController.value != null
                ? null
                : 'Este campo es obligatorio',
            border: InputBorder.none),
        child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile<Unit?>(
                value: Unit.Scouts,
                groupValue: controller.value,
                onChanged: (Unit? value) => form.unitController.value = value,
                title: Row(
                  children: [
                    Icon(ScoutSpiritIcons.fleur_de_lis,
                        color: appTheme.textTheme.caption!.color),
                    SizedBox(width: 10.0),
                    Text('Tropa', style: appTheme.textTheme.caption),
                  ],
                ),
              ),
              RadioListTile<Unit>(
                value: Unit.Guides,
                groupValue: controller.value,
                onChanged: (Unit? value) {
                  form.unitController.value = value;
                },
                title: Row(
                  children: [
                    Icon(ScoutSpiritIcons.trebol,
                        color: appTheme.textTheme.caption!.color),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('Compañía', style: appTheme.textTheme.caption),
                  ],
                ),
              ),
            ]),
      ),
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
          context, 'Un usuario con este correo ya existe');
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
    return _buildLoginForm(context, disabled: loading);
  }
}
