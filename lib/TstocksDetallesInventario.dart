class TstocksDetallesInventario {
  int _linea;
  int _idDetalle;
  int _idInventario;
  int _idUnidadMedida;
  String _descripcionUnidadMedida;
  int _idProducto;
  String _descripcionProducto;
  int _idAlmacen;
  String _almacenDescripcion;
  int _idEmpaquetadoProducto;
  String _empaquetadoDescripcion;
  int _idTipoDetalle;
  String _descripcionTipoDetalle;
  double _cantidad;

  TstocksDetallesInventario({
    required int linea,
    required int idDetalle,
    required int idInventario,
    required int idUnidadMedida,
    required String descripcionUnidadMedida,
    required int idProducto,
    required String descripcionProducto,
    required int idAlmacen,
    required String almacenDescripcion,
    required int idEmpaquetadoProducto,
    required String empaquetadoDescripcion,
    required int idTipoDetalle,
    required String descripcionTipoDetalle,
    required double cantidad,
  })  : _linea = linea,
        _idDetalle = idDetalle,
        _idInventario = idInventario,
        _idUnidadMedida = idUnidadMedida,
        _descripcionUnidadMedida = descripcionUnidadMedida,
        _idProducto = idProducto,
        _descripcionProducto = descripcionProducto,
        _idAlmacen = idAlmacen,
        _almacenDescripcion = almacenDescripcion,
        _idEmpaquetadoProducto = idEmpaquetadoProducto,
        _empaquetadoDescripcion = empaquetadoDescripcion,
        _idTipoDetalle = idTipoDetalle,
        _descripcionTipoDetalle = descripcionTipoDetalle,
        _cantidad = cantidad;

  Map<String, dynamic> toJson() {
    return {
      'linea' : _linea,
      'id': _idDetalle,
      'idInventario_descripcion': {
        "id": _idInventario,
      },
      'idProducto_idUnidadDeMedidaGeneral_nombre': {
        "id": _idUnidadMedida,
        "descripcion": _descripcionUnidadMedida
      },
      'idAlmacen_descripcion': {
        'id': _idAlmacen,
        'descripcion' : _almacenDescripcion
      },
      'idEmpaquetadoProducto_descripcion': {
        "id": _idEmpaquetadoProducto,
        "descripcion": _empaquetadoDescripcion
      },
      'idProducto_nombre': {
        "id": _idProducto,
        "descripcion": _descripcionProducto
      },
      'idTiposdetalle_descripcion': {
        "id": _idTipoDetalle,
        "descripcion": _descripcionTipoDetalle
      },
      'cantidadReal' : _cantidad,

    };
  }
  Map<String, dynamic> toMap() {
    return {
      'linea' : _linea,
      'idDetalle': _idDetalle,
      'idInventario': _idInventario,
      'idUnidadMedida': _idUnidadMedida,
      'descripcionUnidadMedida': _descripcionUnidadMedida,
      'idProducto': _idProducto,
      'descripcionProducto': _descripcionProducto,
      'idAlmacen': _idAlmacen,
      'almacenDescripcion': _almacenDescripcion,
      'idEmpaquetadoProducto': _idEmpaquetadoProducto,
      'empaquetadoDescripcion': _empaquetadoDescripcion,
      'idTipoDetalle': _idTipoDetalle,
      'descripcionTipoDetalle': _descripcionTipoDetalle,
      'cantidad': _cantidad,
    };
  }

  int get linea => _linea;

  double get cantidad => _cantidad;

  set cantidad(double value) {
    _cantidad = value;
  }

  String get descripcionTipoDetalle => _descripcionTipoDetalle;

  set descripcionTipoDetalle(String value) {
    _descripcionTipoDetalle = value;
  }

  int get idTipoDetalle => _idTipoDetalle;

  set idTipoDetalle(int value) {
    _idTipoDetalle = value;
  }

  String get empaquetadoDescripcion => _empaquetadoDescripcion;

  set empaquetadoDescripcion(String value) {
    _empaquetadoDescripcion = value;
  }

  int get idEmpaquetadoProducto => _idEmpaquetadoProducto;

  set idEmpaquetadoProducto(int value) {
    _idEmpaquetadoProducto = value;
  }

  String get almacenDescripcion => _almacenDescripcion;

  set almacenDescripcion(String value) {
    _almacenDescripcion = value;
  }

  int get idAlmacen => _idAlmacen;

  set idAlmacen(int value) {
    _idAlmacen = value;
  }

  String get descripcionProducto => _descripcionProducto;

  set descripcionProducto(String value) {
    _descripcionProducto = value;
  }

  int get idProducto => _idProducto;

  set idProducto(int value) {
    _idProducto = value;
  }

  String get descripcionUnidadMedida => _descripcionUnidadMedida;

  set descripcionUnidadMedida(String value) {
    _descripcionUnidadMedida = value;
  }

  int get idUnidadMedida => _idUnidadMedida;

  set idUnidadMedida(int value) {
    _idUnidadMedida = value;
  }

  int get idInventario => _idInventario;

  set idInventario(int value) {
    _idInventario = value;
  }

  int get idDetalle => _idDetalle;

  set idDetalle(int value) {
    _idDetalle = value;
  }

  @override
  String toString() {
    return 'TstocksDetallesInventario{_idDetalle: $_idDetalle, _idInventario: $_idInventario, _idUnidadMedida: $_idUnidadMedida, _descripcionUnidadMedida: $_descripcionUnidadMedida, _idProducto: $_idProducto, _descripcionProducto: $_descripcionProducto, _idAlmacen: $_idAlmacen, _almacenDescripcion: $_almacenDescripcion, _idEmpaquetadoProducto: $_idEmpaquetadoProducto, _empaquetadoDescripcion: $_empaquetadoDescripcion, _idTipoDetalle: $_idTipoDetalle, _descripcionTipoDetalle: $_descripcionTipoDetalle, _cantidad: $_cantidad}';
  }
}


