class District {
  String code;
  String name;

  District({required this.code, required this.name});

  District.fromMap(Map<String, dynamic> map)
      : code = map["code"],
        name = map["name"];

  @override
  String toString() {
    return "District(code: $code, name: $name)";
  }
}
