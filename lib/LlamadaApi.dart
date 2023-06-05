import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:projectobueno/User.dart';
import 'FiltrosProductos.dart';

///
/// Clase API, encargada de tener las URL, para cada petición.
/// Tenemos diferentes variables que son [_urlProductos],[_urlInventarios],[_urlEmpaquetadosProducto],[_urlDetallesInventario]
/// Recibimos en la mayoria de funciones la variable [usuario], la cual extraemos el token y comprobamos que ese usuario y el token sean correctos.
///
class API {
  static const String _urlProductos =
      'https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/productos';
  static const String _urlInventarios =
      'https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios';
  static const String _urlEmpaquetadosProducto = 'https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/empaquetadosProducto';
  static const String _urlDetallesInventario = 'https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/detallesInventario';

  static Future<List> getFiltrosProductos(User usuario) async {
    var _token = usuario.token;
    final response = await http.get(
      Uri.parse(_urlProductos),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  static Future<List> getFiltrosInventarios(User usuario) async {
    var _token = usuario.token;
    final response = await http.get(
      Uri.parse(_urlInventarios),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  static Future<List> getProductoCamara(User usuario) async {
    var _token = usuario.token;
    final response = await http.get(
      Uri.parse(_urlProductos),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  static Future<List> getEmpaquetadosProducto(User usuario) async {
    var _token = usuario.token;
    final response = await http.get(
      Uri.parse(_urlEmpaquetadosProducto),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  static Future<List> retrieveInventarioDetalles(User usuario)async {
    var _token = usuario.token;
    final response = await http.get(
      Uri.parse(_urlDetallesInventario),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }


}
