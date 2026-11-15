import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:latihan/app/app_routes.dart';
import 'package:latihan/controllers/auth_controller.dart';
import 'package:latihan/controllers/detail_controller.dart';
import 'package:latihan/controllers/favorites_controller.dart';
import 'package:latihan/controllers/main_navigation_controller.dart';
import 'package:latihan/models/tv_show.dart';
import 'package:latihan/main.dart';
import 'package:latihan/screens/halaman_login.dart';
import 'package:latihan/services/favorite_store.dart';
import 'package:latihan/services/session_store.dart';
import 'package:latihan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('latres-hive-test-');
    Hive.init(hiveDirectory.path);
    await Hive.openBox<String>('favorites_test');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  testWidgets('login accepts the assigned NIM and password', (tester) async {
    SharedPreferences.setMockInitialValues({});
    Get.put(MainNavigationController());
    Get.put(
      AuthController(SessionStore(await SharedPreferences.getInstance())),
    );
    addTearDown(() async => Get.reset());

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoutes.login,
        getPages: [
          GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
          GetPage(
            name: AppRoutes.home,
            page: () => const Scaffold(body: Text('home-destination')),
          ),
        ],
      ),
    );

    await tester.enterText(find.byKey(const Key('username-field')), '124');
    await tester.enterText(find.byKey(const Key('password-field')), '123');
    await tester.tap(find.text('Masuk'));
    await tester.pump();
    expect(find.text('NIM atau password tidak sesuai.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('username-field')),
      AuthController.studentId,
    );
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('home-destination'), findsOneWidget);
  });

  testWidgets('GetX routes show details and updates the favorites page', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'loggedInUsername': AuthController.studentId,
      'isLoggedIn': true,
    });
    final preferences = await SharedPreferences.getInstance();
    final showJson = {
      'id': 42,
      'name': 'Example Show',
      'rating': {'average': 8.4},
      'image': null,
      'genres': ['Drama'],
      'summary': '<p>A story.</p>',
    };
    final client = MockClient((request) async {
      if (request.url.path == '/shows') {
        return http.Response(jsonEncode([showJson]), 200);
      }
      if (request.url.path == '/shows/42') {
        return http.Response(jsonEncode(showJson), 200);
      }
      return http.Response('Not found', 404);
    });
    addTearDown(client.close);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      if (Get.isRegistered<FavoritesController>()) {
        Get.delete<FavoritesController>(force: true);
      }
      Get.reset();
    });

    await tester.pumpWidget(
      TvShowsApp(
        sessionStore: SessionStore(preferences),
        favoriteStore: FavoriteStore(Hive.box<String>('favorites_test')),
        tvMazeService: ApiService(client: client),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Example Show'), findsOneWidget);
    await tester.ensureVisible(find.text('Example Show'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Example Show'));
    await tester.pumpAndSettle();
    expect(find.text('A story.'), findsOneWidget);

    await tester.runAsync(
      () => Get.find<DetailController>(tag: 'detail-42').toggleFavorite(),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Hapus dari favorit'), findsOneWidget);
    expect(Get.find<FavoritesController>().favorites, hasLength(1));
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorit'));
    await tester.pumpAndSettle();
    expect(find.text('Example Show'), findsOneWidget);

    final favoritesController = Get.find<FavoritesController>();
    await tester.runAsync(
      () => favoritesController.toggle(favoritesController.favorites.single),
    );
    await tester.pumpAndSettle();
    expect(find.text('Belum ada show favorit'), findsOneWidget);
  });

  test('TVMaze service parses show data and strips summary markup', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/shows');
      return http.Response(
        jsonEncode([
          {
            'id': 42,
            'name': 'Example Show',
            'rating': {'average': 8.4},
            'image': {'medium': 'https://example.com/poster.jpg'},
            'genres': ['Drama', 'Mystery'],
            'summary': '<p>A story &amp; a mystery.</p>',
          },
        ]),
        200,
      );
    });
    addTearDown(client.close);

    final shows = await ApiService(client: client).fetchShows();

    expect(shows, hasLength(1));
    expect(shows.single.id, 42);
    expect(shows.single.name, 'Example Show');
    expect(shows.single.rating, 8.4);
    expect(shows.single.imageUrl, 'https://example.com/poster.jpg');
    expect(shows.single.genres, ['Drama', 'Mystery']);
    expect(shows.single.summary, 'A story & a mystery.');
    expect(
      TvShow.fromJson(shows.single.toJson()).summary,
      shows.single.summary,
    );
  });

  test('TVMaze service reports unsuccessful HTTP responses', () async {
    final client = MockClient((_) async => http.Response('Unavailable', 503));
    addTearDown(client.close);

    await expectLater(
      ApiService(client: client).fetchShow(42),
      throwsA(isA<TvMazeException>()),
    );
  });

  test('favorites are saved and removed from the local Hive box', () async {
    final store = FavoriteStore(Hive.box<String>('favorites_test'));
    const show = TvShow(
      id: 42,
      name: 'Example Show',
      rating: 8.4,
      imageUrl: null,
      genres: ['Drama'],
      summary: 'A story.',
    );

    await store.toggle(show);
    expect(store.contains(show.id), isTrue);
    expect(store.favorites.single.name, show.name);

    await store.toggle(show);
    expect(store.contains(show.id), isFalse);
    expect(store.favorites, isEmpty);
  });

  test('login session is stored and cleared with SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SessionStore(await SharedPreferences.getInstance());

    await store.saveLogin(AuthController.studentId);
    expect(store.isLoggedIn, isTrue);
    expect(store.username, AuthController.studentId);

    await store.clearLogin();
    expect(store.isLoggedIn, isFalse);
    expect(store.username, isNull);
  });
}
