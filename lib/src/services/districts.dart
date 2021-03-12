import 'package:scout_spirit/src/models/district.dart';
import 'package:scout_spirit/src/services/rest_api.dart';

class DistrictsService extends RestApiService {
  final String _apiPath = 'api/districts';

  Future<District> getById(String id) async {
    return District.fromMap(await this.get("$_apiPath/$id"));
  }

  Future<List<District>> getAll() async {
    List<dynamic> items = (await this.get("$_apiPath/"))["items"];
    return items.map<District>((item) => District.fromMap(item)).toList();
  }
}