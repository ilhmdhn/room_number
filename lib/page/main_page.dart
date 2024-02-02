import 'package:room_number/api/api_request.dart';
import 'package:room_number/data/event_bus/room_event.dart';
import 'package:room_number/data/model/room_detail_model.dart';
import 'package:room_number/page/setting_page.dart';
import '../data/shared_pref/preferences_data.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wakelock/wakelock.dart';
import 'package:just_audio/just_audio.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const nameRoute = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  bool? isSetting;
  bool roomService = false;
  RoomDetailResult? roomDetailResult;
  late AnimationController _blinkController;
  String roomCode = '';
  int checkinState = 0;
  final inputNameController = TextEditingController();
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initRoomDetail();
    Wakelock.enable();
    _blinkController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: false);
    if (roomDetailResult?.roomDetail?.checkinState == 1) {
      _videoController = VideoPlayerController.asset('assets/room_checkin.mp4');
    } else {
      _videoController = VideoPlayerController.asset('assets/room_ready.mp4');
    }
    _videoController.addListener(() => setState(() {}));
    _videoController.setLooping(true);
    _videoController.initialize().then((_) {
      setState(() {});
    });
    _videoController.play();

    eventBusRoom.on<RoomDetailEvent>().listen((event) {
      setState(() {
        roomDetailResult = event.detailRoom;
        if (checkinState != event.detailRoom.roomDetail?.checkinState) {
          checkinState = event.detailRoom.roomDetail?.checkinState ?? 0;
          videoSelector(checkinState);
        }
      });
    });

    eventBusRoom.on<RoomServiceEvent>().listen((event) {
      setState(() {
        roomService = event.service;
        if (roomService == true) {
          audioPlayer.play();
        } else {
          audioPlayer.stop();
        }
      });
    });
    initAudio();
  }

  @override
  Widget build(BuildContext context) {
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
                      : const Center(child: CircularProgressIndicator())),
              SizedBox(
                child: roomService
                    ? AnimatedOpacity(
                        opacity: _blinkController.value,
                        duration: const Duration(microseconds: 1),
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                        ),
                      )
                    : const SizedBox(),
              ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 75,
                                      ),
                                      SizedBox(
                                        height: 45,
                                        child: DefaultTextStyle(
                                          style: GoogleFonts.robotoSlab(
                                              shadows: <Shadow>[
                                                const Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black,
                                                ),
                                              ],
                                              fontSize: 43.0),
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 45,
                                        child: DefaultTextStyle(
                                          style: GoogleFonts.dancingScript(
                                              shadows: <Shadow>[
                                                const Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black,
                                                ),
                                              ],
                                              fontSize: 43,
                                              fontWeight: FontWeight.bold),
                                          child: AnimatedTextKit(
                                            repeatForever: true,
                                            animatedTexts: [
                                              TyperAnimatedText(
                                                  roomDetailResult?.roomDetail
                                                          ?.guestName
                                                          .toString() ??
                                                      "",
                                                  speed: const Duration(
                                                      milliseconds: 800)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 45,
                                        child: DefaultTextStyle(
                                          style: GoogleFonts.robotoSlab(
                                              shadows: <Shadow>[
                                                const Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black,
                                                ),
                                              ],
                                              fontSize: 30),
                                          child: AnimatedTextKit(
                                            repeatForever: true,
                                            animatedTexts: [
                                              FadeAnimatedText(roomDetailResult
                                                      ?.roomDetail?.checkinInfo
                                                      .toString() ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: roomService
                                            ? GestureDetector(
                                                onDoubleTap: () async {
                                                  showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Response Room Call'),
                                                      content: TextField(
                                                        controller:
                                                            inputNameController,
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await ApiService()
                                                                .responseCallRoom(
                                                                    inputNameController
                                                                        .text);
                                                            await initRoomDetail();
                                                            if (context
                                                                .mounted) {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.account_circle_rounded,
                                                  color: Colors.black,
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
                                              shadows: <Shadow>[
                                                const Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black,
                                                ),
                                              ],
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
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 42, bottom: 43),
          child: SizedBox(
            height: 63,
            width: 63,
            child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            content: SizedBox(
                              width: 200,
                              height: 200,
                              child: Center(
                                child: QrImage(
                                  data: roomCode,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ),
                            ),
                          ));
                }),
          ),
        ),
      ),
    );
  }

  Future<void> initRoomDetail() async {
    final preferencesData = await PreferencesData().getPreferences();
    roomCode = preferencesData.roomCode ?? '';
    roomDetailResult = await ApiService().getRoomDetail();
    if (roomDetailResult?.roomDetail?.checkinState != checkinState) {
      checkinState = roomDetailResult?.roomDetail?.checkinState ?? 0;
      videoSelector(checkinState);
    }
    setState(() {
      roomCode;
      roomDetailResult;
      checkinState = roomDetailResult?.roomDetail?.checkinState ?? 0;
    });
    initToken();
  }

  void videoSelector(int state) {
    if (state == 1) {
      _videoController = VideoPlayerController.asset('assets/room_checkin.mp4');
    } else {
      _videoController = VideoPlayerController.asset('assets/room_ready.mp4');
    }
    _videoController.setLooping(true);
    _videoController.initialize().then((_) => _videoController.play());
  }

  @override
  void dispose() {
    _videoController.dispose();
    _blinkController.dispose();
    inputNameController.dispose();
    // audioPlayer.dispose();
    super.dispose();
  }

  void initAudio() async {
    await audioPlayer.setAsset('assets/dorbell.mp3');
    audioPlayer.setLoopMode(LoopMode.one);
  }
}

void initToken() async {
  await Firebase.initializeApp();
  String? fcmToken = await FirebaseMessaging.instance.getToken();

  await ApiService().insertToken(fcmToken ?? '');

  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) async {})
      .onError((err) async {});
}
