///
/// Clase empaquetadosProducto encargada de recibir en este caso una variable llamada [listaEmpaquetados].
/// Esta variable es una List<String> donde almacenaremos de cada producto sus diferentes empaquetados.
///
/// Metodo que va leyendo el fichero Json que recibimos de la API donde tenemos un parametro [codigo] que es un String.
/// La variable codigo es el codigo del producto que hemos escaneado y que queremos conseguir información sobre los diversos empaquetados que tiene.
/// Hacemos un bucle que recorra el archivo Json.
/// En este bucle recogemos los campos del Json que nos interesan y se recogen de la siguiente manera:
/// mapa[] mapa es la variable que que esta leyendo el Json y dentro de los corchetes va el campo a guardar del Json
/// Aqui lo que queremos es comprobar los diferentes empaquetados y que no se repitan, como hay productos que pueden tener 1 o mas empaquetados,
/// aqui miramos esa información y la devolvemos en forma DE List<String>
///
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
    return empaquetadosProducto(listaEmpaquetados: empaquetados);
  }

}