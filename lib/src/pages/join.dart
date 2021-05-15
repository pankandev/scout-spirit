import 'package:flutter/material.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class JoinPage extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          SafeArea(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group,
                        size: 56.0,
                        color: Colors.white,
                      ),
                      Text(
                        'Unirse a un grupo',
                        style: TextStyle(
                            fontFamily: 'ConcertOne',
                            fontSize: 26.0,
                            color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Colors.white, blurRadius: 12.0)
                          ]),
                      child: JoinGroupForm(codeController: codeController)),
                ]),
          )),
        ],
      ),
    );
  }
}

class JoinGroupForm extends StatefulWidget {
  JoinGroupForm({
    Key? key,
    required this.codeController,
  }) : super(key: key);

  final TextEditingController codeController;

  @override
  _JoinGroupFormState createState() => _JoinGroupFormState();
}

class _JoinGroupFormState extends State<JoinGroupForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Código de grupo',
                style:
                    TextStyle(color: Colors.black87, fontFamily: 'UbuntuCondensed'),
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: !loading,
                    controller: widget.codeController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Este campo es obligatorio'
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Código de grupo',
                        border: OutlineInputBorder()),
                  ),
                ),
                TextButton(
                    child: Icon(Icons.arrow_right_alt_sharp),
                    onPressed: loading ? null : () => _joinGroup(context))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinGroup(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        await BeneficiariesService().joinGroup(widget.codeController.text);
        await Navigator.of(context).pushReplacementNamed('/');
      } on HttpError catch (e) {
        if (e.statusCode == 403 || e.statusCode == 404) {
          SnackBarProvider.showMessage(context, 'Código Incorrecto');
        } else if (e.statusCode == 400) {
          SnackBarProvider.showMessage(context, 'Ya te has unido a un grupo');
          await Navigator.of(context).pushReplacementNamed('/');
        } else {
          SnackBarProvider.showMessage(context, 'Error desconocido');
        }
      } on AppError {
        SnackBarProvider.showMessage(context, 'Código Incorrecto');
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }
}
