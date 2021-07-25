import 'package:handicraft_app/models/product_general.dart';
import 'package:http/http.dart' as http;

class PostsRepository {
  Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse(
        "https://hechoencasa-backend.herokuapp.com/product/getAllProducts/2/0/2"));
    final json_general = productModelFromJson(response.body).data;
    return json_general;
  }
}
