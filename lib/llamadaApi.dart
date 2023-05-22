import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:projectobueno/User.dart';
import 'filtrosProductos.dart';

class API {
  static const String _urlProductos =
      'https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/productos';
  static const String _urlInventarios =
      'https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/inventarios';

  static Future<List> getFiltrosProductos(User usuario) async {
    var _token = usuario.token;
    final response = await http.get(
      Uri.parse(_urlProductos),
      headers: {'Authorization': 'Bearer $_token'},
    );
    print(response.statusCode);
    print(_token);
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
    print(response.statusCode);
    print(_token);
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
