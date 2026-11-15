import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/tv_show.dart';

class TvMazeException implements Exception {
  const TvMazeException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://api.tvmaze.com';
  final http.Client _client;

  Future<List<TvShow>> fetchShows() async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/shows'))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw TvMazeException(
        'Gagal memuat daftar show (HTTP ${response.statusCode}).',
      );
    }

    final data = jsonDecode(response.body);
    if (data is! List) {
      throw const TvMazeException(
        'Format daftar show dari server tidak valid.',
      );
    }
    return data
        .map((item) => TvShow.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<TvShow> fetchShow(int id) async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/shows/$id'))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw TvMazeException(
        'Gagal memuat detail show (HTTP ${response.statusCode}).',
      );
    }

    final data = jsonDecode(response.body);
    if (data is! Map) {
      throw const TvMazeException(
        'Format detail show dari server tidak valid.',
      );
    }
    return TvShow.fromJson(Map<String, dynamic>.from(data));
  }
}
