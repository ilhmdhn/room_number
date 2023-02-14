import 'package:room_number/api/api_request.dart';
import 'package:room_number/data/event_bus/room_event.dart';
import 'package:room_number/data/model/room_detail_model.dart';
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
  late VideoPlayerController _videoController;
  bool? isSetting;
  RoomDetailResult? roomDetailResult;

  @override
  void initState() {
    super.initState();
    initRoomDetail();
    _videoController = VideoPlayerController.asset('assets/room_ready.mp4')
      ..initialize().then((_) => {
            setState(() {}),
            _videoController.play(),
            _videoController.setLooping(true)
          });
    eventBusRoom.on<RoomDetailEvent>().listen((event) {
      setState(() {
        roomDetailResult = event.detailRoom;
      });
    });
  }

  void initRoomDetail() async {
    roomDetailResult = await ApiService().getRoomDetail();
    setState(() {});
  }

  void videoChooseer() async {
    _videoController = VideoPlayerController.asset('assets/room_ready.mp4')
      ..initialize().then((_) => {
            setState(() {}),
            _videoController.play(),
            _videoController.setLooping(true)
          });

    if (roomDetailResult?.roomDetail?.checkinState == 1) {
      _videoController = VideoPlayerController.asset('assets/room_checkin.mp4')
        ..initialize().then((_) => {
              setState(() {}),
              _videoController.play(),
              _videoController.setLooping(true)
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    videoChooseer();
    return SafeArea(
      child: Scaffold(
          body: GestureDetector(
        onLongPressUp: () {
          Navigator.of(context).pushNamed(SettingPage.nameRoute);
        },
        child: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: _videoController.value.isInitialized
                    ? VideoPlayer(_videoController)
                    : const Center(
                        child: CircularProgressIndicator(),
                      )),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: roomDetailResult == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              roomDetailResult?.roomDetail?.roomAlias ?? '',
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              child:
                                  roomDetailResult?.roomDetail?.checkinState ==
                                          1
                                      ? Text('aaa')
                                      : SizedBox(),
                            )
                          ],
                        ),
                        Container(
                            child:
                                roomDetailResult?.roomDetail?.roomService == 1
                                    ? ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Service'),
                                      )
                                    : const SizedBox()),
                        Text(
                          '${roomDetailResult?.roomDetail?.roomCapacity} PAX | REDUCED ${((roomDetailResult?.roomDetail?.roomCapacity ?? 0) / 2).round()}',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
            )
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}
