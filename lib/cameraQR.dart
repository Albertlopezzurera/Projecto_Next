import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:projectobueno/User.dart';
import 'package:projectobueno/listaProductos.dart';
import 'package:projectobueno/myapp.dart';

class CameraQR extends StatefulWidget {
  CameraQR(User usuario);

  @override
  _CameraQRState createState() => _CameraQRState();
}

class _CameraQRState extends State<CameraQR> {
  Timer? _timer;
  String _scanResult ='';
  int _numberBotellas = 1;
  int _numberCajasMenor = 1;
  int _numberCajasMayor = 1;
  String botellas = 'botellas';
  String c_menor = 'c_menor';
  String c_mayor = 'c_mayor';

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  void _startScanning() async {
    while (true) {
      await Future.delayed(Duration(seconds: 2)); // Esperar 2 segundos antes de cada escaneo
      await _scanCode();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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


  @override
  Widget build(BuildContext context) {
    print(usuario.token);
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear codigo de barras'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _scanResult.isEmpty
                ? Text('Esperando datos de código')
                : Column(
              children: [
                Text('Contenido: $_scanResult'),
                // Resto del código
              ],
            ),
          ),
          Column(
            children: [
              Center(
                child: Text(' Puede modificar manualmente las cantidades registradas ó puede \n seguir escaneando codigos de otros productos.'),
              )
            ],
          ),
          Container(
            color: Colors.orange,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                        Row(
                          children: [
                            Column(
                              children: [
                                Text('ARTICULO'),
                                Text('CODIGO/CATEGORIA'),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            buildCounterRow(
                              number: _numberBotellas,
                              onDecrement: () {
                                _decrementNumber(_numberBotellas, botellas);
                              },
                              onIncrement: () {
                                _incrementNumber(_numberBotellas,botellas);
                              },
                            ),
                            buildCounterRow(
                              number: _numberCajasMenor,
                              onDecrement: () {
                                _decrementNumber(_numberCajasMenor,c_menor);
                              },
                              onIncrement: () {
                                _incrementNumber(_numberCajasMenor,c_menor);
                              },
                            ),
                            buildCounterRow(
                              number: _numberCajasMayor,
                              onDecrement: () {
                                _decrementNumber(_numberCajasMayor,c_mayor);
                              },
                              onIncrement: () {
                                _incrementNumber(_numberCajasMayor,c_mayor);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 7),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListaProductos(title: 'LISTA PRODUCTOS')),
          );
        }, // Desactivar el botón, ya que el escaneo es automático
        child: Icon(Icons.backspace_sharp),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  Widget buildCounterRow({required int number, required VoidCallback onDecrement, required VoidCallback onIncrement}){
    return Row(
      children: [
        IconButton(
          onPressed: () {
            onDecrement();
          },
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.red, // Establecer el color de fondo deseado
              shape: BoxShape.circle, // Opcional: dar forma de círculo al contenedor
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
          padding: EdgeInsets.all(8),
          child: Text('$number'),
        ),
        IconButton(
          onPressed: () {
            onIncrement();
          },
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.green, // Establecer el color de fondo deseado
              shape: BoxShape.circle, // Opcional: dar forma de círculo al contenedor
            ),
            child: Icon(Icons.add_circle),
          ),
        ),
      ],
    );
  }

  Future<void> _scanCode() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color personalizado para la pantalla de escaneo (opcional)
      'Cancelar', // Texto del botón de cancelar (opcional)
      true, // Mostrar flash (opcional)
      ScanMode.BARCODE, // Modo de escaneo (opcional). Puede ser ScanMode.BARCODE o ScanMode.QR
    );

    setState(() {
      _scanResult = result;
    });
  }

}
