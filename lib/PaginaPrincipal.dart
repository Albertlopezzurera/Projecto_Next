import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectobueno/DatabaseHelper.dart';
import 'package:projectobueno/TstocksInventarios.dart';
import 'package:projectobueno/User.dart';
import 'package:projectobueno/FiltrosInventario.dart';
import 'package:projectobueno/ListaProductos.dart';
import 'package:projectobueno/LlamadaApi.dart';
import 'package:projectobueno/Myapp.dart';
import 'package:projectobueno/NewInventario.dart';
import 'TstocksDetallesInventario.dart';


const List<String> opcionOrdenacion = ['ASC', 'DESC'];
const List<String> criteriosOrdenacion = [
  'Fecha',
  'Tipo de inventario',
  'Estado de inventario'
];

///
/// Clase paginaPrincipal la cual extiende de StatelessWidget el equivalente a Activity de Java
/// Esta clase muestra la pantalla de la lista de inventarios.
/// Recibe por parametros un objeto de tipo User, el cual contendrá el token para poder hacer peticiones a la API
///
class paginaPrincipal extends StatelessWidget {
  paginaPrincipal(User usuario);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVENTARIO SUPERMERCADO',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: PageHome(title: 'LISTA DE INVENTARIOS'),
    );
  }
}

class PageHome extends StatefulWidget {
  final String title;
  PageHome({required this.title});

  @override
  _PageHomeState createState() => _PageHomeState();

}

class _PageHomeState extends State<PageHome> {
  bool backButton = false;
  List<TstocksInventarios> listaInventarios = [];

  void retrieveInventarioDB(TstocksInventarios inventario) {
    DatabaseHelper.instance.insert(inventario);
  }
  void retrieveInventarioDetallesDB(TstocksDetallesInventario producto) {
    DatabaseHelper.instance.insertDetalles(producto);
  }

  ///
  /// Metodo que ejecuta la clase cada vez que carga por primera vez esta vista
  ///
  @override
  void initState() {
    super.initState();
    recogerInventarios(listaInventarios);
  }

  ///
  /// Layout que se carga para la vista del usuario
  /// Donde volvemos a encontrarnos una AppBar la cual contiene el titulo de la pantalla, un boton que tiene un icono y un boton en el margen inferior del layout
  /// el cual contiene una navegacion.
  /// Todos los botones que se encuentran en el margen inferior se crean a traves de un FloatingActionButton
  /// Tambien encontramos en la parte superior izquierda un IconButton que se desplega un menu lateral el cual tenemos diferentes opciones.
  /// En primer lugar encontramos el nombre de usuario junto con el logo de la empresa
  /// En segundo lugar encontramos una opcion de 'Nuevo inventario'
  /// En tercer lugar encontramos la opción de 'Lista de inventarios'
  /// En cuarto lugar encontramos la opción de 'Cerrar Sesión'
  ///
  /// Cada boton tiene su respectivo Navigation.push el cual te lleva hasta la actividad de la opción
  /// Por ultimo tenemos el body:
  /// Este body es un Listview.builder es una lista que se genera a partir de unos parametros, estos parametros se realizan en la funcion
  /// [generarEstructuraInventarios], que es lo que el usuario ve en la interfaz, la lista de inventarios
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('LISTA DE INVENTARIOS'),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () {
                filtrarInventarios(context);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => newInventario(usuario)),
            );
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: Drawer(
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    alignment: Alignment.centerLeft,
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(width: 8), // Espacio entre el logo y el texto
                  Expanded(
                    child: Text(
                      'NEXTT.DIRECTOR APP',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(usuario.nombre),
                  Text(usuario.dominio),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
              // Resto del código...
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => newInventario(usuario)),
                  );
                },
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_box_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => newInventario(usuario)),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text('Nuevo inventario'),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => paginaPrincipal(usuario)),
                  );
                },
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.library_books),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => paginaPrincipal(usuario)),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    // Agrega un espacio entre el icono y el texto
                    Text('Lista de inventarios'),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.grey,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('ATENCIÓN!'),
                        content: Text("Está seguro que quiere cerrar la sesión?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text("Sí"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyApp()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    // Agrega un espacio entre el icono y el texto
                    Text('Cerrar sesión'),

                  ],
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<Widget>(
          future: generarEstructuraInventarios(listaInventarios),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras se espera la resolución del Future
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Muestra un widget de error si ocurre un error durante la obtención de los datos
              return Text('Error al cargar los datos');
            } else {
              // El Future se ha resuelto exitosamente, muestra el widget resultante
              return snapshot.data!;
            }
          },
        )

    );
  }
}

///
/// Metodo recogerInventarios que realiza una instancia a DatabaseHelper para recoger en la variable [lista] la lista de inventarios
///
Future<void> recogerInventarios(List<TstocksInventarios> listaInventarios) async {
  List<TstocksInventarios> lista = await DatabaseHelper.instance.filtrarInventarios();
  if (lista.isNotEmpty){
    for (int i=0; i<lista.length;i++){
      listaInventarios.add(lista.elementAt(i));
    }
  }
}

///
/// Metodo para cargar en una estructura igual para cada inventario una lista de Inventarios
/// En este caso llamamos al metodo [recogerInventarios] para recoger la informacion y la cantidad de inventarios
///
/// Como es posible que tengamos mas de un inventario y queremos evitar errores de repeticion de inventarios al volver a esta pantalla
/// desde otras actividades, hemos hecho un Set para evitar que tengamos varios inventarios repetidos
///
/// Como podemos ver en Listview.Builder tenemos los parametros que hay que pasar que son:
/// itemCount: Lista que tendra esos inventarios y queremos saber el tamaño para que me haga esta estructura tantas veces como inventarios haya
/// itemBuilder: Le pasamos el contexto de la actividad y un indice para recoger los elementos sobre ese indice
///
Future<Widget> generarEstructuraInventarios(List<TstocksInventarios> listaInventarios) async {
  recogerInventarios(listaInventarios);
  List<TstocksInventarios> lista = await DatabaseHelper.instance.filtrarInventarios();
  if (lista.isNotEmpty){
    for (int i=0; i<lista.length;i++){
      listaInventarios.add(lista.elementAt(i));
    }
  }
  if (listaInventarios.isEmpty){
    return Container();
  }
  Set<int> idsInventario = {};
  List<TstocksInventarios> listaInventariosNoRepetidos = [];

  for (var inventario in listaInventarios) {
    if (!idsInventario.contains(inventario.idInventario)) {
      idsInventario.add(inventario.idInventario);
      listaInventariosNoRepetidos.add(inventario);
    }
  }

  return ListView.builder(
    itemCount: listaInventariosNoRepetidos.length,
    itemBuilder: (BuildContext context, int index) {
      var color;
      if (listaInventariosNoRepetidos.elementAt(index).tipoInventarioDescripcion == 'Total') {
        color = Colors.redAccent;
      } else {
        color = Colors.orange;
      }
      var icon;
      if (listaInventariosNoRepetidos.elementAt(index).estadoInventario == 'CERRADO') {
        icon = Icons.mark_email_read;
      } else {
        icon = Icons.mark_as_unread;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () async {
              if (listaInventariosNoRepetidos.elementAt(index).estadoInventario=='ABIERTO'){
                List<TstocksDetallesInventario> listaProductos = await DatabaseHelper.instance.filtrarDetallesInventarioPorId(listaInventariosNoRepetidos.elementAt(index).idInventario);
                listaInventariosNoRepetidos.elementAt(index).detallesInventario=listaProductos;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaProductos(usuario,
                      listaInventariosNoRepetidos.elementAt(index),
                    ),
                  ),
                );
              }
            },
            child: Card(
              color: color,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Container(
                  color: color,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        listaInventariosNoRepetidos.elementAt(index).descripcionInventario.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(icon),
                            onPressed: () {
                              // Acción al presionar el IconButton
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(listaInventariosNoRepetidos.elementAt(index).tipoInventarioDescripcion.toString() +' '+ listaInventarios[index].almacenDescripcion.toString()),
                              Text(listaInventariosNoRepetidos.elementAt(index).fechaRealizacionInventario.toString()),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

///
/// Metodo para cargar los filtros de inventarios haciendo una llamada a la API.
/// Primero se hace una llamada a la API y con la respuesta llamamos al metodo filtrosInventario que se encuentra en una clase
/// que busca los campos especificos para mostrar en los filtros
///
Future<void> filtrarInventarios(BuildContext context) async {
  final inventarios = await API.getFiltrosInventarios(usuario);
  final List<Inventario> listaInventarios =
      filtrosInventario.fromJson(inventarios).inventario;
  final List nombresTiendas =
  listaInventarios.map((inventario) => inventario.getNombreTienda).toList();
  final List tipoInventario = listaInventarios
      .map((inventario) => inventario.getTipoInventario)
      .toList();
  final List estadoInventario = listaInventarios
      .map((inventario) => inventario.getEstadoInventario)
      .toList();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<CheckboxListTileOption> tiendas = nombresTiendas
            .map((categoria) => CheckboxListTileOption(title: categoria))
            .toList();
        final List<CheckboxListTileOption> tiposInventario = tipoInventario
            .map((categoria) => CheckboxListTileOption(title: categoria))
            .toList();
        final List<CheckboxListTileOption> estadosInventario = estadoInventario
            .map((categoria) => CheckboxListTileOption(title: categoria))
            .toList();
        return AlertDialog(
          title: Text('Tiendas'),
          content: SingleChildScrollView(
            child: Column(children: [
              buildListTile('Tiendas'),
              ...tiendas,
              Divider(),
              buildListTile('Tipo de inventario'),
              ...tiposInventario,
              Divider(),
              buildListTile('Estado de inventario'),
              ...estadosInventario,
              Divider(),
              buildListTile('Criterios de ordenación'),
              MyOrderListTile(
                title: '1er Criterio',
                criterios: criteriosOrdenacion,
                ordenacion: opcionOrdenacion,
                onCriterioSelected: (int selectedCriterioIndex) {
                  // código a ejecutar cuando se seleccione un criterio
                },
                onOrdenacionSelected: (int selectedOrdenacionIndex) {
                  // código a ejecutar cuando se seleccione un criterio
                },
              ),
              MyOrderListTile(
                title: '2o Criterio',
                criterios: criteriosOrdenacion,
                ordenacion: opcionOrdenacion,
                onCriterioSelected: (int selectedCriterioIndex) {
                  // código a ejecutar cuando se seleccione un criterio
                },
                onOrdenacionSelected: (int selectedOrdenacionIndex) {
                  // código a ejecutar cuando se seleccione un criterio
                },
              ),
              MyOrderListTile(
                title: '3er Criterio',
                criterios: criteriosOrdenacion,
                ordenacion: opcionOrdenacion,
                onCriterioSelected: (int selectedCriterioIndex) {
                  // código a ejecutar cuando se seleccione un criterio
                },
                onOrdenacionSelected: (int selectedOrdenacionIndex) {
                  // código a ejecutar cuando se seleccione un criterio
                },
              )
            ]),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check),
              color: Colors.green,
              alignment: Alignment.bottomRight,
              iconSize: 50.0,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
              color: Colors.red,
              alignment: Alignment.bottomLeft,
              iconSize: 50.0,
            ),
          ],
        );
      });
}

///
/// Metodo para devolver un texto con un formato especifico
///
ListTile buildListTile(String title) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    tileColor: Colors.grey[200],
  );
}