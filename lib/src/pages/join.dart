import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/district.dart';
import 'package:scout_spirit/src/models/group.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/services/groups.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  late final Future<List<District>> districts;

  Stream<DistrictModel>? selectedDistrict;
  Group? selectedGroup;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    districts = GroupsService().getAllDistricts();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Background(),
            SafeArea(
                child: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.group,
                    size: 56.0,
                    color: Colors.white,
                  ),
                  Text(
                    'Unirse a un grupo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'ConcertOne',
                        fontSize: 26.0,
                        color: Colors.white),
                  ),
                  Expanded(
                      child: PageView.builder(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            switch (index) {
                              case 0:
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child:
                                      _buildDistrictsList(onSelect: _onSelect),
                                );
                              case 1:
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: _buildGroupsList(),
                                );
                              case 2:
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: _buildCodeForm(),
                                );
                              default:
                                throw new AppError(
                                    message: 'Unknown page index $index');
                            }
                          }))
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          children: [
            StreamBuilder<District>(
                stream: selectedDistrict,
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: Colors.white, blurRadius: 12.0)
                              ]),
                          child: JoinGroupForm(
                              district: snapshot.data!, group: selectedGroup!))
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildDistrictsList({void Function(District district)? onSelect}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Busca el distrito de tu grupo',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<District>>(
              future: districts,
              builder: (context, snapshot) {
                List<District>? data = snapshot.data;
                return Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: data != null
                        ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: data.length + 1,
                            itemBuilder: (context, index) => index < data.length
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: _buildDistrictListTile(data[0],
                                        onTap: onSelect != null
                                            ? () => onSelect(data[0])
                                            : null),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0, vertical: 13.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        color: Colors.amber.withOpacity(0.4),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'No hay más distritos registrados en la plataforma todavía',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Ubuntu'),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.warning_amber_rounded,
                                                color: Colors.white,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white))));
              }),
        ),
      ],
    );
  }

  Widget _buildDistrictListTile(District district, {void Function()? onTap}) {
    BorderRadius borderRadius = BorderRadius.circular(24.0);
    return AspectRatio(
      aspectRatio: 2.4,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1],
                    colors: [Colors.white24, Colors.white54])),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Text(
                    district.name,
                    style: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 23.0,
                        fontFamily: 'Ubuntu'),
                  ),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                  size: 36.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onGroupSelect(Group? group) async {
    if (group != null) {
      await goToPage(2);
      setState(() {
        selectedGroup = group;
      });
    } else {
      await goToPage(1);
      selectedGroup = null;
    }
  }

  Future<void> _onSelect(District? district) async {
    if (district != null) {
      await goToPage(1);
      setState(() {
        selectedDistrict = GroupsService().getDistrictStream(district.code);
      });
      await GroupsService().updateDistrictStream(district.code);
    } else {
      await goToPage(0);
      selectedDistrict = null;
    }
  }

  Future<void> goToPage(int page) async {
    await _pageController.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.bounceOut);
  }

  Future<bool> _onPop() async {
    int page = _pageController.page?.round() ?? 0;
    if (page <= 0) {
      return await SnackBarProvider.showConfirmAlert(
          context, 'Seguro que quieres salir?');
    }
    await goToPage(page - 1);
    return false;
  }

  Widget _buildGroupsList() {
    return StreamBuilder<DistrictModel>(
        stream: selectedDistrict,
        builder: (context, snapshot) {
          DistrictModel? data = snapshot.data;
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('¡Busca tu grupo en el distrito! 😀',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Ubuntu')),
                      if (data != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            '${data.name}',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w600,
                                fontSize: 21.0),
                          ),
                        )
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: data != null
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: data.groups.length + 1,
                                itemBuilder: (context, index) => index <
                                        data.groups.length
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: _buildGroupListTile(
                                            data.groups[0],
                                            onTap: () =>
                                                _onGroupSelect(data.groups[0])),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0, vertical: 13.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            color:
                                                Colors.amber.withOpacity(0.4),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  'No hay más grupos registrados en este distrito todavía',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Ubuntu'),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Icon(
                                                    Icons.warning_amber_rounded,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white)))))
              ]);
        });
  }

  Widget _buildGroupListTile(Group group, {void Function()? onTap}) {
    BorderRadius borderRadius = BorderRadius.circular(24.0);
    return AspectRatio(
      aspectRatio: 3.1,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1],
                    colors: [Colors.white24, Colors.white54])),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 23.0,
                        fontFamily: 'Ubuntu'),
                  ),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                  size: 36.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JoinGroupForm extends StatefulWidget {
  final District district;
  final Group group;

  JoinGroupForm({Key? key, required this.district, required this.group})
      : super(key: key);

  final TextEditingController codeController = TextEditingController();

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
        padding: const EdgeInsets.symmetric(horizontal: 31.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 36.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 21.0, left: 24.0, right: 24.0),
              child: Text(
                'Ingresa la contraseña de tu grupo',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 18,
                    fontWeight: FontWeight.w200),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Esta contraseña debe ser entregada por tu guiadora o dirigente',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 15,
                    fontWeight: FontWeight.w200),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                enabled: !loading,
                controller: widget.codeController,
                autofocus: false,
                validator: (value) => value == null || value.isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
                readOnly: true,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => JoinCodePage(
                          controller: widget.codeController,
                          district: widget.district,
                          group: widget.group));
                },
                style: codeStyle,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    labelText: 'Contraseña de grupo',
                    labelStyle: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 17.0,
                        letterSpacing: 1.3),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3.0),
                        borderRadius: BorderRadius.circular(24.0))),
              ),
            ),
            RawMaterialButton(
                fillColor: loading
                    ? appTheme.primaryColor.withOpacity(0.8)
                    : appTheme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '¡Unirse!',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                onPressed: loading
                    ? null
                    : () => _joinGroup(context, widget.district, widget.group))
          ],
        ),
      ),
    );
  }

  Future<void> _joinGroup(
      BuildContext context, District district, Group group) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        await BeneficiariesService()
            .joinGroup(district, group, widget.codeController.text);
        await Navigator.of(context).pushReplacementNamed('/');
      } on HttpError catch (e) {
        if (e.statusCode == 403 || e.statusCode == 404) {
          SnackBarProvider.showMessage(context, 'Código Incorrecto',
              color: appTheme.errorColor);
        } else if (e.statusCode == 400) {
          SnackBarProvider.showMessage(context, 'Ya te has unido a un grupo',
              color: appTheme.primaryColor);
          await Navigator.of(context).pushReplacementNamed('/');
        } else {
          SnackBarProvider.showMessage(context, 'Error desconocido',
              color: appTheme.errorColor);
        }
      } on AppError {
        SnackBarProvider.showMessage(context, 'Código Incorrecto',
            color: appTheme.errorColor);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }
}

class JoinCodePage extends StatefulWidget {
  final TextEditingController controller;
  final District district;
  final Group group;

  JoinCodePage(
      {Key? key,
      required this.controller,
      required this.district,
      required this.group})
      : super(key: key);

  @override
  _JoinCodePageState createState() => _JoinCodePageState();
}

class _JoinCodePageState extends State<JoinCodePage> {
  final FocusNode node = FocusNode();

  @override
  void initState() {
    super.initState();
    node.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    node.removeListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
          fillColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          alignLabelWithHint: true,
        ),
        textAlign: TextAlign.center,
        maxLength: 9,
        style: codeStyle,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        autofocus: true,
        focusNode: node,
      ),
    );
  }

  void _onFocusChange() {
    if (!node.hasPrimaryFocus) {
      Navigator.pop(context);
    }
  }
}
