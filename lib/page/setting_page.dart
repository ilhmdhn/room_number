import 'package:flutter/material.dart';
import 'package:room_number/api/api_request.dart';
import 'package:room_number/data/model/preferences_model.dart';
import 'package:room_number/data/shared_pref/preferences_data.dart';
import 'package:room_number/page/main_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  static const nameRoute = '/setting';

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isSetting = false;
  TextEditingController textUrlController = TextEditingController();
  TextEditingController textPortController = TextEditingController();
  TextEditingController textRoomController = TextEditingController();
  PreferencesModel? preferencesData;
  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  void getPreferences() async {
    preferencesData = await PreferencesData().getPreferences();
    textUrlController.text = preferencesData?.url ?? 'IP Server belum diisi';
    textPortController.text =
        preferencesData?.port ?? 'Port Server belum diisi';
    textRoomController.text =
        preferencesData?.roomCode ?? 'Kode Room belum diisi';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PENGATURAN',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: textUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(4),
                hintText: 'IP Address Server',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: textPortController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(4),
                hintText: 'Server Port',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: textRoomController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(4),
                hintText: 'Kode Room',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  PreferencesModel preferencesModel = PreferencesModel(
                      isSetting: true,
                      url: textUrlController.text,
                      port: textPortController.text,
                      roomCode: textRoomController.text);

                  await PreferencesData().initPreferences(preferencesModel);
                  await ApiService().registerRoomNumber();
                  final submit = await ApiService().registerRoomNumber();
                  if (submit.isLoading == false) {
                    if (submit.state == true) {
                      if (mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            MainPage.nameRoute, (route) => false);
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(submit.message.toString())));
                      }
                    }
                  } else {
                    const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                child: const Text('SUBMIT'))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textUrlController.dispose();
    textPortController.dispose();
    textRoomController.dispose();
  }
}
