import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';

class AreaDisplayData {
  final IconData icon;
  final Color color;
  final DevelopmentArea area;

  String get name => _areaNames[area]!;

  AreaDisplayData(
      {required this.icon, required this.color, required this.area});
}

final Map<DevelopmentArea, String> _areaNames = {
  DevelopmentArea.Corporality: "Corporalidad",
  DevelopmentArea.Creativity: "Creatividad",
  DevelopmentArea.Character: "Carácter",
  DevelopmentArea.Affectivity: "Afectividad",
  DevelopmentArea.Sociability: "Sociabilidad",
  DevelopmentArea.Spirituality: "Espiritualidad"
};

final Map<DevelopmentArea, AreaDisplayData> _scoutIcons = {
  DevelopmentArea.Corporality: AreaDisplayData(
      icon: ScoutSpiritIcons.corporality_1,
      color: Colors.blueAccent,
      area: DevelopmentArea.Corporality),
  DevelopmentArea.Creativity: AreaDisplayData(
      icon: ScoutSpiritIcons.creativity_1,
      color: Colors.pink,
      area: DevelopmentArea.Creativity),
  DevelopmentArea.Character: AreaDisplayData(
      icon: ScoutSpiritIcons.character_1,
      color: Colors.lightBlueAccent,
      area: DevelopmentArea.Character),
  DevelopmentArea.Affectivity: AreaDisplayData(
      icon: ScoutSpiritIcons.affectivity_1,
      color: Colors.red[500]!,
      area: DevelopmentArea.Affectivity),
  DevelopmentArea.Sociability: AreaDisplayData(
      icon: ScoutSpiritIcons.sociability_1,
      color: Colors.black,
      area: DevelopmentArea.Sociability),
  DevelopmentArea.Spirituality: AreaDisplayData(
      icon: ScoutSpiritIcons.spirituality_1,
      color: Colors.lightGreen,
      area: DevelopmentArea.Spirituality),
};

final Map<DevelopmentArea, AreaDisplayData> _guidesIcons = {
  DevelopmentArea.Corporality: AreaDisplayData(
      icon: ScoutSpiritIcons.corporality,
      color: Colors.lightGreen,
      area: DevelopmentArea.Corporality),
  DevelopmentArea.Creativity: AreaDisplayData(
      icon: ScoutSpiritIcons.creativity,
      color: Colors.deepOrange,
      area: DevelopmentArea.Creativity),
  DevelopmentArea.Character: AreaDisplayData(
      icon: ScoutSpiritIcons.character,
      color: Colors.white,
      area: DevelopmentArea.Character),
  DevelopmentArea.Affectivity: AreaDisplayData(
      icon: ScoutSpiritIcons.affectivity,
      color: Colors.white,
      area: DevelopmentArea.Affectivity),
  DevelopmentArea.Sociability: AreaDisplayData(
      icon: ScoutSpiritIcons.sociability,
      color: Colors.white,
      area: DevelopmentArea.Sociability),
  DevelopmentArea.Spirituality: AreaDisplayData(
      icon: ScoutSpiritIcons.spirituality,
      color: Colors.white,
      area: DevelopmentArea.Spirituality),
};

class ObjectivesDisplay {
  static AreaDisplayData getAreaIconData(Unit unit, DevelopmentArea area) {
    switch (unit) {
      case Unit.Guides:
        return _guidesIcons[area]!;
      case Unit.Scouts:
        return _scoutIcons[area]!;
    }
  }

  static List<AreaDisplayData> getUnitAreasIconData(Unit unit) {
    return DevelopmentArea.values
        .map((area) => getAreaIconData(unit, area))
        .toList();
  }

  static List<AreaDisplayData> getUserAreasIconData(User user) {
    return getUnitAreasIconData(user.unit);
  }

  static AreaDisplayData getUserAreaIconData(User user, DevelopmentArea area) {
    return getAreaIconData(user.unit, area);
  }
}
