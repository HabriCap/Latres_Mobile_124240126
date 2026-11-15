class TvShow {
  const TvShow({
    required this.id,
    required this.name,
    required this.rating,
    required this.imageUrl,
    required this.genres,
    required this.summary,
  });

  final int id;
  final String name;
  final double? rating;
  final String? imageUrl;
  final List<String> genres;
  final String summary;

  factory TvShow.fromJson(Map<String, dynamic> json) {
    final ratingValue = json['rating'];
    final image = json['image'];
    final imageData = image is Map ? image : null;

    return TvShow(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Tanpa judul',
      rating: ratingValue is Map && ratingValue['average'] is num
          ? (ratingValue['average'] as num).toDouble()
          : null,
      imageUrl:
          imageData?['original'] as String? ?? imageData?['medium'] as String?,
      genres: (json['genres'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      summary: _plainText(json['summary'] as String? ?? ''),
    );
  }

  factory TvShow.fromStoredJson(Map<String, dynamic> json) {
    return TvShow.fromJson(json);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rating': {'average': rating},
    'image': {'original': imageUrl},
    'genres': genres,
    'summary': summary,
  };

  static String _plainText(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
