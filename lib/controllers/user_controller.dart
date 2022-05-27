import 'package:gapura/models/categories_model.dart';
import 'package:gapura/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListUserController {
  static load() async {
    String url = dotenv.env['BASE_URL'] + "api/v1/user";
    Uri parseUrl = Uri.parse(url);
    final response = await http.get(parseUrl);

    List<UserModel> list = [];
    for (var data in jsonDecode(response.body)['data'] as List) {
      list.add(UserModel.fromJson(data));
    }
    return list;
  }
}
