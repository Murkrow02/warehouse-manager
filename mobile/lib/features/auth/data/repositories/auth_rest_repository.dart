import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_manager/core/configuration/preferences.dart';
import 'package:warehouse_manager/core/networking/http/rest_client.dart';
import 'package:warehouse_manager/features/auth/data/models/login_response.dart';
import 'package:warehouse_manager/features/auth/data/repositories/auth_repository.dart';

class AuthRestRepository implements AuthRepository {

  final RestClient _restClient = RestClient();

  @override
  Future<void> login(String email, String password) async {
    var loginResponse = (await _restClient.post('auth/login', {
      'email': email,
      'password': password,
    }).then((value) => LoginResponse.fromJson(value)));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Preferences.AUTH_TOKEN, loginResponse.token);
  }

  @override
  Future logout() async {

    var prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.AUTH_TOKEN);

    // TODO: implement logout
    //throw UnimplementedError();
  }
}
