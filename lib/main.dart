import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_binding.dart';
import 'app/app_routes.dart';
import 'controllers/detail_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/main_navigation_controller.dart';
import 'screens/halaman_detail.dart';
import 'screens/halaman_favorit.dart';
import 'screens/halaman_beranda.dart';
import 'screens/halaman_login.dart';
import 'screens/halaman_profil.dart';
import 'services/favorite_store.dart';
import 'services/session_store.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final favoritesBox = await Hive.openBox<String>('favorites');
  final preferences = await SharedPreferences.getInstance();

  runApp(
    TvShowsApp(
      sessionStore: SessionStore(preferences),
      favoriteStore: FavoriteStore(favoritesBox),
      tvMazeService: ApiService(),
    ),
  );
}

class TvShowsApp extends StatelessWidget {
  const TvShowsApp({
    super.key,
    required this.sessionStore,
    required this.favoriteStore,
    required this.tvMazeService,
  });

  final SessionStore sessionStore;
  final FavoriteStore favoriteStore;
  final ApiService tvMazeService;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GasNonton!',
      debugShowCheckedModeBanner: false,
      initialRoute: sessionStore.isLoggedIn ? AppRoutes.home : AppRoutes.login,
      initialBinding: AppBinding(
        sessionStore: sessionStore,
        favoriteStore: favoriteStore,
        tvMazeService: tvMazeService,
      ),
      getPages: [
        GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
        GetPage(name: AppRoutes.home, page: () => const MainShell()),
        GetPage(
          name: '${AppRoutes.detail}/:id',
          page: () {
            final showId = int.parse(Get.parameters['id']!);
            return DetailScreen(showId: showId);
          },
          binding: BindingsBuilder(() {
            final showId = int.parse(Get.parameters['id']!);
            Get.lazyPut(
              () => DetailController(
                showId: showId,
                tvMazeService: Get.find<ApiService>(),
                favoritesController: Get.find<FavoritesController>(),
              ),
              tag: 'detail-$showId',
            );
          }),
        ),
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB45C),
          brightness: Brightness.dark,
          surface: const Color(0xFF151923),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1119),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1119),
          surfaceTintColor: Colors.transparent,
        ),
        useMaterial3: true,
      ),
    );
  }
}

class MainShell extends GetView<MainNavigationController> {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = [HomeScreen(), FavoritesScreen(), ProfileScreen()];

    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;
      return Scaffold(
        body: IndexedStack(index: selectedIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: controller.select,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF151923),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.white60,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.live_tv_outlined),
              activeIcon: Icon(Icons.live_tv),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      );
    });
  }
}
