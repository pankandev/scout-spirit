import 'package:flutter/material.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class ConfirmPage extends StatefulWidget {
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  final TextEditingController _codeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          SingleChildScrollView(
            child: SafeArea(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Colors.white70, blurRadius: 12.0)
                          ]),
                      padding: EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 36.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '¡Ya casi estás!',
                              style: appTheme.textTheme.headline1,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                                'Revisa tu correo electrónico por el código para confirmar tu cuenta'),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              autofocus: true,
                              validator: (value) {
                                if (value?.isEmpty ?? false) {
                                  return 'Este campo es obligatorio';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Código de confirmación',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  hintText: '123456',
                                  border: OutlineInputBorder()),
                              controller: _codeController,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            RawMaterialButton(
                                fillColor: appTheme.primaryColor
                                    .withOpacity(loading ? 0.7 : 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0)),
                                onPressed:
                                    !loading ? () => _confirm(context) : null,
                                child: Text(
                                  'Confirmar cuenta',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      )),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    String email = ModalRoute.of(context)!.settings.arguments! as String;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    bool confirmed = await AuthenticationService()
        .confirm(email, _codeController.text.trim());
    setState(() {
      loading = false;
    });
    if (!confirmed) {
      SnackBarProvider.showMessage(context, 'Código incorrecto');
    } else {
      Navigator.of(context).pop();
    }
  }
}
