import 'package:get/get.dart';

import '../models/tv_show.dart';
import '../services/api_service.dart';
import 'favorites_controller.dart';

class DetailController extends GetxController {
  DetailController({
    required this.showId,
    required this.tvMazeService,
    required this.favoritesController,
  });

  final int showId;
  final ApiService tvMazeService;
  final FavoritesController favoritesController;
  final Rxn<TvShow> show = Rxn<TvShow>();
  final isLoading = true.obs;
  final RxnString errorMessage = RxnString();

  bool get isFavorite => favoritesController.contains(showId);

  @override
  void onInit() {
    super.onInit();
    loadShow();
  }

  Future<void> loadShow() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      show.value = await tvMazeService.fetchShow(showId);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    final currentShow = show.value;
    if (currentShow == null) return;
    await favoritesController.toggle(currentShow);
  }
}
