import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/services/districts.dart';
import 'package:scout_spirit/src/services/groups.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/widgets/scout_button.dart';
import 'package:scout_spirit/src/widgets/active_task_container.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/reward_overlay.dart';
import 'package:scout_spirit/src/widgets/icon_tooltip.dart';
import 'package:scout_spirit/src/widgets/scout_outlined_button.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => BeneficiariesService()),
        Provider(create: (_) => GroupsService()),
        Provider(create: (_) => DistrictsService()),
        Provider(create: (_) => AuthenticationService()),
      ],
      child: WillPopScope(
        onWillPop: () async => SnackBarProvider.showConfirmAlert(
            context, '¿Seguro que quieres salir?',
            okLabel: 'Salir 🚪'),
        child: Scaffold(
          body: Stack(children: [
            _buildBody(context),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: _buildPlayButton(context)),
            )
          ]),
        ),
      ),
    );
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(),
        RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 136.0),
              child: SafeArea(
                child: RewardOverlay(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 4.0,
                      ),
                      _buildHeader(context),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildUserContainer(context),
                      SizedBox(
                        height: 16.0,
                      ),
                      StreamBuilder<User?>(
                          stream: AuthenticationService().userStream,
                          builder: (context, snapshot) {
                            bool? initialized =
                                snapshot.data?.beneficiary?.setBaseTasks;
                            return initialized != null && !initialized
                                ? _buildAlert(
                                    context, snapshot.data!.beneficiary!)
                                : Container();
                          }),
                      SizedBox(
                        height: 23.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildSubHeader('Objetivo en progreso',
                              tooltip:
                                  'Tu objetivo en progreso corresponde a aquel objetivo en el que estás trabajando actualmente'),
                          SizedBox(
                            height: 24.0,
                          ),
                          ActiveTaskContainer()
                        ],
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      _buildSubHeader('Qué te gustaría ver?'),
                      SizedBox(
                        height: 24.0,
                      ),
                      ScoutOutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/binnacle'),
                        label: 'Bitácora',
                        labelSize: 21.0,
                        icon: Icons.book_outlined,
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 21.0),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      ScoutOutlinedButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/stats'),
                        label: 'Estadísticas',
                        labelSize: 21.0,
                        icon: Icons.insights,
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 21.0),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      ScoutOutlinedButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/logs'),
                        label: 'Registros',
                        labelSize: 21.0,
                        icon: Icons.account_tree_outlined,
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 21.0),
                      ),
                      _buildCredits()
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

  Widget _buildSubHeader(String title, {String? tooltip}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'ConcertOne',
                fontSize: 22.0),
          ),
        ),
        if (tooltip != null) IconTooltip(tooltip)
      ],
    );
  }

  Widget _buildAlert(BuildContext context, Beneficiary beneficiary) {
    return ScoutButton(
        label:
            'No has indicado tus objetivos logrados. Presiona aquí para indicarlos',
        icon: Icons.warning_amber_rounded,
        iconSize: 48.0,
        fillColor: appTheme.errorColor,
        accentColor: Colors.pink,
        labelColor: Colors.white,
        spreadRadius: 1.0,
        shadowAlpha: 0.2,
        onPressed: () async {
          bool result = await SnackBarProvider.showConfirmAlert(
              context, 'Estás listo?',
              icon: Icons.error,
              body:
                  'Para marcar los objetivos ya cumplidos deberías ponerte de acuerdo con tu guiadora o dirigente.\n\nSi ya lo hiciste, puedes continuar',
              color: Colors.blueAccent);
          if (result) {
            Navigator.of(context).pushNamed('/initialize');
          }
        });
  }

  Widget _buildUserContainer(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthenticationService().userStream,
        builder: (context, snapshot) {
          Beneficiary? beneficiary = snapshot.data?.beneficiary;
          return Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
            padding: EdgeInsets.only(bottom: 8.0, right: 18.0, left: 6.0),
            child: snapshot.hasData
                ? Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 8,
                        child: _buildProfilePicture(),
                      ),
                      SizedBox(
                        width: 24.0,
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¡Buenos días!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'UbuntuCondensed'),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              beneficiary!.nickname,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontFamily: 'ConcertOne'),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ScoutButton(
                                label: 'Editar ávatar',
                                fillColor: Colors.white,
                                blurRadius: 8.0,
                                labelSize: 17.0,
                                shadowAlpha: 0.22,
                                accentColor: Color.lerp(Colors.white,
                                    Color.fromRGBO(93, 36, 255, 1), 0.2)!,
                                labelColor: Color.fromRGBO(93, 36, 255, 1),
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/profile')),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              '${beneficiary.totalScore} puntos',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'ConcertOne'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
          );
        });
  }

  Widget _buildProfilePicture() {
    return Container(
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(color: Color.fromRGBO(52, 97, 255, 1), blurRadius: 12.0)
      ], shape: BoxShape.circle, color: Colors.white),
      child: ClipOval(
        child: FutureBuilder<Beneficiary?>(
            future: BeneficiariesService().getMyself(),
            builder: (context, snapshot) {
              String placeholderPath = 'assets/imgs/default_profile.jpg';
              String? data = snapshot.data?.profilePicture;
              return data != null
                  ? FadeInImage(
                      image: NetworkImage(data),
                      placeholder: AssetImage(placeholderPath))
                  : Image.asset(placeholderPath);
            }),
      ),
    );
  }

  Future<void> _refresh() async {
    await AuthenticationService().updateAuthenticatedUser();
  }

  Widget _buildPlayButton(BuildContext context) {
    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: Axis.vertical,
      children: [
        Flexible(
            flex: 1,
            child: Text(
              'Ir al mundo',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ConcertOne',
                  fontSize: 19.0,
                  shadows: [Shadow(color: Colors.white, blurRadius: 5.0)]),
            )),
        SizedBox(
          height: 12.0,
        ),
        Flexible(
          flex: 7,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 255, 163, 1).withAlpha(128),
                  blurRadius: 6.0,
                  spreadRadius: 6.0),
            ]),
            child: RawMaterialButton(
                shape: CircleBorder(),
                fillColor: Colors.transparent,
                splashColor: Colors.white24,
                highlightColor: Colors.white60,
                elevation: 0.0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          center: Alignment(0.8, -0.8),
                          radius: 1.0,
                          colors: [
                            Color.fromRGBO(0, 255, 163, 1),
                            Color.fromRGBO(0, 209, 255, 1)
                          ]),
                      shape: BoxShape.circle),
                  child: StreamBuilder<User?>(
                      stream: AuthenticationService().userStream,
                      builder: (context, snapshot) {
                        User? user = snapshot.data;
                        return Icon(
                          user == null
                              ? ScoutSpiritIcons.fleur_de_lis
                              : (user.unit == Unit.Scouts
                                  ? ScoutSpiritIcons.fleur_de_lis
                                  : ScoutSpiritIcons.trebol),
                          color: Colors.white,
                          size: 48.0,
                        );
                      }),
                ),
                onPressed: () => Navigator.of(context).pushNamed('/explore')),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RawMaterialButton(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            highlightColor: Colors.transparent,
            onPressed: () async {
              bool result = await SnackBarProvider.showConfirmAlert(
                  context, '¿Seguro que quieres cerrar sesión?',
                  color: Colors.blueAccent,
                  okLabel: 'Sí',
                  cancelLabel: 'Cancelar');
              if (result) {
                AuthenticationService().logout();
                await Navigator.of(context).pushReplacementNamed('/');
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Cerrar sesión',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'ConcertOne',
                      fontSize: 16.0),
                ),
                SizedBox(
                  width: 9.0,
                ),
                Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 21.0,
                )
              ],
            ))
      ],
    );
  }

  Widget _buildCredits() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Créditos',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 21.0,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 21.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipOval(
                child: Container(
                    width: 81.0,
                    height: 81.0,
                    child: Image(image: AssetImage('assets/imgs/spiral.jpg'))))
          ]),
          SizedBox(
            height: 8.0,
          ),
          Flexible(
            child: Column(
              children: [
                Text(
                  'Desarrollado por',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
                ),
                Text(
                  'Paths Ankan',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Ubuntu'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 21.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Personaje por',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Ubuntu'),
                      ),
                      Text(
                        'Frano\n@franopx',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Ubuntu'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Modelos por',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Ubuntu'),
                      ),
                      Text(
                        'Nanchark\n@nanchark',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Ubuntu'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
