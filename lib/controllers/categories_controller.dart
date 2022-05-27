import 'package:gapura/models/categories_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListCategoriesController {
  static load() async {
    String url = dotenv.env['BASE_URL'] + "api/v1/categories";

    Uri parseUrl = Uri.parse(url);

    final response = await http.get(parseUrl);

    List<CategoriesModel> list = [];
    for (var data in jsonDecode(response.body)['data'] as List) {
      list.add(CategoriesModel.fromJson(data));
    }
    return list;
  }
}

class AddCategoriesController {
  static load(
    String title,
    String subtitle,
    String description,
    String background,
    String image,
  ) async {
    String url = dotenv.env['BASE_URL'] + "api/v1/categories/add";

    Uri parseUrl = Uri.parse(
      url,
    );
    final response = await http.post(parseUrl, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "title": title,
      "subtitle": subtitle,
      "description": description,
      "background": background,
      "image": image,
    });

    return jsonDecode(response.body);
  }
}
