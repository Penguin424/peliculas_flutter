import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/components/card_swiper_widget.dart';
import 'package:peliculas_flutter/src/components/movie_horizontal.dart';
import 'package:peliculas_flutter/src/providers/peliculas_provider.dart';

class HomePage extends StatelessWidget {

  PeliculasProvider peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Peliculas en cines'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search), 
              onPressed: (){}
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperCards(),
              _footer(context),
            ],
          ),
        )
      ),
    );
  }

  Widget _swiperCards() 
  {

    return FutureBuilder(
      future: peliculasProvider.getEnCine(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData)
        {
          return CardSwiper(
            peliculas: snapshot.data
          );
        }
        else
        {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );

  }

  Widget _footer(BuildContext context) 
  {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text('Populares', style: Theme.of(context).textTheme.subtitle1,),
          FutureBuilder(
            future: peliculasProvider.getPopular(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              snapshot.data?.forEach((element) => print(element.title));

              if(snapshot.hasData)
              {
                return MovieHorizontal(peliculas: snapshot.data);
              }
              else
              {
                return CircularProgressIndicator();
              }
              
            },
          ),
        ],
      ),
    );
  }

}