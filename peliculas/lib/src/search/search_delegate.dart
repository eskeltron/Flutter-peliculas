import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appBar 
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del Appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que se mostrarán
    return Container();
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Sugerencias que aparecen mientras la persona escribe

  //   final listaSugerida = query.isEmpty 
  //                         ? peliculasRecientes 
  //                         : peliculas.where( 
  //                           (p) => p.toLowerCase().startsWith(query.toLowerCase())
  //                         ).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i){
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //         onTap: (){
            
  //         }
  //       );
  //     }
  //   );
  // }

  @override 
  Widget buildSuggestions(BuildContext context){
    if ( query.isEmpty ) return Container();
    
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if( snapshot.hasData ){
          
          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map( (pelicula) {
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'), 
                    image: NetworkImage( pelicula.getPosterImg() ),
                    width: 50.0,
                    fit: BoxFit.contain, 
                  ),
                  title: Text( pelicula.title ),
                  subtitle: Text( pelicula.originalTitle ),
                  onTap: () {
                    close(context, null);
                    pelicula.uniqueId = '';
                    Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
                );
              }).toList(),
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }

}