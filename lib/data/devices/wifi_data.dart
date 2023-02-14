import 'package:network_info_plus/network_info_plus.dart';

class CheckConnection {
  final info = NetworkInfo();

  Future<String> checkIP() async {
    return await info.getWifiIP()??'127.0.0.1';
  }
}
