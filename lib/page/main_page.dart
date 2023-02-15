import 'package:room_number/api/api_request.dart';
import 'package:room_number/data/event_bus/room_event.dart';
import 'package:room_number/data/model/room_detail_model.dart';
import 'package:room_number/page/setting_page.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int? checkinState = 0;
  double blitzOn = 0;

  @override
  void initState() {
    super.initState();
    initRoomDetail();

    eventBusRoom.on<RoomDetailEvent>().listen((event) {
      setState(() {
        roomDetailResult = event.detailRoom;
        if (event.detailRoom.roomDetail?.roomService == 1) {
          FlutterRingtonePlayer.playNotification();
        }
      });
    });

    _videoController = VideoPlayerController.asset('assets/room_ready.mp4');
    _videoController.addListener(() {
      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.initialize().then((_) {
      setState(() {
        _videoController.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    videoController();
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
                  : Container(
                      child: roomDetailResult?.state == false
                          ? Center(
                              child: Text(
                                'ERROR ${roomDetailResult?.message} atau periksa pengaturan',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 95,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: DefaultTextStyle(
                                        style:
                                            GoogleFonts.roboto(fontSize: 43.0),
                                        child: AnimatedTextKit(
                                          repeatForever: true,
                                          animatedTexts: [
                                            FadeAnimatedText(roomDetailResult
                                                    ?.roomDetail?.roomAlias ??
                                                ''),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 45,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.dancingScript(
                                            fontSize: 43,
                                            fontWeight: FontWeight.bold),
                                        child: AnimatedTextKit(
                                          repeatForever: true,
                                          animatedTexts: [
                                            TyperAnimatedText(
                                                roomDetailResult!
                                                    .roomDetail!.guestName
                                                    .toString(),
                                                speed: const Duration(
                                                    milliseconds: 800)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: roomDetailResult?.roomDetail
                                                      ?.roomService ==
                                                  1 &&
                                              roomDetailResult?.roomDetail
                                                      ?.checkinState ==
                                                  1
                                          ? IconButton(
                                              onPressed: () async {
                                                ApiService().responseCallRoom();
                                              },
                                              icon: const Icon(
                                                Icons.account_circle_rounded,
                                                color: Colors.red,
                                                size: 350,
                                              ),
                                            )
                                          : const SizedBox()),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.robotoSlab(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                        child: AnimatedTextKit(
                                          repeatForever: true,
                                          animatedTexts: [
                                            FadeAnimatedText(
                                                '${roomDetailResult?.roomDetail?.roomCapacity} PAX | REDUCED: ${((roomDetailResult?.roomDetail?.roomCapacity ?? 0) / 2).round()} PAX'),
                                          ],
                                          isRepeatingAnimation: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 125,
                                    )
                                  ],
                                ),
                              ],
                            ),
                    ),
            )
          ],
        ),
      )),
    );
  }

  void initRoomDetail() async {
    roomDetailResult = await ApiService().getRoomDetail();
    setState(() {});
  }

  void videoController() {
    if (roomDetailResult != null && roomDetailResult?.isLoading != true) {
      if (checkinState != roomDetailResult?.roomDetail?.checkinState) {
        checkinState = roomDetailResult?.roomDetail?.checkinState;
        if (roomDetailResult?.roomDetail?.checkinState == 1) {
          _videoController.dispose();
          _videoController =
              VideoPlayerController.asset('assets/room_checkin.mp4');
          _videoController.addListener(() {
            setState(() {});
          });
          _videoController.setLooping(true);
          _videoController.initialize().then((_) {
            setState(() {});
          });
          _videoController.play();
        } else {
          _videoController.dispose();
          _videoController =
              VideoPlayerController.asset('assets/room_ready.mp4');
          _videoController.addListener(() {
            setState(() {});
          });
          _videoController.setLooping(true);
          _videoController.initialize().then((_) {
            setState(() {});
          });
          _videoController.play();
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}
