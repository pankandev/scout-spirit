import 'package:scout_spirit/src/models/group.dart';
import 'package:scout_spirit/src/services/rest_api.dart';

class GroupsService extends RestApiService {
  final String _apiPath = 'api';

  Future<Group> getById(String districtCode, String code) async {
    return Group.fromMap(await this.get("$_apiPath/districts/$districtCode/groups/$code"));
  }

  Future<List<Group>> getAllFromDistrict(String districtCode) async {
    List<dynamic> items = (await this.get("$_apiPath/districts/$districtCode/groups/"))["items"];
    return items.map<Group>((item) => Group.fromMap(item)).toList();
  }
}