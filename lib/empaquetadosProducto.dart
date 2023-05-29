class empaquetadosProducto{
  final List<String> listaEmpaquetados;
  empaquetadosProducto({required this.listaEmpaquetados});

  factory empaquetadosProducto.fromJson(List<dynamic> jsonList, String codigo) {
    List<String> empaquetados = [];
    String descripcionEmpaquet2 = "";
    for (int i = 0; i < jsonList.length; i++) {
      Map<String, dynamic> mapa = jsonList[i];
      String codigoProducto = mapa['idProducto_nombre']['codigo'];
      String codigoEmpaquet1 = mapa['id'];
      String descripcionEmpaquet1 = mapa['descripcion'];
      if (codigo == codigoProducto){
        empaquetados.add(codigoProducto.toString());
        empaquetados.add(codigoEmpaquet1.toString());
        empaquetados.add(descripcionEmpaquet1);
      }
      if (codigo == codigoProducto && empaquetados.length==2 && !empaquetados[2].contains(mapa['descripcion'])){
        String codigoEmpaquet2 = mapa['id'];
        String descripcionEmpaquet2 = mapa['descripcion'];
        empaquetados.add(codigoEmpaquet2.toString());
        empaquetados.add(descripcionEmpaquet2);
      }
      if (codigo == codigoProducto && empaquetados.length==4 && !empaquetados[4].contains(mapa['descripcion'])){
        String codigoEmpaquet3 = mapa['id'];
        String descripcionEmpaquet3 = mapa['descripcion'];
        empaquetados.add(codigoEmpaquet3.toString());
        empaquetados.add(descripcionEmpaquet3);
      }
    }
    return empaquetadosProducto(listaEmpaquetados: empaquetados);
  }

}