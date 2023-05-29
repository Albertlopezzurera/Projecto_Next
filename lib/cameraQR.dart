import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:projectobueno/TstocksDetallesInventario.dart';
import 'package:projectobueno/TstocksInventarios.dart';
import 'package:projectobueno/User.dart';
import 'package:projectobueno/empaquetadosProducto.dart';
import 'package:projectobueno/listaProductos.dart';
import 'llamadaApi.dart';
import 'package:projectobueno/productoCamaraQR.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraQR extends StatefulWidget {
  final User usuario; // Agregar esta línea
  final TstocksInventarios inventarioexistente;

  CameraQR(this.usuario, this.inventarioexistente); // Actualizar el constructor

  @override
  _CameraQRState createState() => _CameraQRState();
}

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

  void _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print('No se encontraron cámaras disponibles en el dispositivo.');
      return;
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
      if (identical(text, 'botellas')) {
        _numberBotellas++;
      } else if (identical(text, 'c_menor')) {
        _numberCajasMenor++;
      } else if (identical(text, 'c_mayor')) {
        _numberCajasMayor++;
      }
    });
  }

  void _decrementNumber(int number, text) {
    setState(() {
      if (identical(text, 'botellas') && _numberBotellas > 0) {
        _numberBotellas--;
      } else if (identical(text, 'c_menor') && _numberCajasMenor > 0) {
        _numberCajasMenor--;
      } else if (identical(text, 'c_mayor') && _numberCajasMayor > 0) {
        _numberCajasMayor--;
      }
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    _qrViewController = controller;
    _qrViewController.scannedDataStream.listen((scanData) {
      setState(() {
        _scanResult = scanData.code!;
        listaInfProd = accederInformacionCodigo(_scanResult) as List<String>;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear código de barras'),
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
                                          listaInfProd[5] != 'No hay imágenes'
                                      ? Image.network(
                                          'https://booh.pre-uploads.nexttdirector.net/${listaInfProd[5]}-thumbnail-big.png', // URL con la concatenación corregida
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
                                  if (listaEmpaquetados.length == 2)
                                    buildCounterRow(
                                      number: _numberBotellas,
                                      onDecrement: () {
                                        _decrementNumber(
                                            _numberBotellas, descripEmp1);
                                      },
                                      onIncrement: () {
                                        _incrementNumber(
                                            _numberBotellas, descripEmp1);
                                      },
                                      tipo: listaEmpaquetados,
                                    ),
                                  if (listaEmpaquetados.length == 4)
                                    buildCounterRow(
                                      number: _numberCajasMenor,
                                      onDecrement: () {
                                        _decrementNumber(
                                            _numberCajasMenor, descripEmp2);
                                      },
                                      onIncrement: () {
                                        _incrementNumber(
                                            _numberCajasMenor, descripEmp2);
                                      },
                                      tipo: listaEmpaquetados,
                                    ),
                                  if (listaEmpaquetados.length == 6)
                                    buildCounterRow(
                                      number: _numberCajasMayor,
                                      onDecrement: () {
                                        _decrementNumber(
                                            _numberCajasMayor, descripEmp3);
                                      },
                                      onIncrement: () {
                                        _incrementNumber(
                                            _numberCajasMayor, descripEmp3);
                                      },
                                      tipo: listaEmpaquetados,
                                    ),
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
                            onPressed: () {
                              //Navigator.pushAndRemoveUntil(
                              //context,
                              //MaterialPageRoute(
                              //builder: (context) => CameraQR(widget.usuario, widget.inventarioexistente),
                              //),
                              //(route) => false,
                              //);
                              //TODO añadir producto en inventario
                              if (listaEmpaquetados.length == 2) {
                                String descripcionProducto = listaInfProd[0];
                                int idProducto = listaInfProd[2] as int;
                                int idInventario =
                                    widget.inventarioexistente.idInventario;
                                int idEmpaquetadoProd =
                                    listaEmpaquetados.elementAt(1) as int;
                                String descripcionEmpaquetado =
                                    listaEmpaquetados.elementAt(2);
                              }
                              if (listaEmpaquetados.length == 4) {
                                String descripcionProducto = listaInfProd[0];
                                int idProducto = listaInfProd[2] as int;
                                int idInventario =
                                    widget.inventarioexistente.idInventario;
                                int idEmpaquetadoProd =
                                    listaEmpaquetados.elementAt(1) as int;
                                String descripcionEmpaquetado =
                                    listaEmpaquetados.elementAt(2);
                                int idEmpaquetadoProd2 =
                                    listaEmpaquetados.elementAt(3) as int;
                                String descripcionEmpaquetado2 =
                                    listaEmpaquetados.elementAt(4);
                              }
                              if (listaEmpaquetados.length == 6) {
                                String descripcionProducto = listaInfProd[0];
                                int idProducto = listaInfProd[2] as int;
                                int idInventario =
                                    widget.inventarioexistente.idInventario;
                                int idEmpaquetadoProd3 =
                                    listaEmpaquetados.elementAt(5) as int;
                                String descripcionEmpaquetado3 =
                                    listaEmpaquetados.elementAt(6);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
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
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required Set<String> tipo,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            onDecrement();
          },
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.red, // Establecer el color de fondo deseado
              shape: BoxShape
                  .circle, // Opcional: dar forma de círculo al contenedor
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
          onPressed: () {
            onIncrement();
          },
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.green, // Establecer el color de fondo deseado
              shape: BoxShape
                  .circle, // Opcional: dar forma de círculo al contenedor
            ),
            child: Icon(Icons.add_circle),
          ),
        ),
        Container(
          child: Text(tipo.elementAt(1)),
        ),
        if (tipo.length != 4)
          Container(
            child: Text(tipo.elementAt(4)),
          ),
        if (tipo.length == 6)
          Container(
            child: Text(tipo.elementAt(6)),
          ),
      ],
    );
  }

  Future<void> accederInformacionCodigo(String scanResult) async {
    final listaInformacion = await API.getProductoCamara(widget.usuario);
    final producto = productoCamaraQR.fromJson(listaInformacion, scanResult);
    List<String> productoEscaneado = producto.productoEscaneado;
    accederDescripEmpaquetado(productoEscaneado[2]);
    setState(() {
      listaInfProd = productoEscaneado;
    });
  }

  Future<void> accederDescripEmpaquetado(String codigo) async {
    final listaEmpaquetadosProducto =
        await API.getEmpaquetadosProducto(widget.usuario);
    final producto =
        empaquetadosProducto.fromJson(listaEmpaquetadosProducto, codigo);
    List<String> infEmpaquetadoProd = producto.listaEmpaquetados;
    if (infEmpaquetadoProd.length == 0) {
      print('NO HAY EMPAQUETADO');
    } else {
      listaEmpaquetados = Set<String>.from(infEmpaquetadoProd);
    }
  }
}
