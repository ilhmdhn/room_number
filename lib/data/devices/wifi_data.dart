import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectivity {
  Future<String> checkIP() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      final wifiInfo = ConnectivityResult.wifi;
      wifiInfo.toString();
    }
  }
}
