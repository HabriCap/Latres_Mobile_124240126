import 'package:get/get.dart';

import '../app/app_routes.dart';
import '../services/session_store.dart';
import 'main_navigation_controller.dart';

bool isValidLogin(String username, String password) =>
    username.trim() == AuthController.studentId &&
    password == AuthController.password;

class AuthController extends GetxController {
  AuthController(this._sessionStore);

  static const studentId = '126';
  static const password = '123';

  final SessionStore _sessionStore;
  final isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  String? get username => _sessionStore.username;

  Future<void> login(String username, String password) async {
    errorMessage.value = null;
    if (!isValidLogin(username, password)) {
      errorMessage.value = 'NIM atau password tidak sesuai.';
      return;
    }

    isLoading.value = true;
    try {
      await _sessionStore.saveLogin(username.trim());
      Get.find<MainNavigationController>().select(0);
      Get.offAllNamed<void>(AppRoutes.home);
    } catch (error) {
      errorMessage.value = 'Login gagal: $error';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _sessionStore.clearLogin();
      Get.offAllNamed<void>(AppRoutes.login);
    } catch (error) {
      Get.snackbar('Logout gagal', error.toString());
    }
  }
}
