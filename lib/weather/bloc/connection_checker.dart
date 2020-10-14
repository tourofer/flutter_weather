import 'package:connectivity/connectivity.dart';

class ConnectionChecker {
  static Future<bool> isConnected() async {
    return (Connectivity().checkConnectivity()).then(
        (connectivityResult) => connectivityResult != ConnectivityResult.none);
  }
}
