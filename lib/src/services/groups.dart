import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/district.dart';
import 'package:scout_spirit/src/models/group.dart';
import 'package:scout_spirit/src/services/rest_api.dart';

class GroupsService extends RestApiService {
  final String _apiPath = 'api';

  final Map<String, BehaviorSubject<DistrictModel>> _districtsCache = {};

  static final GroupsService _instance = GroupsService._internal();

  factory GroupsService() {
    return _instance;
  }

  GroupsService._internal();

  Future<List<DistrictModel>> getAllDistricts() async {
    List<dynamic> items = (await this.get("$_apiPath/districts/"))["items"];
    List<DistrictModel> districts =
        items.map((e) => DistrictModel.fromMap(e)).toList();
    districts.sort((a, b) => a.name.compareTo(b.name));
    return districts;
  }

  Future<District> getDistrictById(String districtCode) async {
    return District.fromMap(
        await this.get("$_apiPath/districts/$districtCode"));
  }

  Future<Group> getGroupById(String districtCode, String code) async {
    return Group.fromMap(
        await this.get("$_apiPath/districts/$districtCode/groups/$code"));
  }

  Future<List<Group>> getAllFromDistrict(String districtCode) async {
    List<dynamic> items =
        (await this.get("$_apiPath/districts/$districtCode/groups/"))["items"];
    return items.map<Group>((item) => Group.fromMap(item)).toList();
  }

  void dispose() {
    _districtsCache.forEach((key, value) => value.close());
  }
}

class DistrictModel extends District {
  final List<Group> groups;

  DistrictModel(
      {required String code, required String name, this.groups = const []})
      : super(code: code, name: name);

  DistrictModel.fromMap(Map<String, dynamic> map)
      : groups = [],
        super.fromMap(map);

  DistrictModel.fromDistrict(District district)
      : groups = [],
        super(code: district.code, name: district.name);

  DistrictModel copyWith({List<Group>? groups}) {
    return DistrictModel(code: code, name: name, groups: groups ?? this.groups);
  }

  @override
  String toString() {
    return "DistrictModel(code: $code, name: $name, groups: $groups)";
  }
}
