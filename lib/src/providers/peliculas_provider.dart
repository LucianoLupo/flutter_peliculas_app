import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:peliculas_app/src/models/cast_model.dart';
import 'package:peliculas_app/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = 'f1b9b9a67ad160871cd3c76d04555677';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularPage = 0;
  bool _loading = false;

  List<Pelicula> _populars = new List();

  final _popularStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularSink => _popularStreamController.sink.add;

  Stream<List<Pelicula>> get popularsStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController?.close();
  }

  Future<List<Pelicula>> _getResponse(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getNowPlaying() async {
    final url = Uri.https(_url, '/3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _getResponse(url);
  }

  Future<List<Pelicula>> getPopular() async {
    if (_loading) return [];

    _loading = true;

    _popularPage++;

    final url = Uri.https(_url, '/3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularPage.toString()
    });

    final resp = await _getResponse(url);

    _populars.addAll(resp);
    popularSink(_populars);
    _loading = false;
    return resp;
  }

  Future<List<CastP>> getCast(String movieId) async {
    final url = Uri.https(_url, '/3/movie/${movieId}/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.cast;
  }

  Future<List<Pelicula>> getSearch(String query) async {
    print(query);
    final url = Uri.https(_url, '/3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _getResponse(url);
  }
}
