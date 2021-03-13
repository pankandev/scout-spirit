import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/services/districts.dart';
import 'package:scout_spirit/src/services/groups.dart';
import 'package:scout_spirit/src/widgets/active_task_container.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => BeneficiariesService()),
        Provider(create: (_) => GroupsService()),
        Provider(create: (_) => DistrictsService()),
        Provider(create: (_) => AuthenticationService()),
      ],
      child: Scaffold(
        body: _buildBody(context),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(30, 30, 30, 1),
          unselectedItemColor: Colors.white,
          onTap: (index) => _onTap(context, index),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(label: 'Grupo', icon: Icon(Icons.group)),
            BottomNavigationBarItem(
                label: '¡Explorar!', icon: Icon(ScoutSpiritIcons.campfire)),
            BottomNavigationBarItem(
                label: 'Bitácora', icon: Icon(ScoutSpiritIcons.fleur_de_lis)),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int button) {
    if (button == 1) {
      Navigator.of(context).pushNamed('/explore');
    }
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(),
        SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _buildUserContainer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_outlined,
                              color: Color.fromRGBO(255, 255, 255, 0.8)),
                          onPressed: () => _logout(context),
                        ),
                        Text(
                          'Espíritu Scout',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    ActiveTaskContainer()
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _buildUserContainer() {
    return Container(
      height: 64.0,
      child: StreamBuilder<User>(
          stream: AuthenticationService().userStream,
          builder: (context, snapshot) => Container(
                child: snapshot.hasData
                    ? Column(
                        children: [Text(snapshot.data.beneficiary.fullName)],
                      )
                    : CircularProgressIndicator(),
              )),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await AuthenticationService().logout();
    await Navigator.of(context).pushReplacementNamed('/login');
  }
}
