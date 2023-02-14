import 'package:room_number/data/event_bus/room_event.dart';
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
      print('ALURNYA GAMASUK KENE 2' + event.toString());
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
          Expanded(
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
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
