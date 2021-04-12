import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';

class AreaDisplayData {
  final IconData icon;
  final ColorScheme colorScheme;
  final DevelopmentArea area;

  String get name => _areaNames[area]!;

  AreaDisplayData(
      {required this.icon, required this.colorScheme, required this.area});

  Color get color => colorScheme.primary;

  Color get disabledColor {
    int average = (0.9 * (color.red + color.green + color.blue) / 3).round();
    if (average == 0) {
      average = 32;
    }
    return Color.fromARGB(255, average, average, average);
  }
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
      colorScheme: ColorScheme.dark(primary: Colors.blueAccent),
      area: DevelopmentArea.Corporality),
  DevelopmentArea.Creativity: AreaDisplayData(
      icon: ScoutSpiritIcons.creativity_1,
      colorScheme: ColorScheme.dark(primary: Colors.pink),
      area: DevelopmentArea.Creativity),
  DevelopmentArea.Character: AreaDisplayData(
      icon: ScoutSpiritIcons.character_1,
      colorScheme: ColorScheme.dark(primary: Colors.lightBlueAccent),
      area: DevelopmentArea.Character),
  DevelopmentArea.Affectivity: AreaDisplayData(
      icon: ScoutSpiritIcons.affectivity_1,
      colorScheme: ColorScheme.dark(primary: Colors.red[500]!),
      area: DevelopmentArea.Affectivity),
  DevelopmentArea.Sociability: AreaDisplayData(
      icon: ScoutSpiritIcons.sociability_1,
      colorScheme: ColorScheme.dark(primary: Colors.black),
      area: DevelopmentArea.Sociability),
  DevelopmentArea.Spirituality: AreaDisplayData(
      icon: ScoutSpiritIcons.spirituality_1,
      colorScheme: ColorScheme.dark(primary: Colors.lightGreen),
      area: DevelopmentArea.Spirituality),
};

final Map<DevelopmentArea, AreaDisplayData> _guidesIcons = {
  DevelopmentArea.Corporality: AreaDisplayData(
      icon: ScoutSpiritIcons.corporality,
      colorScheme: ColorScheme.dark(primary: Colors.lightGreen),
      area: DevelopmentArea.Corporality),
  DevelopmentArea.Creativity: AreaDisplayData(
      icon: ScoutSpiritIcons.creativity,
      colorScheme: ColorScheme.dark(primary: Colors.deepOrange),
      area: DevelopmentArea.Creativity),
  DevelopmentArea.Character: AreaDisplayData(
      icon: ScoutSpiritIcons.character,
      colorScheme: ColorScheme.dark(primary: Colors.white),
      area: DevelopmentArea.Character),
  DevelopmentArea.Affectivity: AreaDisplayData(
      icon: ScoutSpiritIcons.affectivity,
      colorScheme: ColorScheme.dark(primary: Colors.white),
      area: DevelopmentArea.Affectivity),
  DevelopmentArea.Sociability: AreaDisplayData(
      icon: ScoutSpiritIcons.sociability,
      colorScheme: ColorScheme.dark(primary: Colors.white),
      area: DevelopmentArea.Sociability),
  DevelopmentArea.Spirituality: AreaDisplayData(
      icon: ScoutSpiritIcons.spirituality,
      colorScheme: ColorScheme.dark(primary: Colors.white),
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
