import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:room_number/data/devices/wifi_data.dart';
import 'package:room_number/data/event_bus/room_event.dart';
import 'package:room_number/data/model/room_detail_model.dart';
import 'package:room_number/page/setting_page.dart';
import './page/main_page.dart';
import 'package:flutter/services.dart';
import 'api/api_request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  final wifiIP = await CheckConnection().checkIP();
  final socket = await RawDatagramSocket.bind(wifiIP, 7082);
  ApiService().registerRoomNumber();


  socket.listen((RawSocketEvent event) async {
    if (event == RawSocketEvent.read) {
      Datagram? dg = socket.receive();
      final roomDetail = await ApiService().getRoomDetail();
      eventBusRoom.fire(RoomDetailEvent(roomDetail));
    }
  });
*/
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final inData = message.data["room_detail"];
    print("SIGNAL RECEIVEDs " + inData.toString());
    Map<String, dynamic> jsonMap = jsonDecode(inData);
    RoomDetail dataIn = RoomDetail.fromJson(jsonMap);
    eventBusRoom.fire(RoomDetailEvent(RoomDetailResult(roomDetail: dataIn)));
  });

  runApp(const RoomNumber());
}

class RoomNumber extends StatelessWidget {
  const RoomNumber({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MaterialApp(
      initialRoute: MainPage.nameRoute,
      routes: {
        MainPage.nameRoute: (context) => const MainPage(),
        SettingPage.nameRoute: (context) => const SettingPage()
      },
    );
  }
}
