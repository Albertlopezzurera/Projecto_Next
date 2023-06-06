import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:InventarioNextt/DatabaseHelper.dart';
import 'package:InventarioNextt/TstocksDetallesInventario.dart';
import 'package:InventarioNextt/TstocksInventarios.dart';
import 'package:InventarioNextt/User.dart';
import 'package:InventarioNextt/EmpaquetadosProducto.dart';
import 'package:InventarioNextt/ListaProductos.dart';
import 'LlamadaApi.dart';
import 'package:InventarioNextt/ProductoCamaraQR.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


///
/// Clase CameraQR es la encargada de mostrar al usuario la interfaz del escaneo de productos.
/// Esta clase como las demás reciben por parametro [usuario] y el [inventarioexistente].
///
class CameraQR extends StatefulWidget {
  final User usuario; // Agregar esta línea
  final TstocksInventarios inventarioexistente;

  CameraQR(this.usuario, this.inventarioexistente); // Actualizar el constructor

  @override
  _CameraQRState createState() => _CameraQRState();
}

/// Tenemos diferentes variables que son:
/// [_qrViewControlles , qrKey , _cameraController]: Estas variables hacen referencia a la función de la camara.
/// [listaInfProd, listaEmpaquetados]: Estas dos variables hacen referencia por un lado a la información basica del producto, como puede ser,
/// el idProducto, categoria principal, categoria secundaria y por otro lado la información sobre los diferentes empaquetados del producto.
/// [_scanResult]: Variable que es el resultado del escaneo, en este caso se mostraria el codigo de ean.
/// Las demas variables es simplemente para tener un control sobre en caso que tenga mas de un empaquetado, poder tener un control sobre las mismas
/// y asi poder guardar los diferentes empaquetados sin repetirlo.
///
class _CameraQRState extends State<CameraQR> {
  late QRViewController _qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late CameraController _cameraController;
  late List<String> listaInfProd = [];
  late Set<String> listaEmpaquetados = {};
  String _scanResult = '';
  int _numberBotellas = 1;
  int _numberCajasMenor = 1;
  int _numberCajasMayor = 1;
  String descripEmp1 = 'botellas';
  String descripEmp2 = 'c_menor';
  String descripEmp3 = 'c_mayor';
  bool infEmpaquet = false;
  String codigoProductoEmpaquetado = "";
  int totalBotellas = 1;
  int totalCajasMenor = 1;
  int totalCajasMayor = 1;

  void _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text("Error con la camara"),
              content: Text("No se ha encontrado ninguna cámara."),
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

    final firstCamera = cameras.first;
    setState(() {
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      _cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _incrementNumber(int number, text) {
    setState(() {
      if (text == 'botellas') {
        _numberBotellas++;
        totalBotellas = totalBotellas+1;
      } else if (text == 'c_menor') {
        _numberCajasMenor++;
        totalCajasMenor = totalCajasMenor + 1;
      } else if (text == 'c_mayor') {
        _numberCajasMayor++;
        totalCajasMayor = totalCajasMayor + 1;
      }
    });
  }

  void _decrementNumber(int number, text) {
    setState(() {
      if (identical(text, 'botellas') && totalBotellas > 0) {
        _numberBotellas--;
        totalBotellas = totalBotellas - 1;
      } else if (identical(text, 'c_menor') && totalCajasMenor > 0) {
        _numberCajasMenor--;
        totalCajasMenor = totalCajasMenor - 1;
      } else if (identical(text, 'c_mayor') && totalCajasMayor > 0) {
        _numberCajasMayor--;
        totalCajasMayor = totalCajasMayor - 1;
      }
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    _qrViewController = controller;
    _qrViewController.scannedDataStream.listen((scanData) {
      setState(() {
        _scanResult = scanData.code!;
      });
      procesarScanResult(_scanResult);
    });
  }

  void procesarScanResult(String scanResult) async {
    await accederInformacionCodigo(_scanResult);
  }


  ///
  /// Metodo build que nos muestra la interfaz de la clase CameraQR, basicamente tenemos 4 zonas de layout diferenciadas:
  /// 1a: La parte de la camara, que sera la que siempre estará activa para escanear cualquier producto
  /// 2a: La parte central la cual nos muestra un mensaje informativo y el codigo ean escaneado en ese momento.
  /// 3a: La parte inferior que es donde se muestra los diferentes empaquetados para modificar las cantidades.
  /// 4a: La parte inferior de la pantalla donde encontramos los FloatingActionButton encargados por un lado de:
  /// - Guardar el producto en ese inventario con el botón de la derecha.
  /// - Volver a la pantalla de lista de productos con el botón de la izquierda.
  ///
  /// Comentar que el botón de la derecha hay que presionarlo cada vez que se escanee un producto para asi guardarlo en la BD local,
  /// si no se presiona ese botón, el producto no queda guardado en el inventario y por lo tanto no constaria.
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('ESCANEAR CODIGO DE BARRAS'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (_cameraController != null &&
                    _cameraController.value.isInitialized)
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _scanResult.isEmpty
              ? Text('Esperando datos de código')
              : Column(
                  children: [
                    Text('Codigo articulo: $_scanResult'),
                    // Resto del código
                  ],
                ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Puede modificar manualmente las cantidades registradas o puede seguir escaneando códigos de otros productos.',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10), // Ajusta el valor de acuerdo a tus necesidades
                child: Container(
                  color: Colors.orange,
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  listaInfProd.isNotEmpty &&
                                          listaInfProd[7] != 'No hay imágenes'
                                      ? Image.network(
                                          'https://booh.pre-uploads.nexttdirector.net/${listaInfProd[7]}-thumbnail-big.png', // URL con la concatenación corregida
                                          width: 50,
                                          height: 50,
                                        )
                                      : Container(),
                                  Column(
                                    children: [
                                      listaInfProd.isEmpty
                                          ? Text('ARTICULO')
                                          : Text(listaInfProd[0]),
                                      listaInfProd.isEmpty
                                          ? Text('CATEGORIA')
                                          : Text(listaInfProd[2] +
                                              "-" +
                                              listaInfProd[3] +
                                              "-" +
                                              listaInfProd[4]),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (infEmpaquet == true)
                                    Column(
                                      children: [
                                        if (listaEmpaquetados.length >= 4)
                                          buildCounterRow(
                                            number: _numberBotellas,
                                            descripcion: descripEmp1,
                                            tipo: listaEmpaquetados,
                                          ),
                                        if (listaEmpaquetados.length >= 6)
                                          buildCounterRow(
                                            number: _numberCajasMenor,
                                            descripcion: descripEmp2,
                                            tipo: listaEmpaquetados,
                                          ),
                                        if (listaEmpaquetados.length == 8)
                                          buildCounterRow(
                                            number: _numberCajasMayor,
                                            descripcion: descripEmp3,
                                            tipo: listaEmpaquetados,
                                          ),

                                      ],
                                    ),
                                  if (infEmpaquet == false)
                                    Container(), // Contenedor vacío cuando infEmpaquet es false
                                ],
                              ),
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
          Container(
            color: Colors.white, // Establecer el color de fondo blanco
            child: SizedBox(height: 60), // Ajusta la altura según sea necesario
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListaProductos(
                          widget.usuario, widget.inventarioexistente),
                    ),
                  );
                },
                child: Icon(Icons.backspace_sharp),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  if (_scanResult==''){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('ERROR'),
                            content: Text('No hay ningun producto para guardar'),
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
                  }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        title: Text("ATENCIÓN!"),
                        content: Text("Confirmar cambios?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                              child: Text("Sí"),
                              onPressed: () async {
                                if (listaEmpaquetados.length >= 4) {
                                  String descripcionProducto = listaInfProd[0];
                                  String categoriaPrincipal = listaInfProd[3];
                                  String categoriaSecundaria = listaInfProd[4];
                                  String factorEmpaquetado = listaEmpaquetados.elementAt(3);
                                  String idCatPrin = listaInfProd[5].toString();
                                  String idCatSec = listaInfProd[6].toString();
                                  int idProducto = int.parse(listaInfProd[2]);
                                  int idInventario =
                                      widget.inventarioexistente.idInventario;
                                  int idEmpaquetadoProd =
                                      int.parse(listaEmpaquetados.elementAt(1));
                                  String descripcionEmpaquetado =
                                      listaEmpaquetados.elementAt(2);
                                  double numBot = totalBotellas.toDouble();
                                  int ultimoid = await DatabaseHelper.instance
                                      .obtenerUltimoIdDetalles();
                                  TstocksDetallesInventario liniaProd1 =
                                      TstocksDetallesInventario(
                                    linea: ultimoid,
                                    idInventario: idInventario,
                                    idUnidadMedida: 0,
                                    descripcionUnidadMedida: "",
                                    idProducto: idProducto,
                                    descripcionProducto: descripcionProducto,
                                    idAlmacen:
                                        widget.inventarioexistente.idAlmacen!,
                                    almacenDescripcion: widget
                                        .inventarioexistente
                                        .almacenDescripcion!,
                                    idEmpaquetadoProducto: idEmpaquetadoProd,
                                    empaquetadoDescripcion:
                                        descripcionEmpaquetado,
                                    idcategoriaprincipal: int.parse(idCatPrin),
                                    categoriaprincipaldescripcion:
                                        categoriaPrincipal,
                                    subcategoriaid: int.parse(idCatSec),
                                    subcategoriadescripcion:
                                        categoriaSecundaria,
                                    cantidad: numBot,
                                        cantidadcaja: double.parse(factorEmpaquetado),
                                        cantidadtotal: 0, 
                                  );
                                  setState(() {
                                    widget.inventarioexistente.detallesInventario!
                                        .add(liniaProd1);
                                    DatabaseHelper.instance.insertDetalles(liniaProd1);
                                  });
                                }
                                if (listaEmpaquetados.length >= 6) {
                                  String descripcionProducto = listaInfProd[0];
                                  String categoriaPrincipal = listaInfProd[3];
                                  String categoriaSecundaria = listaInfProd[4];
                                  String factorEmpaquetado2 = listaEmpaquetados.elementAt(6);
                                  String idCatPrin = listaInfProd[5].toString();
                                  String idCatSec = listaInfProd[6].toString();
                                  int idProducto = int.parse(listaInfProd[2]);
                                  int idInventario =
                                      widget.inventarioexistente.idInventario;
                                  int idEmpaquetadoProd2 =
                                      int.parse(listaEmpaquetados.elementAt(4));
                                  String descripcionEmpaquetado2 =
                                      listaEmpaquetados.elementAt(5);
                                  double numCajMenor =
                                      totalCajasMenor.toDouble();
                                  int ultimoid = await DatabaseHelper.instance
                                      .obtenerUltimoIdDetalles();
                                  TstocksDetallesInventario liniaProd2 =
                                      TstocksDetallesInventario(
                                    linea: ultimoid,
                                    idInventario: idInventario,
                                    idUnidadMedida: 0,
                                    descripcionUnidadMedida: "",
                                    idProducto: idProducto,
                                    descripcionProducto: descripcionProducto,
                                    idAlmacen:
                                        widget.inventarioexistente.idAlmacen!,
                                    almacenDescripcion: widget
                                        .inventarioexistente
                                        .almacenDescripcion!,
                                    idEmpaquetadoProducto: idEmpaquetadoProd2,
                                    empaquetadoDescripcion:
                                        descripcionEmpaquetado2,
                                    idcategoriaprincipal: int.parse(idCatPrin),
                                    categoriaprincipaldescripcion:
                                        categoriaPrincipal,
                                    subcategoriaid: int.parse(idCatSec),
                                    subcategoriadescripcion:
                                        categoriaSecundaria,
                                    cantidad: numCajMenor,
                                        cantidadcaja: double.parse(factorEmpaquetado2),
                                        cantidadtotal: 0,
                                  );
                                  setState(() {
                                    widget.inventarioexistente.detallesInventario!
                                        .add(liniaProd2);
                                    DatabaseHelper.instance.insertDetalles(liniaProd2);
                                  });

                                }
                                if (listaEmpaquetados.length == 8) {
                                  String descripcionProducto = listaInfProd[0];
                                  String categoriaPrincipal = listaInfProd[3];
                                  String categoriaSecundaria = listaInfProd[4];
                                  String factorEmpaquetado3 = listaEmpaquetados.elementAt(9);
                                  String idCatPrin = listaInfProd[5].toString();
                                  String idCatSec = listaInfProd[6].toString();
                                  int idProducto = int.parse(listaInfProd[2]);
                                  int ultimoid = await DatabaseHelper.instance
                                      .obtenerUltimoIdDetalles();
                                  int idInventario =
                                      widget.inventarioexistente.idInventario;
                                  int idEmpaquetadoProd3 =
                                      int.parse(listaEmpaquetados.elementAt(7));
                                  String descripcionEmpaquetado3 =
                                      listaEmpaquetados.elementAt(8);
                                  double numCajMayor =
                                      totalCajasMayor.toDouble();
                                  TstocksDetallesInventario liniaProd3 =
                                      TstocksDetallesInventario(
                                    linea: ultimoid,
                                    idInventario: idInventario,
                                    idUnidadMedida: 0,
                                    descripcionUnidadMedida: "",
                                    idProducto: idProducto,
                                    descripcionProducto: descripcionProducto,
                                    idAlmacen:
                                        widget.inventarioexistente.idAlmacen!,
                                    almacenDescripcion: widget
                                        .inventarioexistente
                                        .almacenDescripcion!,
                                    idEmpaquetadoProducto: idEmpaquetadoProd3,
                                    empaquetadoDescripcion:
                                        descripcionEmpaquetado3,
                                    idcategoriaprincipal: int.parse(idCatPrin),
                                    categoriaprincipaldescripcion:
                                        categoriaPrincipal,
                                    subcategoriaid: int.parse(idCatSec),
                                    subcategoriadescripcion:
                                        categoriaSecundaria,
                                    cantidad: numCajMayor,
                                        cantidadcaja: double.parse(factorEmpaquetado3),
                                        cantidadtotal: 0,
                                  );
                                  setState(() {
                                    widget.inventarioexistente.detallesInventario!
                                        .add(liniaProd3);
                                    DatabaseHelper.instance.insertDetalles(liniaProd3);
                                  });

                                }
                                Navigator.pushAndRemoveUntil(
                                context,
                                 MaterialPageRoute(
                                 builder: (context) => CameraQR(
                                  widget.usuario,
                                 widget.inventarioexistente),
                                 ),
                                 (route) => false,
                                );
                              }),
                        ],
                      );
                    },
                  );
                  }
                },
                child: Icon(Icons.check_circle),
                backgroundColor: Colors.green,
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  Widget buildCounterRow({
    required int number,
    required String descripcion,
    required Set<String> tipo,

  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => _decrementNumber(number,descripcion),
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.horizontal_rule),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.all(4),
          child: Text('$number'),
        ),
        IconButton(
          onPressed: () => _incrementNumber(number,descripcion),
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_circle),
          ),
        ),
        if (descripcion  == 'botellas')
        Container(
          child: Text(tipo.elementAt(2)),
        ),
        if (descripcion  == 'c_menor')
          Container(
            child: Text(tipo.elementAt(5)),
          ),
        if (descripcion  == 'c_mayor')
          Container(
            child: Text(tipo.elementAt(8)),
          ),
      ],
    );
  }

  ///
  /// Metodo accederInformacionCodigo que recibe por parametro [scaResult], que es el String del codigo ean leído.
  /// Hace una llamada a la API para traernos información unicamente del producto, como puede ser su nombre, categorias etc..
  ///
  Future<void> accederInformacionCodigo(String scanResult) async {
    final listaInformacion = await API.getProductoCamara(widget.usuario);
    final producto = productoCamaraQR.fromJson(listaInformacion, scanResult);
    List<String> productoEscaneado = producto.productoEscaneado;
    if (productoEscaneado.length != 0) {
      codigoProductoEmpaquetado = productoEscaneado[2];
      await accederDescripEmpaquetado(codigoProductoEmpaquetado);
    }
    setState(() {
      listaInfProd = productoEscaneado;
    });
  }

  ///
  /// Metodo accederDescripEmpaquetado el cual recibe por parametro [codigo] que es un String, que es el idProducto.
  /// Este método hace una llamada a la API que se encarga de traer unicamente el codigo de empaquetado y los diferentes empaquetados,
  /// en caso de que tenga varios.
  /// En el caso contrario que no encuentre ningún empaquetado mostrará una alerta informativa, a pesar de mostrar la alerta podrá continuar con el escaneo
  ///
  Future<void> accederDescripEmpaquetado(String codigo) async {
    final listaEmpaquetadosProducto =
        await API.getEmpaquetadosProducto(widget.usuario);
    final producto =
        empaquetadosProducto.fromJson(listaEmpaquetadosProducto, codigo);
    List<String> infEmpaquetadoProd = producto.listaEmpaquetados;
    if (infEmpaquetadoProd.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text("Error"),
              content: Text("No se ha encontrado ningun empaquetado para este producto."),
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
      setState(() {
        infEmpaquet = true;
        listaEmpaquetados = Set<String>.from(infEmpaquetadoProd);
      });
    }
  }
}
