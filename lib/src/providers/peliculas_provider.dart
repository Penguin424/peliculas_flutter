import 'dart:convert';

import 'package:peliculas_flutter/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider
{
  String _apikey = '4eb8e45ff03919edc63119eea8e8cd96';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<List<Pelicula>> getEnCine() async
  {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });

    final resp = await http.get( url );
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getPopular() async
  {
    final urlPoupular = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
    });

    final respPopular = await http.get(urlPoupular);
    final decodePopular = json.decode(respPopular.body);

    final populares = new Peliculas.fromJsonList(decodePopular['results']);

    return populares.items;

  }

}