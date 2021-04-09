import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_spirit/src/forms/task_start.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/widgets/task_start/objectives_list.dart';
import 'package:scout_spirit/src/widgets/task_start/personal_objective_form.dart';
import 'package:scout_spirit/src/widgets/task_start/tasks_form.dart';
import 'package:scout_spirit/src/services/tasks.dart';

class TaskStartFormPage extends StatefulWidget {
  final DevelopmentArea area;

  TaskStartFormPage({required this.area});

  @override
  _TaskStartFormPageState createState() => _TaskStartFormPageState();
}

class _TaskStartFormPageState extends State<TaskStartFormPage> {
  final PageController pageController = PageController();

  int page = 0;

  int _formId = 0;
  bool loading = false;

  AreaDisplayData get areaData => ObjectivesDisplay.getAreaIconData(
      AuthenticationService().snapAuthenticatedUser!.unit, widget.area);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Row(
                children: [
                  Text(areaData.name),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(areaData.icon),
                ],
              ),
              backgroundColor: areaData.color,
              actions: [
                StreamBuilder(
                    stream: form.stateStream,
                    builder: (context, snapshot) {
                      int? page = pageController.page?.round();
                      return page != null && page > 0
                          ? IconButton(
                              onPressed: readyToContinue && !loading
                                  ? _onSubmit
                                  : null,
                              icon: Icon(Icons.check),
                            )
                          : Container();
                    })
              ]),
          body: _buildBody(context),
        ));
  }

  bool get readyToContinue {
    switch (pageController.page!.round()) {
      case 1:
        return form.personalObjective != null &&
            form.personalObjective!.rawObjective != '';
      case 2:
        bool isAnyTaskEmpty = !form.tasks.fold(
            true,
            (previousValue, element) =>
                previousValue && element.description != '');
        return form.tasks.length > 0 && !isAnyTaskEmpty;
    }
    return false;
  }

  TaskStartForm form = TaskStartForm();

  Widget _buildBody(BuildContext context) {
    return Provider(
      create: (BuildContext context) => form,
      child: Stack(
        children: [
          Container(),
          Positioned(
            right: -100.0,
            bottom: -100.0,
            child: Transform.rotate(
              angle: -3.14 / 5.0,
              child: Container(
                width: 360,
                height: 360,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    areaData.icon,
                    color: areaData.color.withAlpha(186),
                  ),
                ),
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: _buildForm(context))
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: 3,
        itemBuilder: (context, page) {
          switch (page) {
            case 0:
              return ObjectivesList(
                area: widget.area,
                onChange: (objective) {
                  form.originalObjective = objective;
                  goToPage(1);
                },
              );
            case 1:
              return KeyedSubtree(
                  key: ValueKey<int>(_formId), child: PersonalObjectiveForm());
            case 2:
              return KeyedSubtree(
                  key: ValueKey<int>(_formId), child: TasksForm());
          }
          return Container();
        });
  }

  Future<bool> _onBackPressed() async {
    if (pageController.page! > 0) {
      goToPage(pageController.page!.round() - 1);
      return false;
    }
    return true;
  }

  void _onSubmit() {
    if (pageController.page! < 2) {
      goToPage(pageController.page!.round() + 1);
    } else {
      _submit();
    }
  }

  void goToPage(int destiny) async {
    _unFocus();
    await pageController.animateToPage(destiny,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOutCubic);
    if (destiny == 0) {
      form.clear();
      setState(() {
        _formId++;
      });
    }
  }

  void _unFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Future<void> _submit() async {
    setState(() {
      loading = true;
    });
    bool errored = false;
    try {
      await TasksService().startObjective(form.personalObjective!, form.tasks);
    } catch (e) {
      errored = true;
      setState(() {
        loading = false;
      });
      throw e;
    }
    if (!errored) {
      Navigator.of(context).pop();
    }
  }
}
