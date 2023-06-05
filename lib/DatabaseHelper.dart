import 'package:projectobueno/TstocksDetallesInventario.dart';
import 'package:projectobueno/TstocksInventarios.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///Clase para el manejamiento de la base de datos en SQLite
///
/// [_database] instancia de la base de datos
class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  ///Getter para obtener la instancia de la base de datos
  ///
  ///si esta es nula creara la base de datos [_onCreateDB] con sus respectivas tablas y devuelve la instancia
  ///si no lo es devuelve la instancia de la base de datos
  ///
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('inventarioNextt.db');
    return _database!;

  }

  /// Obtención del path por defecto del SQLite3 procediendo a crear la base de datos
  /// y pasa a llamar a la funcion [_onCreateDB]
  /// [filePath] nombre de la base de datos
  Future<Database> _initDB(String filePath) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  /// Creación de las tablas
  Future _onCreateDB(Database db, int version) async {
    db.execute('''
        CREATE TABLE IF NOT EXISTS TStocksInventario (
        idInventario INTEGER PRIMARY KEY,
        identificador INTEGER,
        idDominio INTEGER,
        dominioDescripcion TEXT,
        idTienda INTEGER,
        tiendaDescripcion TEXT,
        idAlmacen INTEGER,
        almacenDescripcion TEXT,
        codigoInventario INTEGER,
        descripcionInventario TEXT,
        idTipoInventario INTEGER,
        tipoInventarioDescripcion TEXT,
        fechaRealizacionInventario TEXT,
        idEstadoInventario INTEGER,
        estadoInventario TEXT
      );
      '''
    );
    db.execute('''
    CREATE TABLE IF NOT EXISTS TStocksDetallesInventario (
      linea INTEGER PRIMARY KEY,
      idInventario INTEGER,
      idUnidadMedida INTEGER,
      descripcionUnidadMedida TEXT,
      idProducto INTEGER,
      descripcionProducto TEXT,
      idAlmacen INTEGER,
      almacenDescripcion TEXT,
      idEmpaquetadoProducto INTEGER,
      empaquetadoDescripcion TEXT,
      idcategoriaprincipal INTEGER,
      categoriaprincipalDescripcion TEXT,
      idSubcategoria INTEGER,
      subcategoriaDescripcion INTEGER,
      cantidad INTEGER,
      cantidadtotal INTEGER,
      cantidadcaja INTEGER,
      FOREIGN KEY (idInventario) REFERENCES TStocksInventario(idInventario)
    );
    ''');
  }
  ///Inserta un nuevo inventario en la tabla de Inventarios
  Future<void> insert(TstocksInventarios inventario) async {
    //Database database = await DatabaseHelper._database);
    final db = await instance.database;
    await db.insert("TStocksInventario", inventario.toMap());
  }
  ///Elimina un nuevo inventario en la tabla de Inventarios
  Future<void> delete(TstocksInventarios inventario) async {
    final db = await instance.database;

    await db.delete("TStocksInventario", where: "idInventario = ?", whereArgs: [inventario.idInventario]);

  }
  ///Actualiza un nuevo inventario en la tabla de Inventarios
  Future<void> update(TstocksInventarios inventario) async {
    final db = await instance.database;

    await db.update("TStocksInventario", inventario.toMap(), where: "idInventario = ?", whereArgs: [inventario.idInventario]);

  }
  ///Devuelve una lista de inventarios de la base de datos, SELECT * FROM TStocksInventario
  Future<List<TstocksInventarios>> filtrarInventarios() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> inventariosMap = await db.query("TStocksInventario");
    return List.generate(inventariosMap.length, (i) => TstocksInventarios(
        idInventario: inventariosMap[i]["idInventario"],
        identificador: inventariosMap[i]["identificador"],
        idDominio: inventariosMap[i]["idDominio"],
        dominioDescripcion: inventariosMap[i]["dominioDescripcion"],
        idTienda: inventariosMap[i]["idTienda"],
        tiendaDescripcion: inventariosMap[i]["tiendaDescripcion"],
        idAlmacen: inventariosMap[i]["idAlmacen"],
        almacenDescripcion: inventariosMap[i]["almacenDescripcion"],
        codigoInventario: inventariosMap[i]["codigoInventario"],
        descripcionInventario: inventariosMap[i]["descripcionInventario"],
        idTipoInventario: inventariosMap[i]["idTipoInventario"],
        tipoInventarioDescripcion: inventariosMap[i]["tipoInventarioDescripcion"],
        fechaRealizacionInventario: inventariosMap[i]["fechaRealizacionInventario"],
        idEstadoInventario: inventariosMap[i]["idEstadoInventario"],
        estadoInventario: inventariosMap[i]["estadoInventario"],
        detallesInventario: []
    ));
  }

  ///Consulta que comprueba si el id inventario pasado por parametro existe en la base de datos
  ///[idInventario] int - num inv para buscar por id
  Future<bool> filtrarInventarioporId(int idInventario) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> inventariosMap = await db.rawQuery('SELECT * FROM TStocksInventario WHERE identificador = ?', [idInventario]);
    return inventariosMap.isNotEmpty;
  }

  ///Obtiene el maximo idInventario y le suma un digito, para la insercion de un nuevo inventario
  Future<int> obtenerUltimoId() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> resultado =
    await db.rawQuery('SELECT MAX(idInventario) as ultimoId FROM TStocksInventario');

    int ultimoId = resultado.first['ultimoId'] as int? ?? 0;
    return ultimoId + 1;
  }

  ///Devuelve una lista de TstocksDetallesInventario, SELECT * FROM TstocksDetallesInventario
  Future<List<TstocksDetallesInventario>> filtrarDetallesInventario() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> detallesMap = await db.query("TstocksDetallesInventario");
    return List.generate(detallesMap.length, (i) => TstocksDetallesInventario(
      linea: detallesMap[i]["linea"],
      idInventario: detallesMap[i]["idInventario"],
      idUnidadMedida: detallesMap[i]["idUnidadMedida"],
      descripcionUnidadMedida: detallesMap[i]["descripcionUnidadMedida"],
      idProducto: detallesMap[i]["idProducto"],
      descripcionProducto: detallesMap[i]["descripcionProducto"],
      idAlmacen: detallesMap[i]["idAlmacen"],
      almacenDescripcion: detallesMap[i]["almacenDescripcion"],
      idEmpaquetadoProducto: detallesMap[i]["idEmpaquetadoProducto"],
      empaquetadoDescripcion: detallesMap[i]["empaquetadoDescripcion"],
      cantidad: double.parse(detallesMap[i]["cantidad"].toString()),
      idcategoriaprincipal: detallesMap[i]["idCategoriaprincipal"] as int? ?? 0,
      categoriaprincipaldescripcion: detallesMap[i]["categoriaprincipalDescripcion"],
      subcategoriaid: detallesMap[i]["idSubcategoria"],
      subcategoriadescripcion: detallesMap[i]["subcategoriaDescripcion"],
      cantidadtotal:  double.parse(detallesMap[i]["cantidadtotal"].toString()),
      cantidadcaja:  double.parse(detallesMap[i]["cantidadcaja"].toString()),
    ));
  }
  ///Obtiene la maxima linea y le suma un digito, para la insercion de un nuevo producto
  Future<int> obtenerUltimoIdDetalles() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> resultado =
    await db.rawQuery('SELECT MAX(linea) as ultimoId FROM TStocksDetallesInventario');

    int ultimoId = resultado.first['ultimoId'] as int? ?? 0;
    return ultimoId + 1;
  }

  ///Inserta un producto en la base de datos
  Future<void> insertDetalles(TstocksDetallesInventario producto) async {
    final db = await instance.database;

    await db.insert("TStocksDetallesInventario", producto.toMap());

  }
  ///Elimina un producto de la base de datos
  Future<void> deleteDetalles(TstocksDetallesInventario producto) async {
    final db = await instance.database;

    await db.delete("TStocksDetallesInventario", where: "linea = ?", whereArgs: [producto.linea]);

  }
  ///Actualiza un producto de la base de datos
  Future<void> updateDetalles(TstocksDetallesInventario producto) async {
    final db = await instance.database;

    await db.update("TStocksDetallesInventario", producto.toMap(), where: "linea = ?", whereArgs: [producto.linea]);

  }
  ///Devuelve una lista de productos filtrados por un parametro.
  ///
  /// 'idInventario' int - parametro a pasar para filtrar productos con el idinventario pasado por parametro
  Future<List<TstocksDetallesInventario>> filtrarDetallesInventarioPorId(int idInventario) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> detallesMap = await db.query(
      "TstocksDetallesInventario",
      where: "idInventario = ?",
      whereArgs: [idInventario],
    );

    return List.generate(detallesMap.length, (i) => TstocksDetallesInventario(
      linea: detallesMap[i]["linea"],
      idInventario: detallesMap[i]["idInventario"],
      idUnidadMedida: detallesMap[i]["idUnidadMedida"],
      descripcionUnidadMedida: detallesMap[i]["descripcionUnidadMedida"],
      idProducto: detallesMap[i]["idProducto"],
      descripcionProducto: detallesMap[i]["descripcionProducto"],
      idAlmacen: detallesMap[i]["idAlmacen"],
      almacenDescripcion: detallesMap[i]["almacenDescripcion"],
      idEmpaquetadoProducto: detallesMap[i]["idEmpaquetadoProducto"],
      empaquetadoDescripcion: detallesMap[i]["empaquetadoDescripcion"],
      cantidad: double.parse(detallesMap[i]["cantidad"].toString()),
      idcategoriaprincipal: detallesMap[i]["idCategoriaprincipal"] as int? ?? 0,
      categoriaprincipaldescripcion: detallesMap[i]["categoriaprincipalDescripcion"],
      subcategoriaid: detallesMap[i]["idSubcategoria"],
      subcategoriadescripcion: detallesMap[i]["subcategoriaDescripcion"],
      cantidadtotal:  double.parse(detallesMap[i]["cantidadtotal"].toString()),
      cantidadcaja:  double.parse(detallesMap[i]["cantidadcaja"].toString()),
    ));
  }

}
