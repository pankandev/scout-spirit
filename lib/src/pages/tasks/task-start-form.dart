import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listenable_stream/listenable_stream.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/forms/task_start.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/task_start/objectives_list.dart';
import 'package:scout_spirit/src/widgets/task_start/personal_objective_form.dart';
import 'package:scout_spirit/src/widgets/task_start/tasks_form.dart';
import 'package:scout_spirit/src/services/tasks.dart';

class _InstructionStep {
  final String title;
  final String instruction;
  final String? tip;

  _InstructionStep({required this.title, required this.instruction, this.tip});
}

List<_InstructionStep> instructions = <_InstructionStep>[
  _InstructionStep(
      title: 'Enfócate',
      instruction:
          'Elige aquel objetivo en el que quieras enfocarte en trabajar desde ahora hasta que lo completes',
      tip: null),
  _InstructionStep(
      title: 'Hazlo tuyo',
      instruction:
          'Genial! Ahora adapta este objetivo a algo más acorde a lo que te gustaría realizar en base a tu personalidad e intereses,  sin perder la esencia del original.\n\n'
          'Puedes ser tan abstracto o concreto como desees (dentro del límite de carácteres 😬)',
      tip: 'Sería ideal que converses sobre esto con tu dirigente'),
  _InstructionStep(
      title: 'Concrétalo',
      instruction:
          'Ahora define qué tareas quieres realizar, que dirías que, una vez completadas, es porque ya completaste este objetivo.',
      tip: 'Sería ideal que converses sobre esto con tu dirigente')
];

class TaskStartFormPage extends StatefulWidget {
  TaskStartFormPage();

  @override
  _TaskStartFormPageState createState() => _TaskStartFormPageState();
}

class _TaskStartFormPageState extends State<TaskStartFormPage> {
  final PageController pageController = PageController();

  bool _validateTasks(List<SubTask> tasks) {
    return tasks.length > 0 &&
        tasks.fold(
            true,
            (previousValue, element) =>
                previousValue && element.description != '');
  }

  bool _validatePersonalObjective(Objective objective) {
    return objective.rawObjective.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    page$ = pageController
        .toStream()
        .map((event) => event.page?.round() ?? 0)
        .startWith(0);
    readyToContinue$ = CombineLatestStream.combine3<bool, bool, int, bool?>(
        form.personalObjectiveStream
            .map((event) => _validatePersonalObjective(event))
            .startWith(false),
        form.tasksStream.map((event) => _validateTasks(event)).startWith(false),
        page$, (focusValidation, tasksValidation, page) {
      print(page);
      switch (page) {
        case 3:
          return focusValidation;
        case 5:
          return tasksValidation;
      }
      return null;
    });
  }

  late final Stream<int> page$;

  late final Stream<bool?> readyToContinue$;

  int page = 0;

  int _formId = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: _buildBody(context),
        ));
  }

  TaskStartForm form = TaskStartForm();

  Widget _buildBody(BuildContext context) {
    return Provider(
      create: (BuildContext context) => form,
      child: Stack(
        children: [
          Background(
              primary: Color.fromRGBO(140, 92, 250, 1.0),
              secondary: appTheme.accentColor),
          SafeArea(
            child: _buildForm(context),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 64.0,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: StreamBuilder<bool?>(
                    stream: readyToContinue$,
                    builder: (context, snapshot) {
                      bool showButton = snapshot.data != null;
                      bool disabled = !(snapshot.data ?? false) || loading;
                      return showButton
                          ? RawMaterialButton(
                              fillColor: disabled
                                  ? Colors.grey[800]!.withOpacity(0.4)
                                  : Colors.grey[800],
                              splashColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  side: BorderSide.none),
                              onPressed: disabled ? null : _onSubmit,
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Continuar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19.0,
                                        fontFamily: 'Ubuntu'),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )
                                ],
                              ))
                          : Container();
                    })),
          )
        ],
      ),
    );
  }

  Widget _buildInstructionsPage(int step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Paso ${step + 1}",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'UbuntuCondensed',
              fontSize: 16.0),
        ),
        Hero(
          tag: "step $step title",
          child: Text(
            instructions[step].title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 32.0, fontFamily: 'ConcertOne'),
          ),
        ),
        SizedBox(
          height: 24.0,
        ),
        Text(
          instructions[step].instruction,
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: Colors.white, fontSize: 14.0, fontFamily: 'Ubuntu'),
        ),
        SizedBox(
          height: 16.0,
        ),
        if (instructions[step].tip != null)
          Text(
            'Tip: ${instructions[step].tip}',
            textAlign: TextAlign.justify,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w600),
          ),
        SizedBox(
          height: 48.0,
        ),
        RawMaterialButton(
            onPressed: () => goToPage(step * 2 + 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(color: Colors.white, width: 2.0)),
            splashColor: Colors.white12,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 21.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Entendido!',
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Ubuntu')),
                  SizedBox(
                    width: 24.0,
                  ),
                  Text('👌'),
                ],
              ),
            ))
      ]),
    );
  }

  Widget _buildForm(BuildContext context) {
    return PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: 6,
        itemBuilder: (context, page) {
          switch (page) {
            case 0:
              return _buildInstructionsPage(0);
            case 1:
              return StartFormObjectivesList(
                onBack: () => goToPage(0),
                onChange: (objective) {
                  form.originalObjective = objective;
                  goToPage(2);
                },
              );
            case 2:
              return _buildInstructionsPage(1);
            case 3:
              return KeyedSubtree(
                  key: ValueKey<int>(_formId),
                  child: PersonalObjectiveForm(
                    onBack: () => goToPage(2),
                  ));
            case 4:
              return _buildInstructionsPage(2);
            case 5:
              return KeyedSubtree(
                  key: ValueKey<int>(_formId), child: TasksForm(onBack: () => goToPage(4),));
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
    if (pageController.page! < 5) {
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
    } catch (e, s) {
      errored = true;
      setState(() {
        loading = false;
      });
      print(s);
      throw e;
    }
    if (!errored) {
      Navigator.of(context).pop();
    }
  }
}
