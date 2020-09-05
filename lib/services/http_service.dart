import 'package:luggin/environment/environment.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HttpService {
  final String apiUrl = AppEvironement.apiUrl;

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

  uploadImage(String imagepath, String fileName) async {
    var uri = Uri.parse(apiUrl + "upload");
    var request = http.MultipartRequest('POST', uri)
      ..fields['fileName'] = fileName
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imagepath,
          filename: fileName,
          contentType: MediaType('application', 'x-tar'),
        ),
      );
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded!');
      return true;
    }
  }
}
