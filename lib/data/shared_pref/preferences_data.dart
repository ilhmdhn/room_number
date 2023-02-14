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
        isSetting: prefs.getBool('IS_SETTING') ?? true,
        url: prefs.getString('BASE_URL') ?? '192.168.1.148',
        port: prefs.getString('PORT') ?? '3000',
        roomCode: prefs.getString('ROOM_CODE') ?? 'PR A');
  }

  Future<bool> isSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('IS_SETTING') ?? false;
  }
}
