import 'package:flutter/material.dart';

import 'package:peliculas/src/models/actor_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments; 

    return Scaffold(
      body: SafeArea(
        child:CustomScrollView(

          slivers: <Widget>[
            _crearAppbar( pelicula ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox( height: 10.0),
                  _posterTitulo( pelicula, context ),
                  _descripcion( pelicula ),
                  _descripcion( pelicula ),
                  _descripcion( pelicula ),
                  _descripcion( pelicula ),
                  _descripcion( pelicula ),
                  _crearCasting( pelicula, context )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

Widget _crearAppbar(Pelicula pelicula){
  
  return SliverAppBar(
    elevation: 2.0,
    backgroundColor: Colors.indigoAccent,
    expandedHeight: 200.0,
    floating: false,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      title:
      Text(
        pelicula.title,
        style:TextStyle(color: Colors.yellow, fontSize: 16.0, ),
      ),
      background: FadeInImage(
        placeholder: AssetImage('assets/img/loading.gif'), 
        image: NetworkImage(pelicula.getBackgroundImg()),
        fadeInDuration: Duration(milliseconds: 150),
        fit: BoxFit.cover,
      ),
    ),
  );

}

Widget _posterTitulo(Pelicula pelicula, BuildContext context){
  
  return Container(
    padding: EdgeInsets.symmetric(horizontal:20.0),
    child: Row(
      children: <Widget>[
        Hero(
          tag: pelicula.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: NetworkImage( pelicula.getPosterImg() ),
              height: 150.0,
            ),
          ),
        ),
        SizedBox( width: 20.0),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[ 
              Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
              Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
              Row(
                children: <Widget>[
                  Icon( Icons.star_border ),
                  Text( pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead )
                ],
              )
            ],
          )
        ),
      ],
    ),
  );

}

Widget _descripcion( Pelicula pelicula ){

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
    child: Text(
      pelicula.overview,
      textAlign: TextAlign.justify,
    ),
  );

}

Widget _crearCasting( pelicula, BuildContext context ){

  final peliProvider = new PeliculasProvider();

  Widget _actorTarjeta( Actor actor){
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage( actor.getPosterImg() ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover
            ),
          ),
          Text( 
            actor.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.button,
          ) 
        ],
      )
    );
  }

 Widget _crearActoresPageView(List<Actor> actores){
   
   return SizedBox(
     height:200.0,
     child:PageView.builder(
       pageSnapping: false,
       controller: PageController(
         viewportFraction: 0.3,
         initialPage: 1
       ),
       itemCount: actores.length,
       itemBuilder: (context, i) => _actorTarjeta( actores[i] ),
     )
   );

 }

  

  return FutureBuilder(
    future: peliProvider.getCast( pelicula.id.toString() ),
    builder: (context, AsyncSnapshot<List> snapshot) {
      if(snapshot.hasData) {
        return _crearActoresPageView( snapshot.data);
      }else{
        return Center(child:CircularProgressIndicator());
      }
    },
  );

}