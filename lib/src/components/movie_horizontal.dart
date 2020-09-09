import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;

  MovieHorizontal({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * 0.20,
      child: PageView(
        children: _tarjetas(),
      ),
    );
  }

  List<Widget> _tarjetas() 
  {
    return peliculas.map((e){

      return Container(
          margin: EdgeInsets.only(right: 15.0),
          child: Column(
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(e.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              )
            ],
          ),
      );

    }).toList();
  }
}