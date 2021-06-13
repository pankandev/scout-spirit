import 'package:flutter/material.dart';
import 'package:scout_spirit/src/themes/theme.dart';

class TaskEditDialogue extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 21.0, horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    controller: _controller,
                    maxLines: 4,
                    style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[700],
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16.0)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                    maxLength: 120,
                    validator: (value) {
                      if (value == null || value.length > 120) {
                        return "La tarea no puede tener más de 120 carácteres";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RawMaterialButton(
                    onPressed: () => _submit(context),
                    fillColor: appTheme.primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    Navigator.pop(context, _controller.text);
  }
}
