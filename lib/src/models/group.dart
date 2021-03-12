class Group {
  String code;
  String name;

  Group.fromMap(Map<String, dynamic> map)
      : code = map["code"],
        name = map["name"];

  @override
  String toString() {
    return "Group(code: $code, name: '$name')";
  }
}
