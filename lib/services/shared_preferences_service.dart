import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<String?> getSelectedCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_country');
  }

  Future<void> setSelectedCountry(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_country', country);
  }
}
