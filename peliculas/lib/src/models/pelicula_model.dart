class Peliculas {

  List<Pelicula> items = new List();

  Peliculas();

  Peliculas.fromJsonList( List<dynamic> jsonList){

    if( jsonList == null) return;

    for( var item in jsonList){
      final pelicula = new Pelicula.fromJsonMap(item);
      items.add(pelicula);
    }

  }

}

class Pelicula {

  String uniqueId;

  String posterPath;
  bool adult;
  String overview;
  String releaseDate;
  List<int> genreIds;
  int id;
  String originalTitle;
  String originalLanguage;
  String title;
  String backdropPath;
  double popularity;
  int voteCount;
  bool video;
  double voteAverage;

  Pelicula({
    this.posterPath,
    this.adult,
    this.overview,
    this.releaseDate,
    this.genreIds,
    this.id,
    this.originalTitle,
    this.originalLanguage,
    this.title,
    this.backdropPath,
    this.popularity,
    this.voteCount,
    this.video,
    this.voteAverage,
  });

  Pelicula.fromJsonMap( Map<String, dynamic> json){
    this.posterPath       = json['poster_path'];
    this.adult            = json['adult'];
    this.overview         = json['overview'];
    this.releaseDate      = json['release_date'];
    this.genreIds         = json['genre_ids'].cast<int>();
    this.id               = json['id'];
    this.originalTitle    = json['original_title'];
    this.originalLanguage = json['original_language'];
    this.title            = json['title'];
    this.backdropPath     = json['backdrop_path'];
    this.popularity       = json['popularity'] / 1;
    this.voteCount        = json['vote_count'];
    this.video            = json['video'];
    this.voteAverage      = json['vote_average'] / 1;
  }

  getPosterImg(){
    if(posterPath == null) return 'https://pngimage.net/wp-content/uploads/2018/06/imagen-no-disponible-png-4.png';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
  getBackgroundImg(){
    if(posterPath == null) return 'https://pngimage.net/wp-content/uploads/2018/06/imagen-no-disponible-png-4.png';
    return 'https://image.tmdb.org/t/p/w500$backdropPath';
  }
}
