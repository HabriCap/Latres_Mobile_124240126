import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/app_routes.dart';
import '../controllers/favorites_controller.dart';
import '../models/tv_show.dart';
import '../widgets/show_card.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({super.key});

  void _openDetail(TvShow show) {
    Get.toNamed<void>('${AppRoutes.detail}/${show.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: Obx(() {
        final shows = controller.favorites.toList();
        if (shows.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 52, color: Colors.white54),
                  SizedBox(height: 14),
                  Text('Belum ada show favorit'),
                  SizedBox(height: 6),
                  Text(
                    'Simpan show yang kamu suka dari halaman detail.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: shows.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            final show = shows[index];
            return ShowCard(
              show: show,
              onTap: () => _openDetail(show),
              isFavorite: true,
              onFavoriteToggle: () => controller.toggle(show),
            );
          },
        );
      }),
    );
  }
}
