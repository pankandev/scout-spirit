import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/objectives.dart';
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
        CombineLatestStream.combine2<DevelopmentArea?, User, List<Objective>>(
            areaController.stream.startWith(null),
            stageStream,
            (area, user) => area != null
                ? ObjectivesService().getAllByArea(user.stage, area)
                : ObjectivesService().getAllByStage(user.stage));
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
  final Stream<List<Objective>> objectives;
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

  Padding _buildSearchField() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: widget.searchController,
          style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
          cursorColor: Colors.white,
          decoration: InputDecoration(
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(32.0)),
              fillColor: Colors.white12,
              focusColor: Colors.transparent,
              suffixIcon: ProviderConsumer<TextEditingValue>(
                  controller: widget.searchController,
                  builder: (search) {
                    return search.value.text.isEmpty
                        ? Icon(Icons.search, color: Colors.white)
                        : IconButton(
                            onPressed: () => widget.searchController.text = "",
                            icon: Icon(Icons.clear, color: Colors.white));
                  })),
        ));
  }

  DevelopmentStage get stage =>
      AuthenticationService().snapAuthenticatedUser!.stage;

  Unit get unit => AuthenticationService().snapAuthenticatedUser!.unit;

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
          padding: EdgeInsets.all(12.0),
          shape:
              CircleBorder(side: BorderSide(color: Colors.white, width: 2.0)),
          child: Icon(
            area != null ? display.icon : Icons.all_inclusive,
            size: 32.0,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          area != null ? display.name : 'Cualquier área',
          style: TextStyle(color: Colors.white, fontFamily: 'UbuntuCondensed'),
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
                        child: _buildAreaFilterButton(area,
                            isActive: snapshot.data == area)))
                    .toList());
          }),
    );
  }

  Widget _buildCardList() {
    return StreamBuilder<List<Objective>>(
        stream: widget.objectives,
        builder: (context, snapshot) {
          return ProviderConsumer(
              controller: widget.searchController,
              builder: (_) {
                Iterable<Objective>? objectives = snapshot.data != null
                    ? snapshot.data!.where((element) => element.rawObjective.toLowerCase()
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
                        thickness: 16.0,
                        radius: Radius.circular(24),
                        isAlwaysShown: true,
                        child: ListView.builder(
                          controller: widget.scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 21.0),
                          itemCount: areas.length,
                          itemBuilder: (context, index) {
                            DevelopmentArea area = areas[index];
                            AreaDisplayData areaDisplay =
                                ObjectivesDisplay.getAreaIconData(
                                    AuthenticationService()
                                        .snapAuthenticatedUser!
                                        .unit,
                                    area);
                            List<Line> lines = grouped[area]!;
                            return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, top: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0, bottom: 12.0),
                                      child: Text(
                                        areaDisplay.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'ConcertOne',
                                            fontSize: 24.0),
                                      ),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: lines.length,
                                        itemBuilder: (context, index) {
                                          DevelopmentStage stage =
                                              AuthenticationService()
                                                  .snapAuthenticatedUser!
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
                                                    fontFamily: 'Ubuntu'),
                                              ),
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                              ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: line
                                                      .objectives[stage]!
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Objective objective =
                                                        line.objectives[stage]![
                                                            index];
                                                    return Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 14.0,
                                                                top: 6.0),
                                                        child: ObjectiveCard(
                                                          objective: objective,
                                                          onSelect: widget
                                                                      .onChange !=
                                                                  null
                                                              ? () => widget
                                                                      .onChange!(
                                                                  objective)
                                                              : null,
                                                        ));
                                                  }),
                                            ],
                                          );
                                        }),
                                  ],
                                ));
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

  Widget _buildTitle() {
    return HeaderBack(
      onBack: widget.onBack,
      label: 'Enfócate',
    );
  }
}
