import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/components/card_swiper_widget.dart';
import 'package:peliculas_flutter/src/components/movie_horizontal.dart';
import 'package:peliculas_flutter/src/providers/peliculas_provider.dart';
import 'package:peliculas_flutter/src/serach/search_delegate.dart';

class HomePage extends StatelessWidget {
  PeliculasProvider peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopular();

    return Container(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text('Peliculas en cines'),
            backgroundColor: Colors.indigoAccent,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search), 
                onPressed: () 
                {
                  showSearch(context: context, delegate: DataSeach());
                }
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
          )),
    );
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: peliculasProvider.getEnCine(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Populares',
                style: Theme.of(context).textTheme.subtitle1,
              )),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(peliculas: snapshot.data,  siguientepagina: peliculasProvider.getPopular);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
