import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actor_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider{

  String _apiKey                      = 'aad213d82842c0e9763476e932f5645d';
  String _url                         = 'api.themoviedb.org';
  String _language                    = 'es-ES';
  int _popularesPage                  = 0;
  bool _cargando                      = false;
  List<Pelicula> _populares           = new List();
  final _popularesStreamController    = StreamController<List<Pelicula>>.broadcast();
  // para inserter información al stream, se específica que es de tipo List<Pelicula> para no equivocarse
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  // para obtener información del stream
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta( Uri url ) async{
    final respuesta   = await http.get(url);
    final decodedData  = json.decode(respuesta.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async{

    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key'   : _apiKey,
      'language'  : _language,
    });

    return _procesarRespuesta(url);

  }

  Future<List<Pelicula>> getPopulares() async{

    if( _cargando ) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular',{
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink( _populares );

    _cargando = false;
    return resp;

  }

  Future<List<Actor>> getCast(String peliId) async {
    
    final url = Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key'   : _apiKey,
      'language'  : _language,
    });

    final respuesta = await http.get(url);

    final decodedData = json.decode(respuesta.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;

  }

  Future<List<Pelicula>> buscarPelicula( String query ) async{

    final url = Uri.https(_url, '3/search/movie',{
      'api_key'   : _apiKey,
      'language'  : _language,
      'query'     : query,
    });

    return _procesarRespuesta(url);

  }
}