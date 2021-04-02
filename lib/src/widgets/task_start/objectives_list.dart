import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/objectives.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/widgets/objective_card.dart';

class ObjectivesList extends StatefulWidget {
  const ObjectivesList({Key? key, required this.area, this.onChange})
      : super(key: key);

  final DevelopmentArea area;
  final Function(Objective objective)? onChange;

  @override
  _ObjectivesListState createState() => _ObjectivesListState();
}

class _ObjectivesListState extends State<ObjectivesList> {
  TextEditingController _searchController = new TextEditingController();
  List<Objective>? filteredObjectives;

  @override
  void initState() {
    super.initState();
    _loadObjectives();
  }

  AreaDisplayData get areaData => ObjectivesDisplay.getAreaIconData(
      AuthenticationService().snapAuthenticatedUser!.unit, widget.area);

  void _loadObjectives() {
    User user = AuthenticationService().snapAuthenticatedUser!;
    List<Objective> objectives =
    ObjectivesService().getAllByArea(user.stage, widget.area);
    if (_searchController.value.text != '') {
      objectives = objectives
          .where((element) => element.rawObjective
          .toLowerCase()
          .contains(_searchController.text))
          .toList();
    }
    setState(() {
      filteredObjectives = objectives;
    });
  }

  @override
  Widget build(BuildContext context) {
    return filteredObjectives == null
        ? Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(areaData.color)))
        : Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => _loadObjectives(),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26)),
                focusColor: Colors.white,
                suffixIcon: Icon(Icons.search, color: Colors.black26),
                counterText: _searchController.text == ''
                    ? ' '
                    : 'Filtrando por: ${_searchController.text}'),
          ),
          Expanded(child: _buildCardList()),
        ],
      ),
    );
  }

  ListView _buildCardList() {
    return ListView.builder(
      itemCount: filteredObjectives!.length,
      itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ObjectiveCard(
                objective: filteredObjectives![index],
                onSelect: widget.onChange != null ? () => widget.onChange!(filteredObjectives![index]) : null,
              ))),
    );
  }
}
