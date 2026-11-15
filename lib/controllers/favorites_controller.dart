import 'package:get/get.dart';

import '../models/tv_show.dart';
import '../services/favorite_store.dart';

class FavoritesController extends GetxController {
  FavoritesController(this._favoriteStore);

  final FavoriteStore _favoriteStore;
  final favorites = <TvShow>[].obs;

  @override
  void onInit() {
    super.onInit();
    _refreshFavorites();
  }

  bool contains(int showId) => favorites.any((show) => show.id == showId);

  Future<void> toggle(TvShow show) async {
    await _favoriteStore.toggle(show);
    _refreshFavorites();
  }

  void _refreshFavorites() {
    favorites.assignAll(_favoriteStore.favorites);
  }
}
