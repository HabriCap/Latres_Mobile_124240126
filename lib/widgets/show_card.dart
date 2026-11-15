import 'package:flutter/material.dart';

import '../models/tv_show.dart';

class ShowCard extends StatelessWidget {
  const ShowCard({
    super.key,
    required this.show,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final TvShow show;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ShowImage(imageUrl: show.imageUrl),
                  if (onFavoriteToggle != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.black54,
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: 'Hapus dari favorit',
                          onPressed: onFavoriteToggle,
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 17,
                        color: Color(0xFFFFB45C),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        show.rating?.toStringAsFixed(1) ?? 'Belum ada rating',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowImage extends StatelessWidget {
  const _ShowImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const ColoredBox(
        color: Color(0xFF252C39),
        child: Center(
          child: Icon(Icons.movie_outlined, size: 48, color: Colors.white38),
        ),
      );
    }
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const ColoredBox(
        color: Color(0xFF252C39),
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 42,
            color: Colors.white38,
          ),
        ),
      ),
    );
  }
}
