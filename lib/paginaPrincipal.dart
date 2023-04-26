
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectobueno/myapp.dart';
import 'package:projectobueno/newInventario.dart';

class paginaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVENTARIO SUPERMERCADO',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: PageHome(title: 'LISTA DE INVENTARIOS'),
    );
  }
}

class PageHome extends StatefulWidget {
  final String title;
  PageHome({required this.title});

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  var _valoresTipoInventario;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Inventarios'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_box_outlined), onPressed: () {
            filtros(context);
          },),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => newInventario()),
          );
          // Agrega la acción que deseas ejecutar cuando se presiona el botón
          print('Se presionó el botón');
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Text('Buscar Lista Inventarios')),
            GestureDetector(
              onTap: () {
                print('Nuevo inventario');
              },
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => newInventario()),
                      );
                    },
                  ),
                  const SizedBox(width: 8), // Agrega un espacio entre el icono y el texto
                  Text('Nuevo inventario'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Lista de inventarios');
              },
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.library_books),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8), // Agrega un espacio entre el icono y el texto
                  Text('Lista de inventarios'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Cerrar sesion');
              },
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                  ),
                  const SizedBox(width: 8), // Agrega un espacio entre el icono y el texto
                  Text('Cerrar sesion'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void filtros(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      //si en vez de mostrar el aviso en la pantalla se quiere abajo return BottomSheet
      return AlertDialog(
        title: Text('Filtros'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var _valoresTipoInventario = '';
            var _tienda = '';
            var _estado = '';
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Seleccione un filtro:'),
                ListTile(
                  title: Text('TIENDA'),
                  onTap: () {
                    // Lógica para aplicar Filtro 1
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Filtro 1'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Seleccione un tipo de inventario:'),
                              RadioListTile(
                                title: Text('Tienda 1'),
                                value: 'total',
                                groupValue: _tienda,
                                onChanged: (value) {
                                  setState(() {
                                    _tienda = value!;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text('Tienda 2'),
                                value: 'parcial',
                                groupValue: _tienda,
                                onChanged: (value) {
                                  setState(() {
                                    _tienda = value!;
                                  });
                                },
                              ),
                              ElevatedButton(
                                child: Text('Aplicar filtro'),
                                onPressed: () {
                                  // Lógica para aplicar el filtro
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text('TIPO DE INVENTARIO'),
                  onTap: () {
                    // Lógica para aplicar Filtro 2
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Filtro 2'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Seleccione un tipo de inventario:'),
                              RadioListTile(
                                title: Text('Total'),
                                value: 'total',
                                groupValue: _valoresTipoInventario,
                                onChanged: (value) {
                                  setState(() {
                                    _valoresTipoInventario = value!;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text('Parcial'),
                                value: 'parcial',
                                groupValue: _valoresTipoInventario,
                                onChanged: (value) {
                                  setState(() {
                                    _valoresTipoInventario = value!;
                                  });
                                },
                              ),
                              ElevatedButton(
                                child: Text('Aplicar filtro'),
                                onPressed: () {
                                  // Lógica para aplicar el filtro
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text('ESTADO'),
                  onTap: () {
                    // Lógica para aplicar Filtro 3
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Filtro 3'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Seleccione un tipo de inventario:'),
                              RadioListTile(
                                title: Text('Abierto'),
                                value: 'total',
                                groupValue: _estado,
                                onChanged: (value) {
                                  setState(() {
                                    _estado = value!;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text('Cerrado'),
                                value: 'parcial',
                                groupValue: _estado,
                                onChanged: (value) {
                                  setState(() {
                                    _estado = value!;
                                  });
                                },
                              ),
                              ElevatedButton(
                                child: Text('Aplicar filtro'),
                                onPressed: () {
                                  // Lógica para aplicar el filtro
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

