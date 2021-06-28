class Group {
  String district;
  String code;
  String name;

  Group.fromMap(Map<String, dynamic> map)
      : district = map["district"],
        code = map["code"],
        name = map["name"];

  @override
  String toString() {
    return "Group(district: $district, code: $code, name: '$name')";
  }
}
