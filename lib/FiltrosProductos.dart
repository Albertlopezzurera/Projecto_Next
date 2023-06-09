///
/// Clase filtrosProductos nos procesa el Json recibido por la API y nos devuelve un [jsonList].
/// Aqui procesamos el Json y cogemos los campos necesarios que queremos para mostrarlo en la pestaña de filtros.
///
class filtrosProductos{
  final List<dynamic>json;
  filtrosProductos(this.json);
  factory filtrosProductos.fromJson(List<dynamic> jsonList) {
    Set<String> listaCategorias = {};
    Map<String, String> subCategorias = {};
    List<String> tipoConservacion = [];
    jsonList.forEach((json) {
      Map<String, dynamic> mapa = json;
      String descripcionCategoria = mapa['idCategoriaEstadisticas_nombre']['descripcion'];
      String path_Completo = mapa['idCategoriaEstadisticas_pathCompleto']['descripcion'];
        listaCategorias.add(descripcionCategoria);
        if (!subCategorias.containsKey(descripcionCategoria) && !subCategorias.containsValue(path_Completo)){
          subCategorias[descripcionCategoria] = path_Completo;
        }
        if (mapa.containsKey('idImpresoraCocina_descripcion') &&
            mapa['idImpresoraCocina_descripcion'] != null) {
          String conservar = mapa['idImpresoraCocina_descripcion']['descripcion'];
          if (!tipoConservacion.contains(conservar)) {
            tipoConservacion.add(conservar);
          }
        }
      }
    );
    return filtrosProductos(jsonList);
  }
}

