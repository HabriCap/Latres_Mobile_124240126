import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/app_routes.dart';
import '../controllers/home_controller.dart';
import '../models/tv_show.dart';
import '../widgets/show_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  void _openDetail(TvShow show) {
    Get.toNamed<void>('${AppRoutes.detail}/${show.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GasNonton!'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: controller.loadShows,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        final error = controller.errorMessage.value;
        if (error != null) {
          return _LoadError(message: error, onRetry: controller.loadShows);
        }
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final shows = controller.shows;
        return RefreshIndicator(
          onRefresh: controller.loadShows,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temukan tontonanmu',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Serial dan show populer, dikurasi untukmu.',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ),
              if (shows.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('Belum ada show untuk ditampilkan.'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  sliver: SliverGrid.builder(
                    itemCount: shows.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 44),
            const SizedBox(height: 12),
            const Text('Data belum bisa dimuat'),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
