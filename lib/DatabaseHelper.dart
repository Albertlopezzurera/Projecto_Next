import 'package:projectobueno/TstocksDetallesInventario.dart';
import 'package:projectobueno/TstocksInventarios.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('inventarioNextt.db');
    return _database!;

  }

  Future<Database> _initDB(String filePath) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

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
      idDetalle INTEGER,
      idInventario INTEGER,
      idUnidadMedida INTEGER,
      descripcionUnidadMedida TEXT,
      idProducto INTEGER,
      descripcionProducto TEXT,
      idAlmacen INTEGER,
      almacenDescripcion TEXT,
      idEmpaquetadoProducto INTEGER,
      empaquetadoDescripcion TEXT,
      idTipoDetalle INTEGER,
      descripcionTipoDetalle TEXT,
      cantidad INTEGER,
      FOREIGN KEY (idInventario) REFERENCES TStocksInventario(idInventario)
    );
    ''');
  }
  Future<void> insert(TstocksInventarios inventario) async {
    //Database database = await DatabaseHelper._database);
    final db = await instance.database;
    await db.insert("TStocksInventario", inventario.toMap());
  }
  Future<void> delete(TstocksInventarios inventario) async {
    final db = await instance.database;

    await db.delete("TStocksInventario", where: "idInventario = ?", whereArgs: [inventario.idInventario]);

  }
  Future<void> update(TstocksInventarios inventario) async {
    final db = await instance.database;

    await db.update("TStocksInventario", inventario.toMap(), where: "idInventario = ?", whereArgs: [inventario.idInventario]);

  }
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
  //TODO FITLRADO ESTADO TIENDA, TIPO INVENTARIO
  Future<bool> filtrarInventarioporId(int idInventario) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> inventariosMap = await db.rawQuery('SELECT * FROM TStocksInventario WHERE identificador = ?', [idInventario]);
    return inventariosMap.isNotEmpty;
  }

  Future<int> obtenerUltimoId() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> resultado =
    await db.rawQuery('SELECT MAX(idInventario) as ultimoId FROM TStocksInventario');

    int ultimoId = resultado.first['ultimoId'] as int? ?? 0;
    return ultimoId + 1;
  }

  Future<List<TstocksDetallesInventario>> filtrarDetallesInventario() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> detallesMap = await db.query("TstocksDetallesInventario");
    return List.generate(detallesMap.length, (i) => TstocksDetallesInventario(
      linea: detallesMap[i]["linea"],
      idDetalle: detallesMap[i]["idDetalle"],
      idInventario: detallesMap[i]["idInventario"],
      idUnidadMedida: detallesMap[i]["idUnidadMedida"],
      descripcionUnidadMedida: detallesMap[i]["descripcionUnidadMedida"],
      idProducto: detallesMap[i]["idProducto"],
      descripcionProducto: detallesMap[i]["descripcionProducto"],
      idAlmacen: detallesMap[i]["idAlmacen"],
      almacenDescripcion: detallesMap[i]["almacenDescripcion"],
      idEmpaquetadoProducto: detallesMap[i]["idEmpaquetadoProducto"],
      empaquetadoDescripcion: detallesMap[i]["empaquetadoDescripcion"],
      idTipoDetalle: detallesMap[i]["idTipoDetalle"],
      descripcionTipoDetalle: detallesMap[i]["descripcionTipoDetalle"],
      cantidad: detallesMap[i]["cantidad"],
    ));
  }

  Future<int> obtenerUltimoIdDetalles() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> resultado =
    await db.rawQuery('SELECT MAX(linea) as ultimoId FROM TStocksDetallesInventario');

    int ultimoId = resultado.first['ultimoId'] as int? ?? 0;
    return ultimoId + 1;
  }

  Future<void> insertDetalles(TstocksDetallesInventario inventario) async {
    final db = await instance.database;

    await db.insert("TStocksDetallesInventario", inventario.toMap());

  }
  Future<void> deleteDetalles(TstocksDetallesInventario inventario) async {
    final db = await instance.database;

    await db.delete("TStocksDetallesInventario", where: "linea = ?", whereArgs: [inventario.linea]);

  }
  Future<void> updateDetalles(TstocksDetallesInventario inventario) async {
    final db = await instance.database;

    await db.update("TStocksDetallesInventario", inventario.toMap(), where: "linea = ?", whereArgs: [inventario.linea]);

  }
//TODO LIST FILTROS
// CATEGORIA -> BEBIDAS
// SUBCATEGORIA


}





