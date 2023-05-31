class TstocksDetallesInventario {
  int _linea;
  int _idInventario;
  int _idUnidadMedida;
  String _descripcionUnidadMedida;
  int _idProducto;
  String _descripcionProducto;
  int _idAlmacen;
  String _almacenDescripcion;
  int _idEmpaquetadoProducto;
  String _empaquetadoDescripcion;
  int _idCategoriaprincipal;
  String _categoriaprincipalDescripcion;
  int _idSubcategoria;
  String _subcategoriaDescripcion;
  double _cantidad;

  TstocksDetallesInventario({
    required int linea,
    required int idInventario,
    required int idUnidadMedida,
    required String descripcionUnidadMedida,
    required int idProducto,
    required String descripcionProducto,
    required int idAlmacen,
    required String almacenDescripcion,
    required int idEmpaquetadoProducto,
    required String empaquetadoDescripcion,
    required int idcategoriaprincipal,
    required String categoriaprincipaldescripcion,
    required int subcategoriaid,
    required String subcategoriadescripcion,
    required double cantidad,
  })  : _linea = linea,
        _idInventario = idInventario,
        _idUnidadMedida = idUnidadMedida,
        _descripcionUnidadMedida = descripcionUnidadMedida,
        _idProducto = idProducto,
        _descripcionProducto = descripcionProducto,
        _idAlmacen = idAlmacen,
        _almacenDescripcion = almacenDescripcion,
        _idEmpaquetadoProducto = idEmpaquetadoProducto,
        _empaquetadoDescripcion = empaquetadoDescripcion,
        _idCategoriaprincipal = idcategoriaprincipal,
        _categoriaprincipalDescripcion = categoriaprincipaldescripcion,
        _idSubcategoria = subcategoriaid,
        _subcategoriaDescripcion = subcategoriadescripcion,
        _cantidad = cantidad;

  Map<String, dynamic> toJson() {
    return {
      'linea' : _linea,
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
      'cantidadReal' : _cantidad,

    };
  }
  Map<String, dynamic> toMap() {
    return {
      'linea' : _linea,
      'idInventario': _idInventario,
      'idUnidadMedida': _idUnidadMedida,
      'descripcionUnidadMedida': _descripcionUnidadMedida,
      'idProducto': _idProducto,
      'descripcionProducto': _descripcionProducto,
      'idAlmacen': _idAlmacen,
      'almacenDescripcion': _almacenDescripcion,
      'idEmpaquetadoProducto': _idEmpaquetadoProducto,
      'empaquetadoDescripcion': _empaquetadoDescripcion,
      'idcategoriaprincipal' : _idCategoriaprincipal,
      'categoriaprincipalDescripcion' : _categoriaprincipalDescripcion,
      'idSubcategoria' : _idSubcategoria,
      'subcategoriaDescripcion' : _subcategoriaDescripcion,
      'cantidad': _cantidad,
    };
  }

  int get linea => _linea;

  double get cantidad => _cantidad;

  set cantidad(double value) {
    _cantidad = value;
  }

  int get idCategoriaprincipal => _idCategoriaprincipal;

  set idCategoriaprincipal(int value) {
    _idCategoriaprincipal = value;
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

  String get categoriaprincipalDescripcion => _categoriaprincipalDescripcion;

  set categoriaprincipalDescripcion(String value) {
    _categoriaprincipalDescripcion = value;
  }

  int get idSubcategoria => _idSubcategoria;

  set idSubcategoria(int value) {
    _idSubcategoria = value;
  }

  String get subcategoriaDescripcion => _subcategoriaDescripcion;

  set subcategoriaDescripcion(String value) {
    _subcategoriaDescripcion = value;
  }

  int get idInventario => _idInventario;

  set idInventario(int value) {
    _idInventario = value;
  }

  @override
  String toString() {
    return 'TstocksDetallesInventario{_linea: $_linea, _idInventario: $_idInventario, _idUnidadMedida: $_idUnidadMedida, _descripcionUnidadMedida: $_descripcionUnidadMedida, _idProducto: $_idProducto, _descripcionProducto: $_descripcionProducto, _idAlmacen: $_idAlmacen, _almacenDescripcion: $_almacenDescripcion, _idEmpaquetadoProducto: $_idEmpaquetadoProducto, _empaquetadoDescripcion: $_empaquetadoDescripcion, _idCategoriaprincipal: $_idCategoriaprincipal, _categoriaprincipalDescripcion: $_categoriaprincipalDescripcion, _idSubcategoria: $_idSubcategoria, _subcategoriaDescripcion: $_subcategoriaDescripcion, _cantidad: $_cantidad}';
  }
}


