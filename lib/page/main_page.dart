import 'package:room_number/data/event_bus/room_event.dart';
import 'package:room_number/page/setting_page.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const nameRoute = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final VideoPlayerController _controller;
  bool? isSetting;

  @override
  void initState() {
    super.initState();
    eventBusRoom.on<RoomDetailEvent>().listen((event) {
      print('hahhh GAMASUK KENE 2' + event.toString());
    });
    _controller = VideoPlayerController.asset('assets/room_ready.mp4')
      ..initialize().then((_) =>
          {setState(() {}), _controller.play(), _controller.setLooping(true)});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'ROOM NAME',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'ROOM NAME',
                  style: TextStyle(fontSize: 20),
                ),
                GestureDetector(
                  onLongPress: (() {
                    Navigator.of(context).pushNamed(SettingPage.nameRoute);
                    // Navigator.pushedName(context, SettingPage.nameRoute);
                  }),
                  child: Text(
                    'Belum Disetting',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
