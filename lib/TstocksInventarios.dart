import 'TstocksDetallesInventario.dart';

class TstocksInventarios {
  int _idInventario;
  int? _identificador;
  int? _idDominio;
  String? _dominioDescripcion;
  int? _idTienda;
  String? _tiendaDescripcion;
  int? _idAlmacen;
  String? _almacenDescripcion;
  int? _codigoInventario;
  String? _descripcionInventario;
  int? _idTipoInventario;
  String? _tipoInventarioDescripcion;
  String? _fechaRealizacionInventario;
  int? _idEstadoInventario;
  String? _estadoInventario;
  List<TstocksDetallesInventario>? _detallesInventario;

  TstocksInventarios({
    required int idInventario,
    int? identificador,
    int? idDominio,
    String? dominioDescripcion,
    int? idTienda,
    String? tiendaDescripcion,
    int? idAlmacen,
    String? almacenDescripcion,
    int? codigoInventario,
    String? descripcionInventario,
    int? idTipoInventario,
    String? tipoInventarioDescripcion,
    String? fechaRealizacionInventario,
    int? idEstadoInventario,
    String? estadoInventario,
    List<TstocksDetallesInventario>? detallesInventario,
  })  : _idInventario = idInventario,
        _identificador = identificador,
        _idDominio = idDominio,
        _dominioDescripcion = dominioDescripcion,
        _idTienda = idTienda,
        _tiendaDescripcion = tiendaDescripcion,
        _idAlmacen = idAlmacen,
        _almacenDescripcion = almacenDescripcion,
        _codigoInventario = codigoInventario,
        _descripcionInventario = descripcionInventario,
        _idTipoInventario = idTipoInventario,
        _tipoInventarioDescripcion = tipoInventarioDescripcion,
        _fechaRealizacionInventario = fechaRealizacionInventario,
        _idEstadoInventario = idEstadoInventario,
        _estadoInventario = estadoInventario,
        _detallesInventario = detallesInventario;


  Map<String, dynamic> toJson() {
    return {
      'id': _idInventario,
      'idDominio_descripcion': {
        'id': _idDominio,
        'descripcion' : _dominioDescripcion
      },
      'idTienda_descripcion': {
        'id': _idTienda,
        'descripcion' : _tiendaDescripcion
      },
      'idAlmacen_descripcion': {
        'id': _idAlmacen,
        'descripcion' : _almacenDescripcion
      },
      'codigo': _codigoInventario,
      'descripcion': _descripcionInventario,
      'idTipoInventario_descripcion': {
        'id': _idTipoInventario,
        'descripcion' : _tipoInventarioDescripcion
      },
      'fechaRealizacionInventario': _fechaRealizacionInventario,
      'idEstadoInventario_descripcion': {
        'id': _idEstadoInventario,
        'descripcion' : _estadoInventario
      },
    };
  }
  Map<String, dynamic> toMap() {
    return {
      'idInventario': _idInventario,
      'identificador': _identificador,
      'idDominio': _idDominio,
      'dominioDescripcion': _dominioDescripcion,
      'idTienda': _idTienda,
      'tiendaDescripcion': _tiendaDescripcion,
      'idAlmacen': _idAlmacen,
      'almacenDescripcion': _almacenDescripcion,
      'codigoInventario': _codigoInventario,
      'descripcionInventario': _descripcionInventario,
      'idTipoInventario': _idTipoInventario,
      'tipoInventarioDescripcion': _tipoInventarioDescripcion,
      'fechaRealizacionInventario': _fechaRealizacionInventario,
      'idEstadoInventario': _idEstadoInventario,
      'estadoInventario': _estadoInventario,
    };
  }


  int get idInventario => _idInventario;

  set idInventario(int value) {
    _idInventario = value;
  }

  set identificador(int value) {
    _identificador = value;
  }


  set idDominio(int value) {
    _idDominio = value;
  }


  set dominioDescripcion(String value) {
    _dominioDescripcion = value;
  }


  set idTienda(int value) {
    _idTienda = value;
  }

  set tiendaDescripcion(String value) {
    _tiendaDescripcion = value;
  }


  set idAlmacen(int value) {
    _idAlmacen = value;
  }


  set almacenDescripcion(String value) {
    _almacenDescripcion = value;
  }


  set codigoInventario(int value) {
    _codigoInventario = value;
  }


  set descripcionInventario(String value) {
    _descripcionInventario = value;
  }


  set idTipoInventario(int value) {
    _idTipoInventario = value;
  }


  set tipoInventarioDescripcion(String value) {
    _tipoInventarioDescripcion = value;
  }


  set fechaRealizacionInventario(String value) {
    _fechaRealizacionInventario = value;
  }


  set idEstadoInventario(int value) {
    _idEstadoInventario = value;
  }


  set estadoInventario(String value) {
    _estadoInventario = value;
  }


  set detallesInventario(List<TstocksDetallesInventario> value) {
    _detallesInventario = value;
  }

  @override
  String toString() {
    return 'TstocksInventarios{_idInventario: $_idInventario, _identificador: $_identificador, _idDominio: $_idDominio, _dominioDescripcion: $_dominioDescripcion, _idTienda: $_idTienda, _tiendaDescripcion: $_tiendaDescripcion, _idAlmacen: $_idAlmacen, _almacenDescripcion: $_almacenDescripcion, _codigoInventario: $_codigoInventario, _descripcionInventario: $_descripcionInventario, _idTipoInventario: $_idTipoInventario, _tipoInventarioDescripcion: $_tipoInventarioDescripcion, _fechaRealizacionInventario: $_fechaRealizacionInventario, _idEstadoInventario: $_idEstadoInventario, _estadoInventario: $_estadoInventario, _detallesInventario: $_detallesInventario}';
  }
}












