import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/models/actores_model.dart';
import 'package:peliculas_flutter/src/models/pelicula_model.dart';
import 'package:peliculas_flutter/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    final Size _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),
                _posterTitutlo(context ,pelicula),
                _descripcion(pelicula),
                _crearCasting(pelicula, _screenSize),
              ]
            ),
          ),
        ],
      )
    );
  }

  Widget _crearAppBar(Pelicula pelicula) 
  {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitutlo(BuildContext context, Pelicula pelicula) 
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(
                  pelicula.getPosterImg()
                ),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pelicula.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1,),
                    SizedBox(width: 50.0,),
                    Icon(Icons.closed_caption),
                    Text(pelicula.popularity.toString(), style: Theme.of(context).textTheme.subtitle1,),
                  ],
                )
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) 
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        '${pelicula.overview}',
        textAlign: TextAlign.justify,
      ),
    );   
  }

  Widget _crearCasting(Pelicula pelicula, Size size) 
  {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
        if(snapshot.hasData) 
        {
          return _crearActoresPageView(context, snapshot.data, size);
        }
        else
        {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _crearActoresPageView( BuildContext context, List<Actor> actores, Size media) 
  {
    return Container(
      padding: EdgeInsets.only(top: media.height * 0.02),
      child: SizedBox( 
        height: 200.0,
        child: PageView.builder(
          pageSnapping: false,
          itemCount: actores.length,
          controller: PageController(
            viewportFraction: 0.3,
            initialPage: 1,
          ),
          itemBuilder: (context, i) {
            return _tarjeta(context, actores[i], media);
          },
        ),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Actor e, media)
  {
      final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(e.getActorImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: media.height * 0.20,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              e.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

    return tarjeta;
  }

}