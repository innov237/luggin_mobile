import 'package:luggin/environment/environment.dart';
import 'package:dio/dio.dart';

class HttpService {
  final String apiUrl = AppEvironement.apiUrlDev;

  Future getPosts(route) async {
    Dio dio = Dio();
    Response res = await dio.get(apiUrl + route);
    if (res.statusCode == 200) {
      var body = res.data;
      return body;
    }
  }

  Future getPostByKey(route, key) async {
    Dio dio = Dio();
    Response res = await dio.get(apiUrl + route, queryParameters: {'key': key});
    if (res.statusCode == 200) {
      var body = res.data;
      return body;
    }
  }

  Future postData(route, data) async {
    Dio dio = Dio();
    Response res = await dio.post(apiUrl + route, data: data);
    if (res.statusCode == 200) {
      var body = res.data;
      return body;
    } else {
      var body = {
        'message': 'Please check your connection and try again',
        'success': false
      };
      return body;
    }
  }
}
