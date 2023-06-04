import 'package:flutter/material.dart';

class empaquetadosProducto{
  final List<String> listaEmpaquetados;
  empaquetadosProducto({required this.listaEmpaquetados});

  factory empaquetadosProducto.fromJson(List<dynamic> jsonList, String codigo) {
    List<String> empaquetados = [];
    for (int i = 0; i < jsonList.length; i++) {
      Map<String, dynamic> mapa = jsonList[i];
      String codigoProducto = mapa['idProducto_nombre']['codigo'].toString();
      String codigoEmpaquet1 = mapa['id'].toString();
      String descripcionEmpaquet1 = mapa['descripcion'];
      String factorEmpaquetado = mapa['factorEmpaquetado'].toString();
      if (codigo == codigoProducto){
        empaquetados.add(codigoProducto.toString());
        empaquetados.add(codigoEmpaquet1.toString());
        empaquetados.add(descripcionEmpaquet1);
        empaquetados.add(factorEmpaquetado);
      }
      if (codigo == codigoProducto && empaquetados.length==3 && !empaquetados[2].contains(mapa['descripcion'])){
        String codigoEmpaquet2 = mapa['id'].toString();
        String descripcionEmpaquet2 = mapa['descripcion'];
        String factorEmpaquetado2 = mapa['factorEmpaquetado'];
        empaquetados.add(codigoEmpaquet2.toString());
        empaquetados.add(descripcionEmpaquet2);
        empaquetados.add(factorEmpaquetado2);
      }
      if (codigo == codigoProducto && empaquetados.length==5 && !empaquetados[4].contains(mapa['descripcion'])){
        String codigoEmpaquet3 = mapa['id'].toString();
        String descripcionEmpaquet3 = mapa['descripcion'];
        String factorEmpaquetado3 = mapa['factorEmpaquetado'];
        empaquetados.add(codigoEmpaquet3.toString());
        empaquetados.add(descripcionEmpaquet3);
        empaquetados.add(factorEmpaquetado3);
      }
    }
    for (int i=0; i<empaquetados.length; i++){
      print('empaquetados ESCANEADO');
      print(empaquetados[i]);
    }
    return empaquetadosProducto(listaEmpaquetados: empaquetados);
  }

}