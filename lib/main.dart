import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:room_number/data/event_bus/room_event.dart';
import 'package:room_number/data/model/room_detail_model.dart';
import 'package:room_number/page/setting_page.dart';
import './page/main_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final inData = message.data["room_detail"];
    final serviceData = message.data["service"];
    if (inData != null) {
      Map<String, dynamic> jsonMap = jsonDecode(inData);
      RoomDetail dataIn = RoomDetail.fromJson(jsonMap);
      eventBusRoom.fire(RoomDetailEvent(RoomDetailResult(roomDetail: dataIn)));
    } else if (serviceData != null) {
      if (serviceData == "true") {
        eventBusRoom.fire(RoomServiceEvent(true));
      } else {
        eventBusRoom.fire(RoomServiceEvent(false));
      }
    }
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
