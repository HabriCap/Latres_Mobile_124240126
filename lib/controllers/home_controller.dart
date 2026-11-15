import 'package:get/get.dart';

import '../models/tv_show.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  HomeController(this._tvMazeService);

  final ApiService _tvMazeService;
  final shows = <TvShow>[].obs;
  final isLoading = true.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadShows();
  }

  Future<void> loadShows() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      shows.assignAll(await _tvMazeService.fetchShows());
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
