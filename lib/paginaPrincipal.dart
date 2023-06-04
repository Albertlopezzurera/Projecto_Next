import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectobueno/DatabaseHelper.dart';
import 'package:projectobueno/TstocksInventarios.dart';
import 'package:projectobueno/User.dart';
import 'package:projectobueno/filtrosInventario.dart';
import 'package:projectobueno/listaProductos.dart';
import 'package:projectobueno/llamadaApi.dart';
import 'package:projectobueno/myapp.dart';
import 'package:projectobueno/newInventario.dart';


import 'TstocksDetallesInventario.dart';
const List<String> opcionOrdenacion = ['ASC', 'DESC'];
const List<String> criteriosOrdenacion = [
  'Fecha',
  'Tipo de inventario',
  'Estado de inventario'
];

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
  List<TstocksInventarios> listaInventarios = [];
  void retrieveInventarioDB(TstocksInventarios inventario) {
    DatabaseHelper.instance.insert(inventario);
  }
  void retrieveInventarioDetallesDB(TstocksDetallesInventario producto) {
    DatabaseHelper.instance.insertDetalles(producto);
  }

  @override
  void initState() {
    super.initState();
    retrieveInventarios();
    recogerInventarios(listaInventarios);
  }

  Future<List<TstocksDetallesInventario>> retrieveInventarioDetalles(int idinventario) async {

    var token = usuario.token;

    final response = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/detallesInventario"),
      headers: {"Authorization": "Bearer $token"},
    );
    List<TstocksDetallesInventario> listaproductos = [];
    for (var data in jsonDecode(response.body)) {

      if (idinventario == data["idInventario_descripcion"]["id"] as int) {

        final productos = await API.getFiltrosProductos(usuario);
        int idproducto = data["idProducto_nombre"]?["id"];
        int idcategoriaprincipal = 0;
        String categoriadescripcion = "";
        int subcategoriaid = 0;
        String subcategoriadescripcion = "";

        for (int i = 0; i < productos.length; i++) {
          dynamic elemento = productos[i];
          if (idproducto == elemento["id"]) {
            idcategoriaprincipal = elemento["idCategoriaEstadisticas_pathCompleto"]["id"];
            categoriadescripcion = elemento["idCategoriaEstadisticas_pathCompleto"]["descripcion"];
            subcategoriaid = elemento["idCategoriaEstadisticas_nombre"]["id"];
            subcategoriadescripcion = elemento["idCategoriaEstadisticas_nombre"]["descripcion"];
            break;

          }
        }


        int ultimoid = await DatabaseHelper.instance.obtenerUltimoIdDetalles();
        TstocksDetallesInventario producto = TstocksDetallesInventario(
          linea: ultimoid,
          idInventario: idinventario,
          idUnidadMedida: data["idProducto_idUnidadDeMedidaGeneral_nombre"]?["id"],
          descripcionUnidadMedida: data["idProducto_idUnidadDeMedidaGeneral_nombre"]?["descripcion"],
          idProducto: data["idProducto_nombre"]?["id"],
          descripcionProducto: data["idProducto_nombre"]?["descripcion"],
          idAlmacen: data["idUbicacion_idAlmacen_descripcion"]?["id"],
          almacenDescripcion: data["idUbicacion_idAlmacen_descripcion"]?["descripcion"],
          idEmpaquetadoProducto: data["idEmpaquetadoProducto_descripcion"]?["id"],
          empaquetadoDescripcion: data["idEmpaquetadoProducto_descripcion"]?["descripcion"],
          idcategoriaprincipal: idcategoriaprincipal,
          categoriaprincipaldescripcion: categoriadescripcion,
          subcategoriaid: subcategoriaid,
          subcategoriadescripcion: subcategoriadescripcion,
          cantidad: data?["cantidadReal"] ?? 0,
          cantidadtotal: data?["cantidadRealTotal"] ?? 0,
          cantidadcaja: double.tryParse(data["idEmpaquetadoProducto_factorEmpaquetado"]["descripcion"]) ?? 0,
        );
        listaproductos.add(producto);
        retrieveInventarioDetallesDB(producto);
      }
    }
    return listaproductos;

  }

  Future<void> retrieveInventarios() async {
    var token = usuario.token;

    final response = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios"),
      headers: {"Authorization": "Bearer $token"},
    );


    for (var data in jsonDecode(response.body)) {
      if (usuario.iddominio == data["idDominio_descripcion"]["id"] as int) {
        var isitempty = await DatabaseHelper.instance.filtrarInventarioporId(data["id"]);
        if (!isitempty) {
          print(data["descripcion"]);
          int ultimoid = await DatabaseHelper.instance.obtenerUltimoId();
          TstocksInventarios
          inventarioexistente = TstocksInventarios(
            idInventario: ultimoid,
            identificador: data["id"],
            idDominio: data["idDominio_descripcion"]?["id"],
            dominioDescripcion: data["idDominio_descripcion"]?["descripcion"],
            descripcionInventario: data["descripcion"],
            idAlmacen: data["idAlmacen_descripcion"]?["id"],
            almacenDescripcion: data["idAlmacen_descripcion"]?["descripcion"],
            idTienda: data["idTienda_descripcion"]?["id"],
            tiendaDescripcion: data["idTienda_descripcion"]?["descripcion"],
            fechaRealizacionInventario: data["fechaRealizacionInventario"],
            idTipoInventario: data["idTipoInventario_descripcion"]?["id"],
            tipoInventarioDescripcion: data["idTipoInventario_descripcion"]?["descripcion"],
            idEstadoInventario: data["idEstadoInventario_descripcion"]?["id"],
            estadoInventario: data["idEstadoInventario_descripcion"]?["descripcion"],
            detallesInventario: await retrieveInventarioDetalles(data["id"]),
          );
          retrieveInventarioDB(inventarioexistente);
          print(inventarioexistente.toString());
        }
      }
    }
  }
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

Future<void> recogerInventarios(List<TstocksInventarios> listaInventarios) async {
  List<TstocksInventarios> lista = await DatabaseHelper.instance.filtrarInventarios();
  print(lista.toString());
  if (lista.isNotEmpty){
    for (int i=0; i<lista.length;i++){
      listaInventarios.add(lista.elementAt(i));
    }
    print('LISTAINVENTARIOS');
    print(listaInventarios.toString());
  }
}

Future<Widget> generarEstructuraInventarios(List<TstocksInventarios> listaInventarios) async {
  recogerInventarios(listaInventarios);
  List<TstocksInventarios> lista = await DatabaseHelper.instance.filtrarInventarios();
  print(lista.toString());
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