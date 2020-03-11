import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {

  final List<dynamic> peliculas;

  CardSwiper({ @required this.peliculas});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top:10.0),
      child: new Swiper(
        itemWidth   : _screenSize.width * 0.7,
        itemHeight  : _screenSize.height * 0.5,
        layout      : SwiperLayout.STACK,
        itemCount   : peliculas.length,
        itemBuilder : (BuildContext context,int index){
          return ClipRRect( // Para redonder las tarjetas 
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network("http://via.placeholder.com/350x150" , fit: BoxFit.cover,),
            //child: Text( peliculas[index].toString()),
          );
        },
      ),
    );
  }
}