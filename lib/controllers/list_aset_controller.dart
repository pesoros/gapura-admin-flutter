import 'package:gapura/models/list_aset_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListAsetController {
  static load() async {
    String url = dotenv.env['BASE_URL'] + "api/v1/assets";

    // Uri parseUrl = Uri.parse(url).replace(queryParameters: {'sort': "ASC"});
    Uri parseUrl = Uri.parse(url);

    final response = await http.get(parseUrl);

    List<ListAsetModel> list = [];
    for (var data in jsonDecode(response.body)['data'] as List) {
      list.add(ListAsetModel.fromJson(data));
    }
    return list;
  }
}
