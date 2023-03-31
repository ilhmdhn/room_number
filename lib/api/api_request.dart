import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:room_number/data/model/state_model.dart';
import '../data/shared_pref/preferences_data.dart';
import '../data/model/room_detail_model.dart';

class ApiService {
  Future<RoomDetailResult> getRoomDetail() async {
    try {
      final preferences = await PreferencesData().getPreferences();

      final url = '${preferences.url}:${preferences.port}';

      Uri apiUrl = Uri.parse(
          'http://$url/room/room-detail-room-sign-new?room_code=${preferences.roomCode}');
      final apiResponse = await http.get(apiUrl);
      return RoomDetailResult.fromJson(json.decode(apiResponse.body));
    } catch (e) {
      return RoomDetailResult(
          isLoading: false, state: false, message: e.toString());
    }
  }

  Future<StateResult> registerRoomNumber() async {
    try {
      final preferences = await PreferencesData().getPreferences();

      final url = '${preferences.url}:${preferences.port}';
      Uri apiUrl = Uri.parse(
          'http://$url/room/room-detail-room-sign/${preferences.roomCode}');
      final apiResponse = await http.get(apiUrl);
      return StateResult.fromJson(json.decode(apiResponse.body));
    } catch (e) {
      return StateResult(isLoading: false, state: false, message: e.toString());
    }
  }

  Future<StateResult> responseCallRoom() async {
    try {
      final preferences = await PreferencesData().getPreferences();

      final url = '${preferences.url}:${preferences.port}';
      final bodyRequest = {'state': '0', 'chusr': 'room sign'};
      Uri apiUrl =
          Uri.parse('http://$url/call/callroom/${preferences.roomCode}');
      final apiResponse = await http.put(apiUrl, body: bodyRequest);
      return StateResult.fromJson(json.decode(apiResponse.body));
    } catch (e) {
      return StateResult(isLoading: false, state: false, message: e.toString());
    }
  }

  Future<StateResult> insertToken(String token) async {
    try {
      final preferences = await PreferencesData().getPreferences();

      final url = '${preferences.url}:${preferences.port}';
      final bodyRequest = {'room': preferences.roomCode, 'token': token};

      Uri apiUrl = Uri.parse('http://$url/room/insert-room-number-token');
      final apiResponse = await http.post(apiUrl, body: bodyRequest);
      return StateResult.fromJson(json.decode(apiResponse.body));
    } catch (error) {
      return StateResult(
          isLoading: false, state: false, message: error.toString());
    }
  }
}