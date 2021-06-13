import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/scout_spirit_icons_icons.dart';

class AreaDisplayData {
  final IconData icon;
  final ColorScheme colorScheme;
  final DevelopmentArea area;

  String get name => _areaNames[area]!;

  const AreaDisplayData(
      {required this.icon, required this.colorScheme, required this.area});

  Color get color => colorScheme.primary;

  Color get accentColor => colorScheme.secondary;

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
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(117, 15, 246, 1),
          secondary: Color.fromRGBO(0, 48, 217, 1)),
      area: DevelopmentArea.Corporality),
  DevelopmentArea.Creativity: AreaDisplayData(
      icon: ScoutSpiritIcons.creativity_1,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(255, 94, 148, 1),
          secondary: Color.fromRGBO(240, 0, 115, 1)),
      area: DevelopmentArea.Creativity),
  DevelopmentArea.Character: AreaDisplayData(
      icon: ScoutSpiritIcons.character_1,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(113, 195, 255, 1),
          secondary: Color.fromRGBO(48, 205, 255, 1)),
      area: DevelopmentArea.Character),
  DevelopmentArea.Affectivity: AreaDisplayData(
      icon: ScoutSpiritIcons.affectivity_1,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(255, 17, 0, 1),
          secondary: Color.fromRGBO(255, 111, 111, 1)),
      area: DevelopmentArea.Affectivity),
  DevelopmentArea.Sociability: AreaDisplayData(
      icon: ScoutSpiritIcons.sociability_1,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(0, 0, 0, 1),
          secondary: Color.fromRGBO(65, 65, 65, 1)),
      area: DevelopmentArea.Sociability),
  DevelopmentArea.Spirituality: AreaDisplayData(
      icon: ScoutSpiritIcons.spirituality_1,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(15, 246, 66, 1),
          secondary: Color.fromRGBO(18, 244, 231, 1)),
      area: DevelopmentArea.Spirituality),
};

final Map<DevelopmentArea, AreaDisplayData> _guidesIcons = {
  DevelopmentArea.Corporality: AreaDisplayData(
      icon: ScoutSpiritIcons.corporality,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(111, 207, 52, 1),
          secondary: Color.fromRGBO(76, 167, 19, 1.0)),
      area: DevelopmentArea.Corporality),
  DevelopmentArea.Creativity: AreaDisplayData(
      icon: ScoutSpiritIcons.creativity,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(243, 115, 43, 1),
          secondary: Color.fromRGBO(243, 163, 43, 1.0)),
      area: DevelopmentArea.Creativity),
  DevelopmentArea.Character: AreaDisplayData(
      icon: ScoutSpiritIcons.character,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(146, 59, 137, 1),
          secondary: Color.fromRGBO(210, 106, 198, 1.0)),
      area: DevelopmentArea.Character),
  DevelopmentArea.Affectivity: AreaDisplayData(
      icon: ScoutSpiritIcons.affectivity,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(107, 217, 214, 1),
          secondary: Color.fromRGBO(40, 155, 152, 1.0)),
      area: DevelopmentArea.Affectivity),
  DevelopmentArea.Sociability: AreaDisplayData(
      icon: ScoutSpiritIcons.sociability,
      colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(240, 217, 97, 1),
          secondary: Color.fromRGBO(222, 145, 60, 1.0)),
      area: DevelopmentArea.Sociability),
  DevelopmentArea.Spirituality: AreaDisplayData(
      icon: ScoutSpiritIcons.spirituality,
      colorScheme: ColorScheme.dark(
        primary: Color.fromRGBO(15, 93, 137, 1),
        secondary: Color.fromRGBO(33, 128, 191, 1.0),
      ),
      area: DevelopmentArea.Spirituality),
};

class ObjectivesDisplay {
  static AreaDisplayData defaultDisplayData = AreaDisplayData(
      icon: Icons.help,
      colorScheme: appTheme.colorScheme,
      area: DevelopmentArea.Corporality);

  static AreaDisplayData getAreaIconData(Unit unit, DevelopmentArea? area) {
    switch (unit) {
      case Unit.Guides:
        return _guidesIcons[area] ?? defaultDisplayData;
      case Unit.Scouts:
        return _scoutIcons[area] ?? defaultDisplayData;
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
