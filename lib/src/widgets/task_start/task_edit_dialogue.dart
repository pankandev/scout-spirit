import 'package:flutter/material.dart';
import 'package:scout_spirit/src/themes/theme.dart';

class TaskEditDialogue extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Card(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 21.0, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Editar tarea', style: appTheme.textTheme.headline2, textAlign: TextAlign.start,),
                    SizedBox(height: 8.0,),
                    Text('Escribe algo específico que quieras hacer para este objetivo', style: appTheme.textTheme.caption, textAlign: TextAlign.start,),
                    TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      controller: _controller,
                      maxLines: 4,
                      maxLength: 120,
                      validator: (value) {
                        if (value.length > 120) {
                          return "La tarea no puede tener más de 120 carácteres";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0,),
                    RaisedButton(onPressed: () => _submit(context), color: Colors.lightBlue, child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Guardar', style: TextStyle(color: Colors.white),),
                        SizedBox(width: 10.0,),
                        Icon(Icons.arrow_forward, color: Colors.white)
                      ],
                    ),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    Navigator.pop(context, _controller.text);
  }
}
