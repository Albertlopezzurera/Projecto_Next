import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:InventarioNextt/DatabaseHelper.dart';
import 'package:InventarioNextt/TstocksDetallesInventario.dart';
import 'package:InventarioNextt/TstocksInventarios.dart';
import 'package:InventarioNextt/User.dart';
import 'package:InventarioNextt/CameraQR.dart';
import 'package:InventarioNextt/FiltrosProductos.dart';
import 'package:InventarioNextt/InicioSesion.dart';
import 'package:InventarioNextt/NuevoInventario.dart';
import 'package:InventarioNextt/ListaInventarios.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LlamadaApi.dart';

///
/// Esta clase ListaProductos es la encargada de mostrar la interficie de los productos escaneados.
/// Tenemos unas variables que tenemos que pasarle para poder acceder a esta clase que son:
/// [usuario]: Esta variable sirve para coger el token del usuario que ha iniciado sesión y poder hacer llamadas a la API.
/// [inventarioexistente]: Esta variable es el inventario el cual se ha creado o el cual se ha echo click en la pantalla lista de Inventarios.
///
class ListaProductos extends StatefulWidget {
  final User usuario; // Agregar esta línea
  final TstocksInventarios inventarioexistente;
  ListaProductos(this.usuario, this.inventarioexistente);
  final String title = 'LISTA INVENTARIOS';
  @override
  _ListaProductosState createState() => _ListaProductosState();
}


///
/// Aqui podemos ver como tenemos diferentes variables que son las siguientes:
/// [_isSearching]: bool, que sirve para saber si el usuario ha pulsado el icono de lupa y quiere buscar
/// [listaProductosTargeta]: Esta variable de tipo List<int> y aqui se almacena el id de los Productos
///
class _ListaProductosState extends State<ListaProductos> {


  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
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

  ///
  /// Metodo buildAppBar que sirve basicamente para la busqueda, con el icono de la lupa y un texto en tipo 'Hint' que nos ayuda a saber que es para buscar.
  /// Este metodo lo que hace es si la variable [_isSearching] es false muestra la interficie como si no estuvieras buscando nada,
  /// en canvio si es true, muestra un iconButton de una lupa, un texto para saber que hay que escribir lo que se quiere buscar.
  ///
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


  ///
  /// Este metodo build nos reproduce la interficie con el menu superior que es el metodo buildAppBar, el menu desplegable izquierdo lateral comentado previamente
  /// y el [body]: que seria la parte principal de la interficie donde se muestra esas tarjetas de los productos.
  /// En este body comprobamos si la variable que recibimos de [inventarioexistente] un campo que es detallesInventario (que es donde encontramos los productos)
  /// si contiene algun producto, en caso de que sea null mostraremos un Container() vacio, en caso de no ser null llamaremos a la clase TarjetaProducto()
  /// el cual le pasaremos la variable [inventarioexistente].
  ///
  /// Por ultimo encontramos la parte de FloatingActionButton el cual tenemos 4 botones:
  /// 1ero: Cruz con fondo color rojo. Este boton nos lleva a la pagina de lista inventarios pero previamente nos manda una alerta para confirmar si queremos salir sin guardar.
  /// 2o: Disquet con fondo color verde claro. Este boton se encarga de guardar en la BD local los productos para este inventario.
  /// En caso de no haber ningun producto escaneado, nos muestra una alerta conforme no se puede guardar ya que no hay productos,
  /// en caso contrario nos hace el update en la BD local y en caso de ser correcto nos muestra una alerta que verifica la subida y nos lleva a lista inventarios
  /// 3er: Disquete con fondo color verde oscuro. Este boton nos muestra una alerta conforme se cerrara el inventario y por tanto no se podra modificar.
  /// En caso de hacer click a 'SI', primero se guardara en la BD local y después se subirá a la API.Esta subida la hará el metodo cerrarInventario().
  /// 4o: Camara con fondo gris. Este boton nos lleva a la pantalla de la camara, para escanear productos.
  ///
  @override
  Widget build(BuildContext context) {
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
                        : TarjetasProducto(widget.inventarioexistente),
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
                    if (widget.inventarioexistente.detallesInventario!.isNotEmpty) {
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        paginaPrincipal(usuario)),
                              );
                            },
                          ),
                          TextButton(
                            child: Text("Sí"),
                            onPressed: () {
                              widget.inventarioexistente.idEstadoInventario=2;
                              widget.inventarioexistente.estadoInventario='CONFIRMADO';
                              DatabaseHelper.instance.update(widget.inventarioexistente);
                              for (int i = 0; i<widget.inventarioexistente.detallesInventario!.length; i++){
                                DatabaseHelper.instance.updateDetalles(widget.inventarioexistente.detallesInventario!.elementAt(i));
                              }
                              cerrarInventario(widget.inventarioexistente);
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
                    } else {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        title: Text("No hay productos en el inventario!"),
                        content: Text("Porfavor inserte productos para poder cerrar el inventario."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Aceptar"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ],
                      );
                    }
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

  ///
  /// Metodo cerrarInventario el cual recibe por parametro [inventario] el cual es el que recibimos en nuestra clase ListaProductos.
  /// Aqui se realiza el cerrado de inventario y se sube a la API.
  /// El codigo comentado es la subida a la API de los productos a ese inventario ya que por tema permisos no se ha podido finalizar.
  /// En caso que la subida haya sido correcta, nos muestra la alerta comentada previamente y en caso de no ser correcta nos muestra el codigo de error.
  ///
  Future<void> cerrarInventario(TstocksInventarios inventario) async {
    var token = usuario.token;
    var iddominio = usuario.iddominio;
    var idinventario = null;

    final getlatestcodigo = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios"),
      headers: {"Authorization": "Bearer $token"},
    );

    var maxCodigo = '000';

    for (var data in jsonDecode(getlatestcodigo.body)) {
      var codigo = data["codigo"] as String;
      var numbers = int.tryParse(codigo.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      maxCodigo = numbers > int.parse(maxCodigo) ? numbers.toString() : maxCodigo;
    }

    var nuevoCodigo = (int.parse(maxCodigo) + 1).toString().padLeft(3, '0');



    // Construye el cuerpo de la solicitud
    var body = jsonEncode({
      "codigo": nuevoCodigo,
      "descripcion": inventario.descripcionInventario.toString(),
      "fechaRealizacionInventario": inventario.fechaRealizacionInventario,
      "idAlmacen": {"id": inventario.idAlmacen.toString()},
      "idDominio": {"id": inventario.idDominio.toString()},
      "idEstadoInventario": {"id": inventario.idEstadoInventario.toString(), "valor": inventario.estadoInventario.toString()},
      "idTienda": {"id": inventario.idTienda.toString()},
      "idTipoInventario": {"id": inventario.idTipoInventario.toString()}
    });

    final response = await http.post(
      Uri.parse("https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: body,
    );

    final getinventarioid = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios"),
      headers: {"Authorization": "Bearer $token"},
    );

    for (var data in jsonDecode(getinventarioid.body)) {
      if (nuevoCodigo == data["codigo"] && inventario.descripcionInventario == data["descripcion"]) {
        idinventario = data["id"] as int;
        break;
      }

    }



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
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text("Guardado correctamente"),
              content: Text("El inventario se ha guardado correctamente."),
              actions: <Widget>[
                TextButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          }
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text("Ocurrio un error"),
              content: Text("Ocurrió un error al cerrar el inventario. Código de estado: ${responseclose.statusCode}"),
              actions: <Widget>[
                TextButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          }
      );
    }
  }


  ///
  /// Metodo _showFiltrosDialog el cual hace una llamada a la API y nos traemos la información que queremos cargar respecto a filtros,
  /// aqui podemos ver alguno de ellos, como puede ser la categoria principal, categoria secundaria etc.. y los muestra en un metodo
  /// AlertDialog.
  ///
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


///
/// Clase que es llamada por el metodo _showBuildFiltros() que genera el titulo con un estilo
///
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


///
/// Clase para mostrar la parte de criterios de ordenación de los filtros para que se pueda escoger una opción y se quede guardada.
///
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

///
/// Clase TarjetasProducto la cual se encarga de mostrar las tarjetas para cada producto.
/// Esta clase obtiene la variable [inventarioexistente].
///
class TarjetasProducto extends StatefulWidget {
  final TstocksInventarios inventarioexistente;
  TarjetasProducto(this.inventarioexistente);

  @override
  _TargetaProducto createState() => _TargetaProducto();
}

///
/// Tenemos diferentes variables unicamente de esta clase que son:
/// [mostrarTarjetaPrincipal]: bool que sirve para saber si el usuario ha echo click en la tarjeta la cual se mostrara la opcion de
/// modificar la cantidad y por lo tanto variar el diseño de la tarjeta.
/// [selectedIndex]: variable int que sirve como indice
/// [indexMapa]: variable int que sirve para llevar el indice del la variable [mapaProductosRepetidos].
/// [mapaProductosRepetidos]: Map<int,int> el cual añadimos los productos que estan repetidos en la variable [inventarioexistente].
/// Esta variable es muy útil ya que si tuvieramos un producto con 3 linias diferentes de empaquetado tendriamos 3 veces repetido el producto,
/// y por lo tanto deberiamos modificar un empaquetado en un empaquetaod.
/// Las demas variables como [cantEmpaquetado1, cantEmpaquetado2, descripcionEmp1, descripcionEmp2] sirven como referencia para saber en una tarjeta que tenga
/// diferentes empaquetados, saber que empaquetado se esta modificando.
///
class _TargetaProducto extends State<TarjetasProducto> {
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


  ///
  /// Metodo que se realiza al principio cada vez que se llama a la clase TarjetaProducto()
  /// Que es la funcion de recogerListaProductos, que es cuando te traes los productos del [inventarioexistente]
  ///
  @override
  void initState() {
    super.initState();
    recogerListaProductos(widget.inventarioexistente);
  }

  ///
  /// Metodo que dependiendo de la bool [mostrarTarjetaPrincipal] si es true o false muestra un tipo de tarjeta o la de variar la cantidad.
  ///
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

  ///
  /// Metodo buildCounterRow el cual es el metodo que genera la tarjeta que permite modificar la cantidad.
  /// Este metodo recibe por parametros:
  /// [listaProductos]: una List de tipo TstocksDetallesInventario
  /// [index]: indice para saber en que producto se ha echo click.
  /// Tenemos diferentes variables creadas dentro del propio metodo que son:
  /// [idProducto]: id del producto que ha echo click el usuario.
  /// [number]: cantidad del producto que ha echo click el usuario.
  /// [listaEmpaquetados]: List<String> el cual comprobamos si hay algun elemento en la variable de [mapaProductosRepetidos]
  /// Tenemos una condicion que si el idProducto, se encuentra en la variable de [mapaProductosRepetidos], se añadira a [listaEmpaquetados].
  /// [color]: de tipo Color, que sirve para dependiendo de la categoria secundaria, escoger un color u otro.
  ///
  /// Posteriormente muestra la forma en la que se va a presentar al usuario de manera visual.
  /// Tenemos en un lugar un icono y una descripción del producto.
  /// En la fila de abajo tenemos la opción de modificar la cantidad y la descripción de empaquetado.
  /// En caso de querer modificar la cantidad podemos hacer click en la descripción del empaquetado y se nos abrirá una alerta
  /// la cual pondremos unicamente un valor de tipo int y al hacer click a 'Aceptar' se modificará la cantidad.
  /// La ultima parte del codigo lo que pretende es identificar si el producto tiene diferentes empaquetados, para saber
  /// que descripción de empaquetado se ha modificado.
  ///
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

  ///
  /// Esta es la estructura que se genera básica, es decir una vez se escanea un producto y se vuelve a la lista de productos,
  /// esta es la forma en la que se visualizará la tarjeta.
  /// Aqui se recibe por parametro la variable [inventarioexistente]
  /// Tenemos una variable que evita repetir productos que es [Set<int> idsProductos] que almacena idProductos y no se repiten,
  /// el cual hacemos un bucle que almacenamos los idProductos de todos los productos que tiene este inventario
  ///
  /// return ListView.builder, devuelve una lista que depende de la variable [listaProductosSinRepetidos] que es una lista
  /// que no tiene productos repetidos, para asi evitar que un producto tenga diferentes empaquetados se muestre varias veces.
  /// El contenido que se genera es en la parte superior de la tarjeta, una descripcion del producto.
  /// La siguiente fila inferior que se genera es el código del producto junto con la categoria principal y la categoria secundaria.
  /// Por ultimo encontramos la cantidad de empaquetado y su descripción.
  ///
  Widget generarEstructuraProductos(TstocksInventarios inventarioexistente) {
    List<TstocksDetallesInventario>? listaProductos =
        inventarioexistente.detallesInventario;
    Set<int> idsProductos = {};
    List<TstocksDetallesInventario> listaProductosSinRepetidos = [];
    for (var producto in listaProductos!) {
      if (!idsProductos.contains(producto.idProducto)) {
        idsProductos.add(producto.idProducto);
        listaProductosSinRepetidos.add(producto);
      }
    }

    for (int i = 0; i < listaProductos!.length; i++) {
      var idProdRepetido = listaProductos[i].idProducto;
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

  ///
  /// Metodo buildIconButtons para modificar la cantidad, y notificar cuando el usuario ha echo click en la descripción del empaquetado.
  /// unicamente cuando la tarjeta tiene el metodo buildCounterRow().
  ///
  Widget buildIconButtons( {
  required double cantidad,
  required String empaquetado,
    required String valor,
  required List<TstocksDetallesInventario> listaProductos,
    required indice,
}) {
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

  ///
  /// Metodo recogerListaProductos recibe por parametro el [inventarioexistente], que es el inventario.
  /// Hacemos una peticion a la BD local para recibir los productos a través del idInventario, ese resultado de [listaProductos],
  /// la asignamos a [inventarioexistente.detallesInventario].
  ///
  Future<void> recogerListaProductos(TstocksInventarios inventarioexistente) async {
    List<TstocksDetallesInventario> listaProductos = await DatabaseHelper.instance.filtrarDetallesInventarioPorId(inventarioexistente.idInventario);
    inventarioexistente.detallesInventario=listaProductos;
  }


}
