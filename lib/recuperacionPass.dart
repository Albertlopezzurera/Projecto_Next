import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectobueno/myapp.dart';
import 'package:projectobueno/paginaPrincipal.dart';

class recuperacionPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVENTARIO SUPERMERCADO',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: RecPass(title: 'RECUPERACION DE CONTRASEÑA'),
    );
  }
}

class RecPass extends StatefulWidget {
  final String title;

  RecPass({required this.title});

  @override
  _RecuperacionPassState createState() => _RecuperacionPassState();
}

class _RecuperacionPassState extends State<RecPass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recuperación de Contraseña'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Dominio",
              ),
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "E-Mail",
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(16), // Margen alrededor del botón
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => paginaPrincipal(usuario)), //TODO
              );
            },
            child: Text('Recuperar Contraseña'),
          ),
        ));
  }
}
