import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final RxBool _isConnected = true.obs;
  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _isConnected.value = results.any(
        (ConnectivityResult r) => r != ConnectivityResult.none,
      );
    });
  }

  Future<bool> checkConnection() async {
    final List<ConnectivityResult> results = await Connectivity()
        .checkConnectivity();
    _isConnected.value = results.any(
      (ConnectivityResult r) => r != ConnectivityResult.none,
    );
    return _isConnected.value;
  }
}
