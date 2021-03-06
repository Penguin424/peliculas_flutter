import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/models/pelicula_model.dart';

import '../models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientepagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientepagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _pageController.addListener(() {
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        siguientepagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.23,
      child: PageView.builder(
        controller: _pageController,
        // children: _tarjetas(_screenSize, context),
        pageSnapping: false,
        itemCount: peliculas.length,
        itemBuilder: (context, i)
        {
          peliculas[i].uniqueId = '${peliculas[i].id}-card';

          return _tarjeta(context, peliculas[i], _screenSize);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula e, media)
  {
      final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: e.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(e.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: media.height * 0.20,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              e.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

      return GestureDetector(
        child: tarjeta,
        onTap: (){
          Navigator.pushNamed(context, 'detalle', arguments: e);
        }
      );
  }

  List<Widget> _tarjetas(media, BuildContext context) {
    return peliculas.map((e) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(e.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: media.height * 0.20,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              e.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
