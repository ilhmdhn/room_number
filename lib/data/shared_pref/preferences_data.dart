import 'package:shared_preferences/shared_preferences.dart';
import '../model/preferences_model.dart';

class PreferencesData {
  Future<bool> initPreferences(PreferencesModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('BASE_URL', data.url ?? '');
    await prefs.setString('PORT', data.port ?? '');
    await prefs.setString('ROOM_CODE', data.roomCode ?? '');
    await prefs.setBool('IS_SETTING', data.isSetting);
    return true;
  }

  Future<PreferencesModel> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesModel(
        isSetting: prefs.getBool('IS_SETTING') ?? false,
        url: prefs.getString('BASE_URL'),
        port: prefs.getString('PORT'),
        roomCode: prefs.getString('ROOM_CODE'));
  }

  Future<bool> isSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('IS_SETTING') ?? false;
  }
}
