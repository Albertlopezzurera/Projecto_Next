import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Pantalla de recuperación de contraseña.
///
/// Esta clase representa la pantalla de recuperación de contraseña en la aplicación.
/// Proporciona una interfaz para que el usuario ingrese su dirección de correo electrónico
/// y solicite la recuperación de su contraseña.
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
  TextEditingController _emailController = new TextEditingController();

  /// Recupera la contraseña para la dirección de correo electrónico proporcionada.
  ///
  /// Hace una solicitud HTTP para solicitar la recuperación de la contraseña asociada a la dirección de correo electrónico.
  /// Muestra un diálogo de éxito si la solicitud es exitosa, o un diálogo de error si la solicitud falla.
  Future<void> recuperarPassword(String email) async {
    final url = Uri.parse(
        "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/recuperarPassword/peticionCambioPassword");

    final response = await http.post(
      url,
      body: json.encode({"formData": {"email": email}}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text("Recuperación de contraseña"),
            content: Text("Si su e-mail está registrado en el sistema recibira un correo. Revise su buzón de entrada y siga"
                " los pasos de recuperación de contraseña que se indican."),
            actions: <Widget>[
              TextButton(
                child: Text("Aceptar"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
    } else {
      // La solicitud no fue exitosa
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text("ERROR"),
            content: Text("Ocurrió un error en la solicitud. Código de estado: ${response.statusCode}"),
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
    }
  }

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
              controller: _emailController,
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
              String email = _emailController.text;
              if (!email.isEmpty) {
                recuperarPassword(email);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: Text("ERROR"),
                      content: Text("Error al recuperar.\nRellene el campo!"),
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
              }
            },
            child: Text('Recuperar Contraseña'),
          ),
        ));
  }
}