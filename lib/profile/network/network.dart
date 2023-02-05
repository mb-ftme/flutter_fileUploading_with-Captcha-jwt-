import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ApiClient {
  static var dio = Dio();

  static Future<dynamic> uploadFile(List<int> file, String fileName) async {
    FormData formData = FormData.fromMap({
      "files": MultipartFile.fromBytes(
        file,
        filename: fileName,
        // contentType: MediaType("application",
        //     "vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
      )
    });
    var response = await dio.post("http://localhost:8080/api/v1/batch/upload",
        data: formData);
    print(response.data);
    return response.data;
  }
}
