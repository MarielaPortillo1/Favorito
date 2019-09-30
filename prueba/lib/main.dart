import 'package:flutter/material.dart';
//importar paquete de palabras random
import 'package:english_words/english_words.dart';

//funcion flecha
void main()=>runApp(MyApp());

//Widget sin estado
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      //quita la marca de debug al ejecutar
      debugShowCheckedModeBanner: false,
      title: 'Bienvenido a mi prueba',

      //themas de el AppBar para toda la aplicacion seleccionando el color
      theme: ThemeData(
        //color primario para el tema
        primaryColor: Colors.green,
      ),

        //le pasamos el widget con estado
        home:  RandomWords(),
    );
  }
}

//Widget con estado
class  RandomWords extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return RandomWordsState();
  }

}

//Estado del Widget
class RandomWordsState extends State<RandomWords>{

  //_lista indica clase privada
  // WordPair funcion del paquete importado para palabras random
  final _lista=<WordPair>[];
  final _saved = Set<WordPair>();  //SET listado de objetos unicos
  final _estilotexto = const TextStyle(fontSize: 18.0); //una funcion estandar para el estilo de letra de la aplicacion

  @override
  Widget build(BuildContext context) {
    final palabras = new WordPair.random(); //le indicamos el par de palabras random

    return Scaffold(
      appBar: AppBar(

        title: Text('Bienvenido ami prueba'),
        actions: <Widget>[     //para indicarle una accion del icono
          IconButton(
            icon: Icon(
              Icons.list,   //icono del tipo list que se mostrara en el AppBar para desplazarnos a otra ruta o pagina
            ),

            onPressed: _pushSaved, //al precionar se guarde el valor con el metodo que le indicamos
          ),
        ],

      ),

      body: _listaresultado(), //mostramos el resultado del listado octenido

    );
  }



  void _pushSaved(){
    //nueva pagina a navegar
    Navigator.of(context).push(MaterialPageRoute(builder: (Context) {
      final listado = _saved.map((pair) { //mapeo del listado de par de palabras
        return ListTile(
          title: Text(
            pair.asPascalCase, //palabras random del tipo pascaCase
            style: _estilotexto, //estilo estandar de la letra

          ),

        );
      });

      final divide = ListTile.divideTiles(  // variable que devuelve el titulo de la lista
          context: context,
          tiles: listado).toList();
      return Scaffold( //nuevo cuepo de la pagina segundaria por la cual navegaremos

        appBar: AppBar(
          title: Text('Nuevo pagina'),

        ),
        body: ListView(children: divide,), //la lista que recibe un hijo de widget
      );

    }));
  }



  Widget _listaresultado(){

    return ListView.builder(
      //funcion que recibe  contex un indice o anonima funcion

      // espacio de las palabras
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){

        if (i.isOdd){ //indice de la letra es impar que retorne una linea
          return Divider();
        }

        if(i>=_lista.length){ //el indice es mayor a la lista recorrida que nos cuente

          _lista.addAll(generateWordPairs().take(10)); //si se cumple agregamos 10 pares de palbras

        }
        // divicion
        final index =i~/2;
        return _palabrasobtenidas(_lista[index]);

      } ,

    );

  }
  Widget _palabrasobtenidas(WordPair pair){
    // indica si la palabra esta seleccionada
     final palabraExistente = _saved.contains(pair);

    return ListTile(
      title: Text(

        pair.asPascalCase,
        style: _estilotexto,
      ),

      //parametro que permite agregar icono de favoritos
      trailing: Icon(
        palabraExistente ? Icons.favorite: Icons.favorite_border, //si hay palabra seleccionada que el icono favorito y si no el icono favorito solo con borde
        color: palabraExistente ? Colors.pink : null,  //y que si la palabra esta seleccionada que se muestre de color rojo

      ),

      onTap:(){   // funcion que ejecuta al dar clic al elemento
        setState(() {
          if(palabraExistente){   //si la palabra ya esta seleccionada que la remueva
            _saved.remove(pair);
          }else{
            _saved.add(pair); //si no que la agrege
          }
        });
      } ,
    );
  }
}