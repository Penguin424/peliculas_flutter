import 'dart:async';
import 'dart:convert';

import 'package:peliculas_flutter/src/models/actores_model.dart';
import 'package:peliculas_flutter/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

import '../models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '4eb8e45ff03919edc63119eea8e8cd96';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStream = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStream.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStream.stream;

  void disposeSteams() {
    _popularesStream?.close();
  }

  Future<List<Pelicula>> getEnCine() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    

    return peliculas.items;
  }

  Future<List<Pelicula>> getPopular() async {

    if(_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final urlPoupular = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final respPopular = await http.get(urlPoupular);
    final decodePopular = json.decode(respPopular.body);

    final populares = new Peliculas.fromJsonList(decodePopular['results']);

    _populares.addAll(populares.items);
    popularesSink(_populares);

    _cargando = false;

    return populares.items;
  }

  Future<List<Actor>> getCast(String peliId) async 
  {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apikey,
      'language': _language,
    });

    final res = await http.get(url);
    final decodedData = json.decode(res.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
    
  }
}
