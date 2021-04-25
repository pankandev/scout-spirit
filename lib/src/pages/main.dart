import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/providers/confirm_provider.dart';
import 'package:scout_spirit/src/services/districts.dart';
import 'package:scout_spirit/src/services/groups.dart';
import 'package:scout_spirit/src/widgets/active_task_container.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/reward_overlay.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: RewardOverlay(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildUserContainer(context),
                      MainDivider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Objetivo personal'),
                          SizedBox(
                            height: 10.0,
                          ),
                          ActiveTaskContainer()
                        ],
                      ),
                      MainDivider(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildUserContainer(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthenticationService().userStream,
        builder: (context, snapshot) {
          Beneficiary? beneficiary = snapshot.data?.beneficiary;
          return Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: snapshot.hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 102,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(51),
                            child: FutureBuilder<Beneficiary?>(
                                future:
                                    BeneficiariesService().getMyself(),
                                builder: (context, snapshot) {
                                  String placeholderPath =
                                      'assets/imgs/avatar.png';
                                  String? data = snapshot.data?.profilePicture;
                                  return data != null
                                      ? FadeInImage(
                                          image: NetworkImage(data),
                                          placeholder:
                                              AssetImage(placeholderPath))
                                      : Image.asset(placeholderPath);
                                })),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        beneficiary!.nickname,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.white24),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.transparent),
                            side: MaterialStateProperty.resolveWith(
                                (states) => BorderSide(color: Colors.white))),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/profile'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            'Editar perfil',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      if (beneficiary.setBaseTasks == null ||
                          !beneficiary.setBaseTasks!)
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.redAccent)),
                            onPressed: () async {
                              bool result = await ConfirmProvider.askConfirm(
                                  context,
                                  question: '¿Estás listo?',
                                  content:
                                      'Para marcar los objetivos iniciales te recomendamos haber conversado sobre esto con tu guiadora o dirigente.');
                              if (result) {
                                Navigator.of(context).pushNamed('/initialize');
                              }
                            },
                            child:
                                Text('No has indicado tus objetivos iniciales'),
                          ),
                        )
                    ],
                  )
                : CircularProgressIndicator(),
          );
        });
  }

  Future<void> _refresh() async {
    await AuthenticationService().updateAuthenticatedUser();
  }
}

class MainDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      child: Divider(
        height: 10.0,
        thickness: 0.8,
        color: Colors.white.withAlpha(128),
      ),
    );
  }
}
