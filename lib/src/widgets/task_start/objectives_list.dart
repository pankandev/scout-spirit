import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/objectives.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/themes/constants.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/development_stage.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';
import 'package:scout_spirit/src/widgets/objective_card.dart';

class StartFormObjectivesList extends StatefulWidget {
  StartFormObjectivesList._internal(
      {Key? key,
      this.onBack,
      this.onChange,
      required this.areaController,
      required this.objectives})
      : super(key: key);

  factory StartFormObjectivesList(
      {Key? key, Function(Objective objective)? onChange, Function()? onBack}) {
    // ignore: close_sinks
    final areaController = BehaviorSubject<DevelopmentArea?>();
    final stageStream = AuthenticationService()
        .userStream
        .where((user) => user != null)
        .map((event) => event!);
    final objectives =
        CombineLatestStream.combine2<DevelopmentArea?, User, List<Objective>?>(
                areaController.stream.startWith(null),
                stageStream,
                (area, user) => (area != null
                    ? ObjectivesService().getAllByArea(user.stage, area)
                    : ObjectivesService().getAllByStage(user.stage)))
            .asyncMap((objectives) async {
      List<Task> tasks = await TasksService().getMyTasks();
      return objectives
          ?.where((objective) => !tasks.fold(false,
              (prev, task) => prev || task.originalObjective == objective))
          .toList();
    });
    return StartFormObjectivesList._internal(
        onBack: onBack,
        onChange: onChange,
        areaController: areaController,
        objectives: objectives);
  }

  DevelopmentArea? get area => areaController.value;

  final void Function()? onBack;
  final void Function(Objective objective)? onChange;
  final BehaviorSubject<DevelopmentArea?> areaController;
  final Stream<List<Objective>?> objectives;
  final TextEditingController searchController = new TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  _StartFormObjectivesListState createState() =>
      _StartFormObjectivesListState();

  void dispose() {
    areaController.close();
  }
}

class _StartFormObjectivesListState extends State<StartFormObjectivesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        _buildAreaFilters(),
        _buildSearchField(),
        Expanded(child: _buildCardList()),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
        padding: Paddings.container,
        child: TextField(
          controller: widget.searchController,
          style: TextStyles.inputLight,
          cursorColor: Colors.white,
          decoration: InputDecoration(
              filled: true,
              contentPadding: Paddings.input,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none, borderRadius: BorderRadii.max),
              fillColor: Colors.white12,
              focusColor: Colors.transparent,
              suffixIcon: ProviderConsumer<TextEditingValue>(
                  controller: widget.searchController,
                  builder: (search) {
                    return search.value.text.isEmpty
                        ? Icon(Icons.search,
                            color: Colors.white, size: IconSizes.medium)
                        : IconButton(
                            onPressed: () => widget.searchController.text = "",
                            icon: Icon(Icons.clear,
                                color: Colors.white, size: IconSizes.medium));
                  })),
        ));
  }

  DevelopmentStage get stage => AuthenticationService().authenticatedUser.stage;

  Unit get unit => AuthenticationService().authenticatedUser.unit;

  Widget _buildAreaFilterButton(DevelopmentArea? area,
      {bool isActive = false}) {
    AreaDisplayData display = ObjectivesDisplay.getAreaIconData(unit, area);
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RawMaterialButton(
          onPressed: isActive ? null : () => widget.areaController.add(area),
          fillColor: isActive ? display.color : Colors.transparent,
          splashColor: display.accentColor,
          elevation: 0,
          disabledElevation: 0,
          padding: EdgeInsets.all(Dimensions.large),
          shape: CircleBorder(
              side:
              BorderSide(color: Colors.white, width: Dimensions.xsmall)),
          child: Icon(
            area != null ? display.icon : Icons.all_inclusive,
            size: IconSizes.large,
            color: Colors.white,
          ),
        ),
        VSpacings.small,
        Text(
          area != null ? display.name : 'Cualquier área',
          style: TextStyles.muted
              .copyWith(color: Colors.white, fontFamily: 'UbuntuCondensed'),
        )
      ],
    );
  }

  Widget _buildAreaFilters() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: StreamBuilder<DevelopmentArea?>(
          stream: widget.areaController,
          builder: (ctx, snapshot) {
            List<DevelopmentArea?> areas = <DevelopmentArea?>[null]
              ..addAll(DevelopmentArea.values);
            return Row(
                mainAxisSize: MainAxisSize.min,
                children: areas
                    .map((area) => Flexible(
                    child: Padding(
                      padding: Paddings.containerTight,
                      child: _buildAreaFilterButton(area,
                          isActive: snapshot.data == area),
                    )))
                    .toList());
          }),
    );
  }

  Widget _buildCardList() {
    return StreamBuilder<List<Objective>?>(
        stream: widget.objectives,
        builder: (context, snapshot) {
          return ProviderConsumer(
              controller: widget.searchController,
              builder: (_) {
                Iterable<Objective>? objectives = snapshot.data != null
                    ? snapshot.data!.where((element) => element.rawObjective
                    .toLowerCase()
                    .contains(widget.searchController.text))
                    : null;
                Map<DevelopmentArea, List<Line>>? grouped = objectives != null
                    ? ObjectivesService().groupObjectives(objectives.toList())
                    : null;
                List<DevelopmentArea> areas = DevelopmentArea.values
                    .where((area) => grouped?.containsKey(area) ?? false)
                    .toList();
                return grouped != null
                    ? Scrollbar(
                  controller: widget.scrollController,
                  thickness: Dimensions.large,
                  radius: Radii.max,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: widget.scrollController,
                    padding: Paddings.containerFluid,
                    itemCount: areas.length,
                    itemBuilder: (context, index) {
                      DevelopmentArea area = areas[index];
                      AreaDisplayData areaDisplay =
                      ObjectivesDisplay.getAreaIconData(
                          AuthenticationService()
                              .authenticatedUser
                              .unit,
                          area);
                      List<Line> lines = grouped[area]!;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: Paddings.label,
                            child: Text(
                              areaDisplay.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'ConcertOne',
                                  fontSize: FontSizes.xlarge),
                            ),
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: lines.length,
                              itemBuilder: (context, index) {
                                DevelopmentStage stage =
                                    AuthenticationService()
                                        .authenticatedUser
                                        .stage;
                                Line line = lines[index];
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "${line.index + 1}. ${line.name}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: FontSizes.medium,
                                          fontFamily: 'Ubuntu'),
                                    ),
                                    VSpacings.large,
                                    ListView.builder(
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: line
                                            .objectives[stage]!.length,
                                        itemBuilder: (context, index) {
                                          Objective objective =
                                          line.objectives[stage]![
                                          index];
                                          return _buildObjectiveCard(
                                              context, objective);
                                        }),
                                  ],
                                );
                              }),
                        ],
                      );
                    },
                  ),
                )
                    : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ));
              });
        });
  }

  Widget _buildObjectiveCard(BuildContext context, Objective objective) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: Paddings.bottom,
        child: ObjectiveCard(
          objective: objective,
          onSelect: widget.onChange != null
              ? () => widget.onChange!(objective)
              : null,
        ));
  }

  Widget _buildTitle() {
    return HeaderBack(
      onBack: widget.onBack,
      label: 'Enfócate',
    );
  }
}
