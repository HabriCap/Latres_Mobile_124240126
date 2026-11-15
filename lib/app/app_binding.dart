import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/main_navigation_controller.dart';
import '../services/favorite_store.dart';
import '../services/session_store.dart';
import '../services/api_service.dart';

class AppBinding extends Bindings {
  AppBinding({
    required this.sessionStore,
    required this.favoriteStore,
    required this.tvMazeService,
  });

  final SessionStore sessionStore;
  final FavoriteStore favoriteStore;
  final ApiService tvMazeService;

  @override
  void dependencies() {
    Get.put<SessionStore>(sessionStore, permanent: true);
    Get.put<FavoriteStore>(favoriteStore, permanent: true);
    Get.put<ApiService>(tvMazeService, permanent: true);
    Get.put(AuthController(sessionStore), permanent: true);
    Get.put(FavoritesController(favoriteStore), permanent: true);
    Get.put(MainNavigationController(), permanent: true);
    Get.lazyPut(() => HomeController(tvMazeService), fenix: true);
  }
}
