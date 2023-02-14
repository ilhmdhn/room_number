import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/shared_pref/preferences_data.dart';
import '../data/model/room_detail_model.dart';

class ApiService {
  Future<RoomDetailResult> getRoomDetail() async {
    try {
      final preferences = await PreferencesData().getPreferences();

      final url = '${preferences.url}:${preferences.port}';

      Uri apiUrl = Uri.parse('http://$url/room/room-detail-room-sign-new?room_code=${preferences.roomCode}');
      final apiResponse = await http.get(apiUrl);
      return RoomDetailResult.fromJson(json.decode(apiResponse.body));
    } catch (e) {
      return RoomDetailResult(
          isLoading: false, state: false, message: e.toString());
    }
  }
}
