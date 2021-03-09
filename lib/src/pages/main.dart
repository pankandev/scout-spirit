import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/widgets/active_task_container.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => BeneficiariesService())
      ],
      child: Scaffold(
        body: _buildBody(context),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(30, 30, 30, 1),
          unselectedItemColor: Colors.white,
          onTap: _onTap,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(label: 'Grupo', icon: Icon(Icons.group)),
            BottomNavigationBarItem(label: '¡Explorar!', icon: Icon(ScoutSpiritIcons.campfire)),
            BottomNavigationBarItem(label: 'Bitácora', icon: Icon(ScoutSpiritIcons.fleur_de_lis)),
          ],
        ),
      ),
    );
  }

  void _onTap(int button) {
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.arrow_back_outlined, color: Color.fromRGBO(255, 255, 255, 0.8)), onPressed: () {  },),
                  Text('Espíritu Scout', style: TextStyle(color: Colors.white),)
                ],
              ),
              ActiveTaskContainer()
            ],
          ),
        )
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    await Amplify.Auth.signOut();
    await Navigator.of(context).pushReplacementNamed('/login');
  }
}
