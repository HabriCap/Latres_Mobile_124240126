import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/tv_show.dart';

class FavoriteStore {
  const FavoriteStore(this._box);

  final Box<String> _box;

  bool contains(int showId) => _box.containsKey(showId.toString());

  List<TvShow> get favorites => _box.values
      .map(
        (value) => TvShow.fromStoredJson(
          Map<String, dynamic>.from(jsonDecode(value) as Map),
        ),
      )
      .toList();

  Future<void> toggle(TvShow show) async {
    final key = show.id.toString();
    if (_box.containsKey(key)) {
      await _box.delete(key);
    } else {
      await _box.put(key, jsonEncode(show.toJson()));
    }
  }
}
