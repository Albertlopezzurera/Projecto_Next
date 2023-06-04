import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projectobueno/DatabaseHelper.dart';
import 'package:projectobueno/TstocksDetallesInventario.dart';
import 'package:projectobueno/TstocksInventarios.dart';
import 'package:projectobueno/User.dart';
import 'package:projectobueno/cameraQR.dart';
import 'package:projectobueno/filtrosProductos.dart';
import 'package:projectobueno/myapp.dart';
import 'package:projectobueno/newInventario.dart';
import 'package:projectobueno/paginaPrincipal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'llamadaApi.dart';

class ListaProductos extends StatefulWidget {
  final User usuario; // Agregar esta línea
  final TstocksInventarios inventarioexistente;
  ListaProductos(this.usuario, this.inventarioexistente);
  final String title = 'LISTA INVENTARIOS';
  @override
  _ListaProductosState createState() => _ListaProductosState();
}

class _ListaProductosState extends State<ListaProductos> {
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String itemSelecionadoCriterio = criteriosOrdenacion.first;
  String itemSelecionadoOpcionOrdenacion = opcionOrdenacion.first;
  List<int> listaProductosTargeta = [];

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQueryController.clear();
    });
  }

  AppBar buildAppBar(BuildContext context) {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _stopSearch,
        ),
        title: TextField(
          controller: _searchQueryController,
          decoration: InputDecoration(
            hintText: "Buscar...",
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print(_searchQueryController.text);
            },
          ),
        ],
      );
    } else {
      return AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(widget.title),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _startSearch,
          ),
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: _showFiltrosDialog,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LISTA PRODUCTOS');
    print(widget.inventarioexistente.detallesInventario);
    filtrosProductos;

    return Scaffold(
      appBar: buildAppBar(context),
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
      body: Container(
        //TODO PAGINA PRINCIPAL PARA HACER PRODUCTOS
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: widget.inventarioexistente.detallesInventario ==
                                null
                        ? Container() // Contenedor vacío si detallesInventario es null o está vacío
                        : TargetasProducto(widget.inventarioexistente),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(23.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: Text("ATENCIÓN!"),
                      content: Text(
                          "Se han realizado cambios que no han sido guardados, si sale sin guardar se perderán. \n Desea salir sin guardar los cambios?"),
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
                              //GUARDAR INVENTARIO COMO CERRADO
                              MaterialPageRoute(
                                  builder: (context) =>
                                      paginaPrincipal(usuario)),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () async {
                if (widget.inventarioexistente.detallesInventario!.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('ERROR'),
                        content: Text('No hay productos para guardar'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  print('HOLA');
                  for (int i = 0; i < widget.inventarioexistente.detallesInventario!.length; i++) {
                    DatabaseHelper.instance.updateDetalles(widget.inventarioexistente.detallesInventario!.elementAt(i));
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmacion'),
                        content: Text('Inventario guardado correctamente'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => paginaPrincipal(usuario),
                                ),
                              );
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Icon(Icons.save),
              backgroundColor: Colors.greenAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: Text("ATENCIÓN!"),
                      content: Text(
                          "Si cierra el inventario no podrá modificarlo \n Desea guardar y cerrar el inventario?"),
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
                            for (int i = 0; i<widget.inventarioexistente.detallesInventario!.length; i++){
                              DatabaseHelper.instance.updateDetalles(widget.inventarioexistente.detallesInventario!.elementAt(i));
                            }
                            cerrarInventario(widget.inventarioexistente);
                            widget.inventarioexistente.idEstadoInventario=2;
                            widget.inventarioexistente.estadoInventario='CONFIRMADO';
                            Navigator.push(
                              context,
                              //GUARDAR INVENTARIO COMO CERRADO
                              MaterialPageRoute(
                                  builder: (context) =>
                                      paginaPrincipal(usuario)),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.save_as_outlined),
              backgroundColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                // Acción del segundo botón flotante
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CameraQR(widget.usuario, widget.inventarioexistente)),
                );
              },
              child: Icon(Icons.camera_alt),
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> cerrarInventario(TstocksInventarios inventario) async {

    var token = usuario.token;
    var iddominio = usuario.iddominio;
    var idinventario = null;

    // Construye el cuerpo de la solicitud
    var body = jsonEncode({
      "codigo": inventario.idInventario,
      "descripcion": inventario.descripcionInventario,
      "fechaRealizacionInventario": inventario.fechaRealizacionInventario,
      "idAlmacen": {"id": inventario.idAlmacen},
      "idDominio": {"id": inventario.idDominio},
      "idEstadoInventario": {"id": inventario.idEstadoInventario, "valor": inventario.estadoInventario},
      "idTienda": {"id": inventario.idTienda},
      "idTipoInventario": {"id": inventario.idTipoInventario}
    });

    final response = await http.post(
      Uri.parse("https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Inventario creado exitosamente');
    } else {
      print('Ocurrió un error al cerrar el inventario. Código de estado: ${response.statusCode}');
    }


    final getinventarioid = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios"),
      headers: {"Authorization": "Bearer $token"},
    );

    for (var data in jsonDecode(getinventarioid.body)) {
      print(data["id"]);
      if (inventario.idInventario == int.tryParse(data["codigo"]) && inventario.descripcionInventario == data["descripcion"]) {
        idinventario = data["id"] as int;
        break;
      }

    }
    print(idinventario);
    print(iddominio);

    /*  var inventariodescripcion = inventario.getDescripcionInventario;

    final bodyproduct = {
      'idInventario_descripcion': '{"id": $idinventario, "descripcion": $inventariodescripcion}',
      'idProducto_idUnidadDeMedidaGeneral_nombre': '{"id": 5, "codigo": "00005", "descripcion": "Kilos"}',
      'idProducto_nombre': '{"id": 1600, "codigo": "000062", "descripcion": "CAFE EN GRANO"}',
      'cantidadReal': '1',
      'cantidadTeorica': '0',
      'fechaHora': '18/05/2023 22:11',
      'fechaUltimoInventario': '01/12/2019 00:00',
      'idUbicacion_idAlmacen_descripcion': '{"id": 1, "codigo": "001", "descripcion": "Almacen Principal"}',
      'idEmpaquetadoProducto_descripcion': '{"id": 8, "codigo": 8, "descripcion": "Caja 12 Kilos"}',
      'idEmpaquetadoProducto_factorEmpaquetado': '{"id": 8, "codigo": 8, "descripcion": "12"}',
      'idTiposdetalle_descripcion': '{"id": 1, "codigo": "001", "descripcion": "Empaquetado"}',
      'idUbicacion_descripcion': '{"id": 1, "codigo": "1", "descripcion": "Ubicacion General"}',
      'idProducto_idProductoModelo_nombre': '',
      'idProducto.trazabilidad': 'false',
      'idProducto.numSerie': 'false',
      'precioUnidadUltimacompra': '43.56',
      'importeStockFinalUltimacompra': '43.56',
      'precioUnidadMediaPonderada': '43.56',
      'precioUnidadMediaTarifas': '3.63',
      'importeStockFinalMediaPonderada': '43.56',
      'importeStockFinalMediaTarifas': '3.63',
      'informacionStocks': '[{"idUbicacion": {"id": 1, "codigo": "1", "descripcion": "Ubicacion General"}, "cantidad": null, "id": 56, "numerosSerie": []}]',
      'cantidadRealTotal': '12',
    };

    final putproducts = await http.post(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/detallesInventario"),
      headers: {"Authorization": "Bearer $token"},
      body: bodyproduct,
    );

    if (putproducts.statusCode == 200) {
      print("PRODUCTO IMPORTADO CON EXITO");
    } else {
      print("ERROR PRODUCTO IMPORTADO");
      print(putproducts.statusCode);
    }*/

    final responseclose = await http.post(Uri.parse(
        'https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios/$idinventario/finalizarInventario?idDominio=$iddominio'),
        headers: {"Authorization": "Bearer $token"});

    if (responseclose.statusCode == 200) {
      print('Inventario cerrado exitosamente');
    } else {
      print('Ocurrió un error al cerrar el inventario. Código de estado: ${responseclose.statusCode}');
    }
  }

  Future<void> _showFiltrosDialog() async {
    final productosJson = await API.getFiltrosProductos(usuario);
    final productos = filtrosProductos.fromJson(productosJson);
    final categoriaSet = productos.json
        .map((e) => e['idCategoriaEstadisticas_nombre']['descripcion'])
        .toSet();
    final categoriaList = categoriaSet.toList();
    final subCategoriaMap =
        productos.json.fold<Map<String, String>>({}, (map, e) {
      final descripcionCategoria =
          e['idCategoriaEstadisticas_nombre']['descripcion'];
      final pathCompleto =
          e['idCategoriaEstadisticas_pathCompleto']['descripcion'];
      return {...map, descripcionCategoria: pathCompleto};
    });
    final tipoConservacionList = productos.json
        .where((e) =>
            e.containsKey('idImpresoraCocina_descripcion') &&
            e['idImpresoraCocina_descripcion'] != null)
        .map<String>((e) => e['idImpresoraCocina_descripcion']['descripcion'])
        .toSet()
        .toList();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final List<CheckboxListTileOption> opciones = categoriaList
              .map((categoria) => CheckboxListTileOption(title: categoria))
              .toList();
          final List<CheckboxListTileOption> subCategoriasOpciones =
              subCategoriaMap
                  .entries
                  .map((entry) => CheckboxListTileOption(
                      title: entry.key + " / " + entry.value))
                  .toList();
          final List<CheckboxListTileOption> conservacionOpciones =
              tipoConservacionList
                  .map((conservacion) =>
                      CheckboxListTileOption(title: conservacion))
                  .toList();
          return AlertDialog(
            insetPadding: EdgeInsets.all(5),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            title: Text('Filtros'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  buildListTile('Categorias'),
                  ...opciones,
                  Divider(),
                  buildListTile('Subcategorias'),
                  ...subCategoriasOpciones,
                  Divider(),
                  buildListTile('Tipos de conservacion'),
                  ...conservacionOpciones,
                  Divider(),
                  buildListTile('Criterios de ordenación'),
                  Wrap(spacing: 16.0, children: [
                    MyOrderListTile(
                      title: '1er',
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
                      title: '2o',
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
                      title: '3er',
                      criterios: criteriosOrdenacion,
                      ordenacion: opcionOrdenacion,
                      onCriterioSelected: (int selectedCriterioIndex) {
                        // código a ejecutar cuando se seleccione un criterio
                      },
                      onOrdenacionSelected: (int selectedOrdenacionIndex) {
                        // código a ejecutar cuando se seleccione una ordenación
                      },
                    ),
                  ]),
                ],
              ),
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
}



class CheckboxListTileOption extends StatefulWidget {
  final String title;

  CheckboxListTileOption({required this.title});

  @override
  State<StatefulWidget> createState() => _CheckboxListTileOptionState();
}

class _CheckboxListTileOptionState extends State<CheckboxListTileOption> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

class MyOrderListTile extends StatefulWidget {
  final String title;
  final List<String> criterios;
  final List<String> ordenacion;
  final Function(int) onCriterioSelected;
  final Function(int) onOrdenacionSelected;

  const MyOrderListTile({
    required this.title,
    required this.criterios,
    required this.ordenacion,
    required this.onCriterioSelected,
    required this.onOrdenacionSelected,
  });

  @override
  _MyOrderListTileState createState() => _MyOrderListTileState();
}

class _MyOrderListTileState extends State<MyOrderListTile> {
  int _selectedCriterioIndex = 0;
  int _selectedOrdenacionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              isExpanded: true,
              items: widget.criterios
                  .map((criterio) => DropdownMenuItem<String>(
                        value: criterio,
                        child: Text(criterio),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCriterioIndex = widget.criterios.indexOf(newValue!);
                });
                widget.onCriterioSelected(_selectedCriterioIndex);
              },
              value: widget.criterios[_selectedCriterioIndex],
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: DropdownButton<String>(
              isExpanded: true,
              items: widget.ordenacion
                  .map((ordenacion) => DropdownMenuItem<String>(
                        value: ordenacion,
                        child: Text(ordenacion),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOrdenacionIndex =
                      widget.ordenacion.indexOf(newValue!);
                });
                widget.onOrdenacionSelected(_selectedOrdenacionIndex);
              },
              value: widget.ordenacion[_selectedOrdenacionIndex],
            ),
          ),
        ],
      ),
    );
  }
}

//Funcion para devolver el titulo de filtros
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

class TargetasProducto extends StatefulWidget {
  final TstocksInventarios inventarioexistente;
  TargetasProducto(this.inventarioexistente);

  @override
  _TargetaProducto createState() => _TargetaProducto();
}

class _TargetaProducto extends State<TargetasProducto> {
  bool mostrarTarjetaPrincipal =
      true; // Estado para alternar entre las tarjetas
  int selectedIndex = 0;
  int indexMapa = 0;
  Map<int, int> mapaProductosRepetidos = {};
  double cantEmpaquetado1 = 0;
  double cantEmpaquetado2 = 0;
  double cantEmpaquetado1Total = 0;
  double cantEmpaquetado2Total = 0;
  String descripcionEmp2 = 'descrip2';
  String descripcionEmp1 = 'descrip1';
  get listaProductosTargeta => [];


  @override
  void initState() {
    super.initState();
    recogerListaProductos(widget.inventarioexistente);
  }

  @override
  Widget build(BuildContext context) {
    List<TstocksDetallesInventario>? listaProductos =
        widget.inventarioexistente.detallesInventario;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: mostrarTarjetaPrincipal
                ? generarEstructuraProductos(widget.inventarioexistente)
                : buildCounterRow(listaProductos, selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget buildCounterRow(
      List<TstocksDetallesInventario>? listaProductos, int index) {
    if (listaProductos == null || index >= listaProductos.length) {
      return Container();
    }
    var idProducto = listaProductos[index].idProducto;
    var number = listaProductos[index].cantidad;
    List<String> listaEmpaquetados = [];
    if (mapaProductosRepetidos.containsKey(idProducto)) {
      listaEmpaquetados.add(listaProductos[indexMapa].empaquetadoDescripcion);
      listaEmpaquetados.add(listaProductos[index].empaquetadoDescripcion);
    }
    var color;
    if (listaProductos[index].subcategoriaDescripcion == 'COCINA'){
      color = Colors.green;
    }else if (listaProductos[index].subcategoriaDescripcion == 'BEBIDAS'){
      color = Colors.redAccent;
    }else if (listaProductos[index].subcategoriaDescripcion == 'CAFETERIA'){
      color = Colors.brown;
    }else {
      color = Colors.orangeAccent;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: color,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              listaProductos[index].descripcionProducto,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  listaEmpaquetados = [];
                                  listaProductos[index].cantidad = number;
                                  print('ACTUALIZACION DE CANTIDAD');
                                  print(listaProductos.toString());
                                  mostrarTarjetaPrincipal = true;
                                  selectedIndex = index;
                                });
                              },
                              icon: Icon(Icons.minimize),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: () {
                              // Acción al presionar el IconButton
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                listaProductos[index].idProducto.toString() +
                                    '-' +
                                    listaProductos[index]
                                        .categoriaprincipalDescripcion +
                                    '-' +
                                    listaProductos[index]
                                        .subcategoriaDescripcion,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (listaEmpaquetados.isEmpty &&
                              !mapaProductosRepetidos.containsKey(idProducto))
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: buildIconButtons(
                                        cantidad : listaProductos[index].cantidad,
                                        empaquetado : listaProductos[index]
                                            .empaquetadoDescripcion,
                                         valor: descripcionEmp1,
                                        listaProductos: listaProductos,
                                        indice: index,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          //TODO AQUI VA EL TEXTO DE DESCRIPCION
                          if (!listaEmpaquetados.isEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: buildIconButtons(
                                       cantidad: listaProductos[index].cantidad,
                                       empaquetado: listaProductos[index]
                                            .empaquetadoDescripcion,
                                        valor:  descripcionEmp1,
                                       listaProductos: listaProductos,
                                       indice: index,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: buildIconButtons(
                                        cantidad: listaProductos[indexMapa].cantidad,
                                        empaquetado: listaProductos[indexMapa]
                                            .empaquetadoDescripcion,
                                         valor: descripcionEmp2,
                                        listaProductos: listaProductos,
                                        indice: indexMapa,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget generarEstructuraProductos(TstocksInventarios inventarioexistente) {
    List<TstocksDetallesInventario>? listaProductos =
        inventarioexistente.detallesInventario;
    Set<int> idsProductos = {};
    List<TstocksDetallesInventario> listaProductosSinRepetidos = [];
    print('INVENTARIO');
    print(inventarioexistente.toString());
//TODO
    for (var producto in listaProductos!) {
      if (!idsProductos.contains(producto.idProducto)) {
        idsProductos.add(producto.idProducto);
        listaProductosSinRepetidos.add(producto);
      }
    }

    for (int i = 0; i < listaProductos!.length; i++) {
      var idProdRepetido = listaProductos[i].idProducto;
      print(listaProductos[i].idProducto);
      for (int j = i + 1; j < listaProductos.length; j++) {
        var idProdLeer = listaProductos[j].idProducto;
        if (idProdRepetido == idProdLeer) {
          // Se encontró un producto con el mismo idProducto
          mapaProductosRepetidos[idProdLeer] = j;
        }
      }
    }
    return ListView.builder(
      itemCount: listaProductosSinRepetidos.length,
      itemBuilder: (context, index) {
        var cantidad = listaProductos[index].cantidad.toString();
        var idProducto = listaProductos[index].idProducto;
        int indiceMapa = 0;
        bool repetidos = false;
        if (mapaProductosRepetidos.containsKey(idProducto)) {
          indiceMapa = mapaProductosRepetidos[idProducto]!;
          repetidos = true;
        }
        var color;
        if (listaProductos[index].subcategoriaDescripcion == 'COCINA'){
          color = Colors.green;
        }else if (listaProductos[index].subcategoriaDescripcion == 'BEBIDAS'){
          color = Colors.redAccent;
        }else if (listaProductos[index].subcategoriaDescripcion == 'CAFETERIA'){
          color = Colors.brown;
        }else {
          color = Colors.orangeAccent;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: color,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              listaProductos[index].descripcionProducto,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_a_photo),
                                onPressed: () {
                                  // Acción al presionar el IconButton
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (!mapaProductosRepetidos
                                      .containsKey(idProducto))
                                    Text(
                                        cantidad +
                                            ' ' +
                                            listaProductos[index]
                                                .empaquetadoDescripcion,
                                        style: TextStyle(
                                          color: Colors.black,
                                        )),
                                  if (mapaProductosRepetidos
                                          .containsKey(idProducto) &&
                                      repetidos == true)
                                    Text(
                                      cantidad +
                                          ' ' +
                                          listaProductos[index]
                                              .empaquetadoDescripcion +
                                          '; \n' +
                                          listaProductos[indiceMapa]
                                              .cantidad
                                              .toString() +
                                          ' ' +
                                          listaProductos[indiceMapa]
                                              .empaquetadoDescripcion,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          mostrarTarjetaPrincipal = false;
                          selectedIndex = index;
                          indexMapa = indiceMapa;
                          if (!mapaProductosRepetidos.containsKey(idProducto)) {
                            cantEmpaquetado1Total = double.parse(cantidad);
                          } else {
                            cantEmpaquetado1Total = double.parse(cantidad);
                            cantEmpaquetado2Total = listaProductos[indiceMapa].cantidad;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildIconButtons( {
  required double cantidad,
  required String empaquetado,
    required String valor,
  required List<TstocksDetallesInventario> listaProductos,
    required indice,
}) {
    print('LISTAPRODUCTOS');
    print(listaProductos[indice].cantidad);
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String nuevoTexto = ''; // Variable para almacenar el nuevo texto ingresado por el usuario

            return AlertDialog(
              title: Text('Cambiar cantidad'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(empaquetado),
                  SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      nuevoTexto = value; // Actualizar el nuevo texto cada vez que cambie el TextField
                    },
                    decoration: InputDecoration(
                      hintText: 'Ingrese la nueva cantidad',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      listaProductos[indice].cantidad=double.parse(nuevoTexto);
                    });
                    print(listaProductos[indice].cantidad);
                    Navigator.of(context).pop();
                    // Aquí puedes utilizar el valor de 'nuevoTexto' para realizar cualquier acción necesaria
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black),
            ),
            padding: EdgeInsets.all(4),
            child: Text(listaProductos[indice].cantidad.toString()),
          ),
          Text(
            empaquetado,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> recogerListaProductos(TstocksInventarios inventarioexistente) async {
    print('RECOGERLISTAPRODUCTOS');
    List<TstocksDetallesInventario> listaProductos = await DatabaseHelper.instance.filtrarDetallesInventarioPorId(inventarioexistente.idInventario);
    inventarioexistente.detallesInventario=listaProductos;
    print(inventarioexistente.detallesInventario.toString());
  }


}
