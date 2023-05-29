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

  void retrieveInventarioDB(TstocksInventarios inventario) {
    DatabaseHelper.instance.insert(inventario);
  }
  void retrieveInventarioDetallesDB(TstocksDetallesInventario producto) {
    DatabaseHelper.instance.insertDetalles(producto);
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
        int ultimoid = await DatabaseHelper.instance.obtenerUltimoIdDetalles();
        TstocksDetallesInventario producto = TstocksDetallesInventario(
          linea: ultimoid,
          idDetalle: 0,
          idInventario: idinventario,
          idUnidadMedida: data["idProducto_idUnidadDeMedidaGeneral_nombre"]?["id"],
          descripcionUnidadMedida: data["idProducto_idUnidadDeMedidaGeneral_nombre"]?["descripcion"],
          idProducto: data["idProducto_nombre"]?["id"],
          descripcionProducto: data["idProducto_nombre"]?["descripcion"],
          idAlmacen: data["i"
              "dUbicacion_idAlmacen_descripcion"]?["id"],
          almacenDescripcion: data["idUbicacion_idAlmacen_descripcion"]?["descripcion"],
          idEmpaquetadoProducto: data["idEmpaquetadoProducto_descripcion"]?["id"],
          empaquetadoDescripcion: data["idEmpaquetadoProducto_descripcion"]?["descripcion"],
          idTipoDetalle: data["idTiposdetalle_descripcio"]?["id"] ?? 0,
          descripcionTipoDetalle: data["idTiposdetalle_descripcio"]?["descripcion"] ?? "",
          cantidad: data?["cantidadReal"] ?? 0,
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
  void initState() {
    super.initState();
    retrieveInventarios();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Inventarios'),
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
          future: generarEstructuraInventarios(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // O cualquier otro indicador de carga
            } else if (snapshot.hasError) {
              return Text('Error al cargar los inventarios');
            } else {
              return snapshot.data ?? Container(); // Devuelve el widget obtenido del Future o un Container vacío si es nulo
            }
          },
        )

    );
  }
}

Future<Widget> generarEstructuraInventarios() async {
  List<TstocksInventarios>inventariosBDlocal = await DatabaseHelper.instance.filtrarInventarios();
  print('OBJETOOOOOOOO');
  print(inventariosBDlocal.elementAt(0).descripcionInventario);
  print(inventariosBDlocal.elementAt(0).tipoInventarioDescripcion);
  print(inventariosBDlocal.elementAt(0).almacenDescripcion);
  print(inventariosBDlocal.elementAt(0).fechaRealizacionInventario);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        color: Colors.orange,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              inventariosBDlocal.elementAt(0).descripcionInventario!,
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
                  icon: Icon(Icons.mark_email_unread),
                  onPressed: () {
                    // Acción al presionar el IconButton
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(inventariosBDlocal.elementAt(0).tipoInventarioDescripcion!+inventariosBDlocal.elementAt(0).almacenDescripcion!),
                    Text(inventariosBDlocal.elementAt(0).fechaRealizacionInventario!),
                  ],
                ),
              ],
            ),
            SizedBox(height: 7),
          ],
        ),
      ),
    ],
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
