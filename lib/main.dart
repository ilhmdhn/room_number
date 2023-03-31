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
  final wifiIP = await CheckConnection().checkIP();
  final socket = await RawDatagramSocket.bind(wifiIP, 7082);
  initToken();
  ApiService().registerRoomNumber();

  socket.listen((RawSocketEvent event) async {
    if (event == RawSocketEvent.read) {
      Datagram? dg = socket.receive();
      final roomDetail = await ApiService().getRoomDetail();
      eventBusRoom.fire(RoomDetailEvent(roomDetail));
    }
  });

  runApp(const RoomNumber());
}

class RoomNumber extends StatelessWidget {
  const RoomNumber({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('DEBUGGING Message data: ${message.data}');
      RoomDetail dataIn = RoomDetail.fromJson(message.data["room_detail"]);
      eventBusRoom.fire(RoomDetailEvent(RoomDetailResult(roomDetail: dataIn)));
    });
    return MaterialApp(
      initialRoute: MainPage.nameRoute,
      routes: {
        MainPage.nameRoute: (context) => const MainPage(),
        SettingPage.nameRoute: (context) => const SettingPage()
      },
    );
  }
}

void initToken() async {
  await Firebase.initializeApp();
  String? fcmToken = await FirebaseMessaging.instance.getToken();

  await ApiService().insertToken(fcmToken!);

  FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
    await ApiService().insertToken(fcmToken);
  }).onError((err) async {});
}
