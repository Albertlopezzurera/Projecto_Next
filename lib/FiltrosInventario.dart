///
/// Clase filtrosInventario encargada de buscar los filtros relacionados con los inventarios.
/// Recibe por parametro [inventario], el cual es una List de tipo Inventario.
///
class filtrosInventario {
  final List<Inventario> inventario;

  filtrosInventario({required this.inventario});

  factory filtrosInventario.fromJson(List<dynamic> jsonList) {
    List<Inventario> listaInventarios = [];
    jsonList.forEach((json) {
      Map<String, dynamic> mapa = json;
      int _idInventario = mapa['id'];
      String _nTienda = mapa['idTienda_descripcion']['descripcion'];
      String _tInventario = mapa['idTipoInventario_descripcion']['descripcion'];
      String _eInventario =
          mapa['idEstadoInventario_descripcion']['descripcion'];
        Inventario inv = Inventario(
            idInventario: _idInventario,
            nombreTienda: _nTienda,
            tipoInventario: _tInventario,
            estadoInventario: _eInventario);
        listaInventarios.add(inv);

    });
    return filtrosInventario(inventario: listaInventarios);
  }
}

///
/// Clase Inventario la cual declara los parámetros que tiene que tener un Inventario.
///
class Inventario {
  final int idInventario;
  final String nombreTienda;
  final String tipoInventario;
  final String estadoInventario;
  Inventario(
      {required this.idInventario,
      required this.nombreTienda,
      required this.tipoInventario,
      required this.estadoInventario});
  int get getIdInventario => idInventario;
  String get getNombreTienda => nombreTienda;
  String get getTipoInventario => tipoInventario;
  String get getEstadoInventario => estadoInventario;
}
