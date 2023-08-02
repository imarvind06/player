import 'package:http/http.dart' as http;

class ApiCall {
  final String baseUrl = "https://internship-service.onrender.com/";
  static var client = http.Client();
  Future<Map<String, dynamic>> getCall(String endpoint) async {
    String url = baseUrl + endpoint;
    var res = await client.get(
      Uri.parse(url),
    );
    if (res.statusCode == 200) {
      return {
        "statusCode": 200,
        "result": res.body,
        "error": null,
      };
    } else {
      return {
        "statusCode": res.statusCode,
        "result": null,
        "error": res.body,
      };
    }
  }
}
