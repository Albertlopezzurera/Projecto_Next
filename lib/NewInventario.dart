import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectobueno/TstocksDetallesInventario.dart';
import 'package:projectobueno/TstocksInventarios.dart';
import 'package:projectobueno/User.dart';
import 'package:projectobueno/ListaProductos.dart';
import 'package:projectobueno/Myapp.dart';
import 'package:projectobueno/PaginaPrincipal.dart';
import 'DatabaseHelper.dart';

/// Clase new inventario contiene un formulario para la creacion de un nuevo inventario
///
/// [usuario] -> [User] contiene los datos del usuario
class newInventario extends StatelessWidget {
  newInventario(User usuario);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVENTARIO SUPERMERCADO',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: newInvPass(title: 'NUEVO INVENTARIO'),
    );
  }
}

class newInvPass extends StatefulWidget {
  final String title;

  newInvPass({required this.title});

  @override
  _NuevoInventarioState createState() => _NuevoInventarioState();
}

/// Class _NuevoInventarioState que extiende de newInvPass
///
/// [_listadeAlmacenes] -> Lista descripcion de Almacenes
/// [_listadeTiendas] -> "" "" "" Tiendas
/// [_listaInvType] -> "" "" "" Tipos de inventario
/// [_listadeTiendasID] -> lista ID de la tienda
/// [_listadeAlmacenesID] -> "" "" "" "" Almacenes
/// [_listaInvTypeID] -> "" "" "" "" Tipo de inventario
class _NuevoInventarioState extends State<newInvPass> {
  String dropdowntypeinv = "";
  String dropdowntypealm = "";
  String dropdowntypetienda = "";
  TextEditingController _descripcionInvController = new TextEditingController();
  String descripcionInventario = "";

  List<String> _listadeAlmacenes = [];
  List<int> _listadeAlmacenesID = [];
  List<String> _listadeTiendas = [];
  List<int> _listadeTiendasID = [];
  List<String> _listaInvType = [];
  List<int> _listaInvTypeID = [];

  DateTime? _selectedDate;

  /// Funcion que se encarga de mostrar y manejar el campo de la fecha y hora.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        int hour = pickedTime.hour;
        if (pickedTime.period == DayPeriod.pm && hour < 12) {
          hour += 12;
        } else if (pickedTime.period == DayPeriod.am && hour == 12) {
          hour = 0;
        }
        final DateTime picked = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          hour,
          pickedTime.minute,
        );
        if (picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      }
    }
  }

  /// Encuentra el índice de un valor en una lista.
  ///
  /// [valorBuscado]: El valor a buscar.
  /// [lista]: La lista en la que se buscará el valor.
  /// Devuelve el índice del valor en la lista, o -1 si no se encuentra.
  int encontrarIndice(String valorBuscado, List<String> lista) {
    for (int i = 0; i < lista.length; i++) {
      if (lista[i] == valorBuscado) {
        return i;
      }
    }
    return -1; // Retorna -1 si no se encuentra el valor en la lista
  }

  /// Funciona cuando se inicia una vez arranca la actividad
  /// Se encarga de traer los datos de la API a los campos correspondientes
  /// [getDataAlmacen] obtiene los datos de los almacenes
  /// [getDataAlmacen] obtiene los datos de los almacenes
  /// [getDataTipoInv] obtiene los tipos de inventario de las tiendas
  @override
  void initState() {
    super.initState();
    getDataTienda(usuario);
    getDataAlmacen(usuario);
    getDataTipoInv(usuario);
  }

  /// Obtiene los datos de las tiendas.
  ///
  /// [usuario]  El objeto [User] actual.
  /// [response] -> Contiene la llamada a la API para que recoga las tiendas
  /// [data] -> contiene en json la lista de tiendas
  ///
  /// en el for se le añade la descripcion y la id en sus respectivas listas
  Future<void> getDataTienda(User usuario) async {
    var token = usuario.token;
    final response = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/tiendas"),
      headers: {"Authorization": "Bearer $token"},
    );

    var data = jsonDecode(response.body);
    _listadeTiendas.clear();
    _listadeTiendasID.clear();
    for (data in data) {
      if (!_listadeTiendas.contains(data["descripcion"])) {
        _listadeTiendas.add(data["descripcion"]);
        _listadeTiendasID.add(data["id"]);
      }
    }
    if (_listadeTiendas.isNotEmpty) {
      setState(() {
        dropdowntypetienda = _listadeTiendas.first;
      });
    }
  }
  /// Obtiene los datos de los almacenes
  ///
  /// [usuario]  El objeto [User] actual.
  /// [response] -> Contiene la llamada a la API para que recoga los almacenes
  /// [data] -> contiene en json la lista de almacenes
  ///
  /// en el for se le añade la descripcion y la id en sus respectivas listas
  Future<void> getDataAlmacen(User usuario) async {
    var token = usuario.token;
    final response = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/almacenes"),
      headers: {"Authorization": "Bearer $token"},
    );

    var data = jsonDecode(response.body);
    _listadeAlmacenes.clear();
    _listadeAlmacenesID.clear();
    for (data in data) {
      if (!_listadeAlmacenes.contains(data["descripcion"])) {
        _listadeAlmacenes.add(data["descripcion"]);
        _listadeAlmacenesID.add(data["id"]);
      }
    }
    if (_listadeAlmacenes.isNotEmpty) {
      setState(() {
        dropdowntypealm = _listadeAlmacenes.first;
      });
    }
  }

  /// Obtiene los datos de los tipos de inventario
  ///
  /// [usuario]  El objeto [User] actual.
  /// [response] -> Contiene la llamada a la API para que recoga los tipos de inventario
  /// [data] -> contiene en json la lista de los tipos de inventario
  ///
  /// en el for se le añade la descripcion y la id en sus respectivas listas
  Future<void> getDataTipoInv(User usuario) async {
    // Reemplaza esto con tu token Bearer
    var token = usuario.token;
    final response = await http.get(
      Uri.parse(
          "https://nextt1.pre-api.nexttdirector.net:8443/NexttDirector_NexttApi/tiposInventarios"),
      headers: {"Authorization": "Bearer $token"},
    );

    var data = jsonDecode(response.body);
    _listaInvType.clear();
    _listaInvTypeID.clear();
    for (data in data) {
      if (!_listaInvType.contains(data["descripcion"])) {
        _listaInvType.add(data["descripcion"]);
        _listaInvTypeID.add(data["id"]);
      }
    }
    if (_listaInvType.isNotEmpty) {
      setState(() {
        dropdowntypeinv = _listaInvType.first;
      });
    }
  }

  ///Interfaz para la creación de un nuevo inventario
  ///
  /// [FloatingActionButton] -> [heroTag] -> "btncancel"
  /// Regresa a la lista de inventarios.
  ///
  /// [FloatingActionButton] -> [heroTag] -> "btnok"
  /// Cuando se le de a crear inventario se comprueba si [descripcionInventario] no este vacio o sea nulo si este no lo esta
  /// comprueba que [_selectedDate] no sea nulo entonces pasara a crear una instancia de [TstocksInventarios] con los datos ingresados en el formulario
  /// luego se importa con [DatabaseHelper.instance] y se inserta el nuevo inventario y procede con [Navigator] a ir a la lista de productos
  /// pasandole el usuario [User] y el nuevo inventario creado [TstocksInventarios]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('NUEVO INVENTARIO'),
        ),
      ),
      resizeToAvoidBottomInset: false, //Impide que se adapte al teclado
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _descripcionInvController,
              decoration: InputDecoration(
                hintText: "Descripcion del Inventario",
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: dropdowntypetienda,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdowntypetienda = value!;
                });
              },
              items:
              _listadeTiendas.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: dropdowntypealm,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdowntypealm = value!;
                });
              },
              items: _listadeAlmacenes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: dropdowntypeinv,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdowntypeinv = value!;
                });
              },
              items:
              _listaInvType.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: IgnorePointer(
                child: TextField(
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? 'Seleccione una fecha'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} ${_selectedDate!.hour}:${_selectedDate!.minute.toString().padLeft(2, '0')!}',
                  ),
                  decoration: InputDecoration(
                    hintText: "Fecha y hora del Inventario",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: FloatingActionButton(
              heroTag: "btncancel",
              onPressed: () {
                // Acción del primer botón flotante
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => paginaPrincipal(usuario)),
                );
              },
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FloatingActionButton(
              heroTag: "btnok",
              onPressed: () async {
                // Acción del segundo botón flotante
                String descripcionInventario = _descripcionInvController.text;
                if (descripcionInventario != null && !descripcionInventario.isEmpty) {
                  if (_selectedDate != null) {

                    int indicetienda = encontrarIndice(dropdowntypetienda, _listadeTiendas);
                    int indicealmacen = encontrarIndice(dropdowntypealm, _listadeAlmacenes);
                    int indicetypeinv = encontrarIndice(dropdowntypeinv, _listaInvType);
                    int ultimoid = await DatabaseHelper.instance.obtenerUltimoId();
                    String? dateTimeString = _selectedDate.toString();
                    String? formattedDateTime = dateTimeString?.substring(0, dateTimeString.length - 7);
                    DateTime dateTime = DateTime.parse(formattedDateTime!);
                    String formattedDateTimeString = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

                    TstocksInventarios inventarioexistente = new TstocksInventarios(idInventario : ultimoid,identificador: null, idDominio: usuario.iddominio,
                        dominioDescripcion: usuario.dominio, descripcionInventario: descripcionInventario, idAlmacen: _listadeAlmacenesID[indicealmacen] as int,
                        almacenDescripcion: _listadeAlmacenes[indicealmacen], idTienda: _listadeTiendasID[indicetienda] as int,
                        tiendaDescripcion: _listadeTiendas[indicetienda], fechaRealizacionInventario: formattedDateTimeString,
                        idTipoInventario: _listaInvTypeID[indicetypeinv] as int, tipoInventarioDescripcion: _listaInvType[indicetypeinv], idEstadoInventario: 1
                        , estadoInventario: "ABIERTO", detallesInventario: <TstocksDetallesInventario>[]
                    );
                    DatabaseHelper.instance.insert(inventarioexistente);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ListaProductos(usuario, inventarioexistente),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('La fecha es nula'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('La descripción es nula'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Icon(Icons.check),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

