import 'package:http/http.dart' as http;
class ServerCommunicator {
  String base;

  ServerCommunicator(this.base) {

  }

  Future post(subdir, body,callback) async{
    String url = base + subdir;
    var data = await http.post(url, body: body);
    callback.call(data);
  }
}
