import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectobueno/cameraQR.dart';
import 'package:xml/xml.dart' as xml;
import 'package:projectobueno/User.dart';
import 'package:projectobueno/paginaPrincipal.dart';
import 'package:projectobueno/recuperacionPass.dart';
import 'dart:convert';

var usuario = User();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVENTARIO SUPERMERCADO',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'INVENTARIO SUPERMERCADO'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({required this.title});

  String title;

  TextEditingController _usuarioController = new TextEditingController();
  TextEditingController _negocioController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  var validado = false;

  Future<void> retrieveName() async {
    var token = usuario.token;

    final response = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/usuarios"),
      headers: {"Authorization": "Bearer $token"},
    );

    var data = jsonDecode(response.body);

    String domain = _negocioController.text;

    for (data in data) {
      if ((usuario.username == data["username"]) &&
          (domain == data["idDominio_descripcion"]["descripcion"])) {
        usuario.nombre = data["nombre"];
        usuario.iddominio = data["idDominio_descripcion"]["id"];
        usuario.dominio = data["idDominio_descripcion"]["descripcion"];
        usuario.idusername = data["id"];
        validado = true;
        break;
      }
    }
  }

  Future<void> login(BuildContext context) async {
    var grantType = 'password';
    var clientId = 'nexttdirector';
    var username = _usuarioController.text;
    var password = _passwordController.text;
    var scope = 'read';

    final response = await http.post(
      Uri.parse(
          'https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/oauth/token'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'grant_type': grantType,
        'client_id': clientId,
        'username': username,
        'password': password,
        'scope': scope,
      },
    );

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      usuario.username = username;
      usuario.token = document.findAllElements('access_token').first.text;
      // Hacer algo con el token, como almacenarlo en la aplicación o enviarlo a otra API
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text("ERROR"),
            content: Text("Error al iniciar sesión. \nCompruebe los campos."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
      //ACTIVAR AQUI ERROR PARA MOSTRAR EN PANTALLA
    }
  }

  @override
  Widget build(BuildContext context) {
    String negocio = "";
    String usuario = "";
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _negocioController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Dominio",
              ),
            ),
            TextField(
              controller: _usuarioController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Usuario",
              ),
            ),
            TextField(
              controller: _passwordController,
              textAlign: TextAlign.center,
              //OCULTAR TEXTO
              obscureText: true,
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
            ),
            SizedBox(height: 16),
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(16), // Margen alrededor del botón
          child: ElevatedButton(
            onPressed: () async {
              await login(context);
              await retrieveName();
              comprobacionLogin(validado, context);
            },
            child: Text('Iniciar Sesión'),
          ),
        ));
  }

  void comprobacionLogin(bool validado, BuildContext context) {
    if (validado == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => paginaPrincipal(usuario)),
      );
    }
  }
}
