import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectobueno/paginaPrincipal.dart';
import 'package:projectobueno/recuperacionPass.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVENTARIO SUPERMERCADO',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title:'INVENTARIO SUPERMERCADO'),
    );
  }
}

class MyHomePage extends StatelessWidget{
  MyHomePage({required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
                hintText: "Usuario",
              ),
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Contraseña",
              ),
            ),
            GestureDetector(
              onTap: () {
                // Aquí puedes agregar la acción que quieres ejecutar cuando se toque el texto
                print("Olvidaste la contraseña?");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => recuperacionPass()),
                );
              },
              child: Text(
                "Olvidaste la contraseña?",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),bottomNavigationBar: Container(
      margin: EdgeInsets.all(16), // Margen alrededor del botón
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => paginaPrincipal()),
          );
        },
        child: Text('Iniciar Sesión'),
      ),
    )
    );
  }
}