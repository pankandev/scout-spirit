import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/models/avatar.dart';
import 'package:scout_spirit/src/providers/loading_screen.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/avatar.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/unity/unity_controller.dart';
import 'package:scout_spirit/src/utils/advanced_page_controller.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/page_view_input.dart';
import 'package:scout_spirit/src/widgets/screenshot_display.dart';
import 'package:scout_spirit/src/widgets/unity_app.dart';
import 'package:scout_spirit/src/widgets/avatar_part.dart';

class _PartTypeDisplay {
  final String name;
  final IconData icon;

  _PartTypeDisplay(this.name, this.icon);
}

final Map<AvatarPartEnum, _PartTypeDisplay> categories = {
  AvatarPartEnum.PANTS:
      _PartTypeDisplay("Cambiar pantalones", Icons.account_box),
  AvatarPartEnum.SHIRT: _PartTypeDisplay("Cambiar polera", Icons.account_box),
  AvatarPartEnum.MOUTH: _PartTypeDisplay("Cambiar boca", Icons.theater_comedy),
  AvatarPartEnum.LEFT_EYE:
      _PartTypeDisplay("Cambiar ojo izquierdo", Icons.visibility),
  AvatarPartEnum.RIGHT_EYE:
      _PartTypeDisplay("Cambiar ojo derecho", Icons.visibility),
  AvatarPartEnum.NECKERCHIEF:
      _PartTypeDisplay("Cambiar pañoleta", ScoutSpiritIcons.fleur_de_lis),
};

final Map<AvatarPartEnum, String> categoriesTitles = {
  AvatarPartEnum.PANTS: "Editando pantalones...",
  AvatarPartEnum.SHIRT: "Editando polera...",
  AvatarPartEnum.MOUTH: "Editando boca...",
  AvatarPartEnum.LEFT_EYE: "Editando ojo izquierdo...",
  AvatarPartEnum.RIGHT_EYE: "Editando ojo derecho...",
  AvatarPartEnum.NECKERCHIEF: "Editando pañoleta..."
};

class ProfilePage extends StatefulWidget {
  final GameController controller = GameController();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FocusNode textFocus = new FocusNode();

  late final Stream<List<AvatarPart>>? availableParts;
  AvatarPartEnum? partType;

  @override
  void initState() {
    super.initState();
    AvatarService().updateAvailableAvatarRewards();
    widget.controller.on('getAvatar', getAvatar);
    widget.controller.on('getScreenshot', _getScreenshot);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    availableParts = null;
  }

  void dispose() {
    super.dispose();
    widget.controller.off();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<Map<String, dynamic>?> getAvatar(
      Map<String, dynamic>? arguments) async {
    LoadingScreenProvider().show(context, label: "Cargando avatar...");
    try {
      Avatar avatar = await AvatarService().getAuthenticatedAvatar();
      LoadingScreenProvider().hide();
      loadInitialValues(avatar);
      return avatar.toMap();
    } catch (e) {
      LoadingScreenProvider().hide();
      Navigator.pop(context);
      return null;
    }
  }

  Future<void> _save() async {
    setState(() {
      touched = false;
    });
    try {
      await AvatarService().updateAuthenticatedAvatar();
    } catch (e) {
      setState(() {
        touched = true;
      });
    }
  }

  bool touched = false;
  static int profileIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Ávatar'), actions: [
        IconButton(icon: Icon(Icons.save), onPressed: touched ? _save : null),
        IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => GameController().takeScreenshot("image_${profileIndex++}.png")),
      ]),
      floatingActionButton: SpeedDial(
        children: categories.keys.map((e) {
          _PartTypeDisplay displayData = categories[e]!;
          bool disabled = partType == e;
          return SpeedDialChild(
              elevation: 0.0,
              backgroundColor: Colors.white,
              label: disabled ? 'Cerrar editor' : displayData.name,
              child: Icon(disabled ? Icons.close : displayData.icon,
                  color: appTheme.primaryColor),
              onTap: () {
                _switchEditMode(disabled ? null : e);
              });
        }).toList(),
        activeBackgroundColor: appTheme.primaryColor,
        backgroundColor: appTheme.primaryColor,
        icon: Icons.edit,
        activeIcon: Icons.close,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(children: [
          Background(),
          UnityApp(
            controller: widget.controller,
            initialSceneName: 'Avatar',
            fullscreen: false,
          ),
          _buildUserNickname(),
          if (partType != null) _buildCurrentPartSelector()
        ]),
      ),
    );
  }

  Widget _buildUserNickname() {
    return StreamBuilder<User?>(
      stream: AuthenticationService().userStream,
      builder: (context, snapshot) => Align(
        alignment: Alignment.topCenter,
        child: snapshot.hasData
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    snapshot.data!.nickname,
                    style: TextStyle(
                        fontSize: 48.0,
                        fontFamily: 'ConcertOne',
                        color: Colors.white),
                  ),
                  SizedBox(height: 16.0,),
                  if (partType != null)
                    Text(
                      categoriesTitles[partType!]!,
                      style: TextStyle(
                          fontSize: 21.0,
                          fontFamily: 'Ubuntu',
                          color: Colors.white),
                    ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
      ),
    );
  }

  Map<AvatarPartEnum, ValueNotifier<AvatarPart?>> partControllers = {
    AvatarPartEnum.LEFT_EYE: ValueNotifier<AvatarEye?>(null),
    AvatarPartEnum.RIGHT_EYE: ValueNotifier<AvatarEye?>(null),
    AvatarPartEnum.MOUTH: ValueNotifier<AvatarMouth?>(null),
    AvatarPartEnum.SHIRT: ValueNotifier<AvatarShirt?>(null),
    AvatarPartEnum.PANTS: ValueNotifier<AvatarPants?>(null),
    AvatarPartEnum.NECKERCHIEF: ValueNotifier<AvatarNeckerchief?>(null),
  };

  ValueNotifier<T> getPartController<T extends AvatarPart?>(
      AvatarPartEnum part) {
    return partControllers[part]! as ValueNotifier<T>;
  }

  void _switchEditMode(AvatarPartEnum? avatarPartEnum) {
    setState(() {
      partType = avatarPartEnum;
    });
  }

  Widget _buildCurrentPartSelector() {
    switch (partType!) {
      case AvatarPartEnum.LEFT_EYE:
        return _buildPartSelector<AvatarEye>();
      case AvatarPartEnum.RIGHT_EYE:
        return _buildPartSelector<AvatarEye>();
      case AvatarPartEnum.NECKERCHIEF:
        return _buildPartSelector<AvatarNeckerchief>();
      case AvatarPartEnum.SHIRT:
        return _buildPartSelector<AvatarShirt>();
      case AvatarPartEnum.PANTS:
        return _buildPartSelector<AvatarPants>();
      case AvatarPartEnum.MOUTH:
        return _buildPartSelector<AvatarMouth>();
    }
  }

  Future<void> loadInitialValues(Avatar avatar) async {
    for (AvatarPartEnum type in AvatarPartEnum.values) {
      switch (type) {
        case AvatarPartEnum.LEFT_EYE:
          getPartController(type).value = avatar.leftEye;
          break;
        case AvatarPartEnum.RIGHT_EYE:
          getPartController(type).value = avatar.rightEye;
          break;
        case AvatarPartEnum.NECKERCHIEF:
          getPartController(type).value = avatar.neckerchief;
          break;
        case AvatarPartEnum.SHIRT:
          getPartController(type).value = avatar.shirt;
          break;
        case AvatarPartEnum.PANTS:
          getPartController(type).value = avatar.pants;
          break;
        case AvatarPartEnum.MOUTH:
          getPartController(type).value = avatar.mouth;
          break;
      }
    }
  }

  Widget _buildPartSelector<T extends AvatarPart>() {
    return AvatarPartSelector<T>(
        key: Key(partType.toString()),
        type: partType!,
        onChange: () => setState(() => touched = true),
        controller: getPartController<T>(partType!));
  }

  Future<Map<String, dynamic>?> _getScreenshot(
      Map<String, dynamic>? map) async {
    String? path = map?["filepath"];
    if (path == null) return null;
    Uri myUri = Uri.parse(path);
    File imageFile = new File.fromUri(myUri);
    dynamic croppedFile = await showDialog(
        context: context,
        builder: (context) => ScreenshotDisplay(
              screenshot: imageFile,
            ));
    if (croppedFile is File) {
      BeneficiariesService().uploadProfilePicture(croppedFile);
    }
  }
}

class AvatarPartSelector<T extends AvatarPart> extends StatefulWidget {
  final AvatarPartEnum type;
  final ValueNotifier<T> controller;
  final void Function()? onChange;

  AvatarPartSelector(
      {Key? key, required this.type, required this.controller, this.onChange})
      : super(key: key);

  @override
  _AvatarPartSelectorState createState() {
    return _AvatarPartSelectorState<T>();
  }
}

class _AvatarPartSelectorState<T extends AvatarPart>
    extends State<AvatarPartSelector> {
  final AdvancedPageController _partController = new AdvancedPageController();

  static int lastViewIndex = 0;
  late final int viewIndex;

  late final Stream<List<T?>> optionsStream;

  @override
  void initState() {
    super.initState();
    viewIndex = lastViewIndex++;
    optionsStream = getOptionsStream(partOptionsType)
        .transform(StreamTransformer.fromHandlers(handleData: (options, sink) {
      sink.add(<T?>[null] + options);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment(0.0, 0.9),
        child: StreamBuilder<List<T?>>(
            stream: optionsStream,
            builder: (context, snapshot) {
              List<T?>? options = snapshot.data;
              return options == null
                  ? Container()
                  : _buildSelector(context, options);
            }));
  }

  int get currentItem => _partController.page!.round();

  Stream<List<T>> getOptionsStream(AvatarRewardType type) {
    Stream<List<T>> options =
        AvatarService().getAvailableAvatarRewardsByType<T>();
    return options;
  }

  AvatarRewardType get partOptionsType {
    switch (widget.type) {
      case AvatarPartEnum.LEFT_EYE:
        return AvatarRewardType.EYE;
      case AvatarPartEnum.RIGHT_EYE:
        return AvatarRewardType.EYE;
      case AvatarPartEnum.NECKERCHIEF:
        return AvatarRewardType.NECKERCHIEF;
      case AvatarPartEnum.SHIRT:
        return AvatarRewardType.SHIRT;
      case AvatarPartEnum.PANTS:
        return AvatarRewardType.PANTS;
      case AvatarPartEnum.MOUTH:
        return AvatarRewardType.MOUTH;
    }
  }

  Future<void> goToItem(int item) async {
    if (_partController.hasClients) {
      await _partController.animateToPage(item,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  Container _buildSelector(BuildContext context, List<T?> options) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.2),
      child: _buildPartPageView(options),
    );
  }

  Widget _buildPartPageView(List<T?> options) {
    return PageViewInput<T?>(
      key: Key(viewIndex.toString()),
      options: options,
      physics: BouncingScrollPhysics(),
      controller: widget.controller as ValueNotifier<T>,
      counterBuilder: (int index, int total) => Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 32.0),
        child: Text(
          "${index + 1}/$total",
          style: TextStyle(color: Colors.black),
        ),
      ),
      onChange: (newPart) async {
        Avatar updated =
            AvatarService().changeAvatarClothes(widget.type, newPart);
        GameController().changeAvatarClothes("Character", updated);
        if (widget.onChange != null) {
          widget.onChange!();
        }
      },
      builder: (BuildContext context, AvatarPart? part) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AvatarPartCard(part: part),
      ),
    );
  }
}
