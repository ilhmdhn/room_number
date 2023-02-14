import 'dart:io';
import 'package:flutter/material.dart';
import 'package:room_number/data/event_bus/room_event.dart';
import './page/main_page.dart';
import 'package:flutter/services.dart';
import 'api/api_request.dart';

void main() async {
  final socket = await RawDatagramSocket.bind('192.168.1.228', 7082);

  socket.listen((RawSocketEvent event) async {
    if (event == RawSocketEvent.read) {
      final Datagram? dg = socket.receive();
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
    return MaterialApp(
      initialRoute: MainPage.nameRoute,
      routes: {MainPage.nameRoute: (context) => const MainPage()},
    );
  }
}
