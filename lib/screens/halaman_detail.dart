import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_controller.dart';
import '../models/tv_show.dart';

class DetailScreen extends GetView<DetailController> {
  const DetailScreen({super.key, required this.showId});

  final int showId;

  @override
  String get tag => 'detail-$showId';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final show = controller.show.value;
      final error = controller.errorMessage.value;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail show'),
          actions: [
            if (show != null)
              IconButton(
                tooltip: controller.isFavorite
                    ? 'Hapus dari favorit'
                    : 'Tambah ke favorit',
                onPressed: controller.toggleFavorite,
                icon: Icon(
                  controller.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isFavorite ? Colors.pinkAccent : null,
                ),
              ),
          ],
        ),
        body: error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_outlined, size: 44),
                      const SizedBox(height: 12),
                      Text(error, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: controller.loadShow,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              )
            : controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : show == null
            ? const Center(child: Text('Detail show tidak tersedia.'))
            : _ShowDetails(show: show),
      );
    });
  }
}

class _ShowDetails extends StatelessWidget {
  const _ShowDetails({required this.show});

  final TvShow show;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 360,
            width: double.infinity,
            child: show.imageUrl == null
                ? const ColoredBox(
                    color: Color(0xFF252C39),
                    child: Icon(Icons.movie_outlined, size: 60),
                  )
                : Image.network(
                    show.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(
                          color: Color(0xFF252C39),
                          child: Icon(Icons.broken_image_outlined, size: 60),
                        ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  show.name,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFB45C)),
                    const SizedBox(width: 6),
                    Text(
                      show.rating?.toStringAsFixed(1) ?? 'Belum ada rating',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (show.genres.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: show.genres
                        .map((genre) => Chip(label: Text(genre)))
                        .toList(),
                  ),
                const SizedBox(height: 18),
                Text(
                  'Tentang show ini',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  show.summary.isEmpty ? 'Belum ada ringkasan.' : show.summary,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(height: 1.55, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
