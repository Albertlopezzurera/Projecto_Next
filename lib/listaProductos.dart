import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projectobueno/TstocksDetallesInventario.dart';
import 'package:projectobueno/TstocksInventarios.dart';
import 'package:projectobueno/User.dart';
import 'package:projectobueno/cameraQR.dart';
import 'package:projectobueno/filtrosProductos.dart';
import 'package:projectobueno/myapp.dart';
import 'package:projectobueno/newInventario.dart';
import 'package:projectobueno/paginaPrincipal.dart';

import 'llamadaApi.dart';

const List<String> opcionOrdenacion = ['ASC', 'DESC'];
const List<String> criteriosOrdenacion = [
  'Codigo',
  'Descripción',
  'Categoria',
  'Categoria/Subcategoria',
  'Tipo de conservación'
];

class ListaProductos extends StatefulWidget {
  final User usuario; // Agregar esta línea
  final TstocksInventarios inventarioexistente;
  ListaProductos(this.usuario, this.inventarioexistente);
  final String title = 'LISTA INVENTARIOS';
  @override
  _ListaProductosState createState() => _ListaProductosState();
}

class _ListaProductosState extends State<ListaProductos> {
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String itemSelecionadoCriterio = criteriosOrdenacion.first;
  String itemSelecionadoOpcionOrdenacion = opcionOrdenacion.first;


  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQueryController.clear();
    });
  }

  AppBar buildAppBar(BuildContext context) {

    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _stopSearch,
        ),
        title: TextField(
          controller: _searchQueryController,
          decoration: InputDecoration(
            hintText: "Buscar...",
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print(_searchQueryController.text);
            },
          ),
        ],
      );
    } else {
      return AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _startSearch,
          ),
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: _showFiltrosDialog,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LISTA PRODUCTOS');
    print(widget.inventarioexistente);
    filtrosProductos;
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: Drawer(
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  alignment: Alignment.centerLeft,
                  width: 70,
                  height: 70,
                ),
                SizedBox(width: 8), // Espacio entre el logo y el texto
                Expanded(
                  child: Text(
                    'NEXTT.DIRECTOR APP',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(usuario.nombre),
                Text(usuario.dominio),
                SizedBox(
                  height: 60,
                )
              ],
            ),
            // Resto del código...
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => newInventario(usuario)),
                );
              },
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => newInventario(usuario)),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text('Nuevo inventario'),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => paginaPrincipal(usuario)),
                );
              },
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.library_books),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => paginaPrincipal(usuario)),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  // Agrega un espacio entre el icono y el texto
                  Text('Lista de inventarios'),
                ],
              ),
            ),
            InkWell(
              splashColor: Colors.grey,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('ATENCIÓN!'),
                      content: Text("Está seguro que quiere cerrar la sesión?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text("Sí"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  // Agrega un espacio entre el icono y el texto
                  Text('Cerrar sesión'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        //TODO PAGINA PRINCIPAL PARA HACER PRODUCTOS
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: widget.inventarioexistente.detallesInventario == null || widget.inventarioexistente.detallesInventario!.isEmpty
                        ? Container() // Contenedor vacío si detallesInventario es null o está vacío
                        : TargetasProducto(widget.inventarioexistente),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        spacing: 3.0, // Espacio horizontal entre los botones
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: Text("ATENCIÓN!"),
                      content: Text(
                          "Se han realizado cambios que no han sido guardados, si sale sin guardar se perderán. \n Desea salir sin guardar los cambios?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text("Sí"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              //GUARDAR INVENTARIO COMO CERRADO
                              MaterialPageRoute(
                                  builder: (context) =>
                                      paginaPrincipal(usuario)),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                // Acción del segundo botón flotante
                Navigator.push(
                  context,
                  //GUARDAR INVENTARIO COMO CERRADO
                  MaterialPageRoute(
                      builder: (context) => paginaPrincipal(usuario)),
                ); //TODO VALIDACIONES
              },
              child: Icon(Icons.save),
              backgroundColor: Colors.greenAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: Text("ATENCIÓN!"),
                      content: Text(
                          "Si cierra el inventario no podrá modificarlo \n Desea guardar y cerrar el inventario?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text("Sí"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              //GUARDAR INVENTARIO COMO CERRADO
                              MaterialPageRoute(
                                  builder: (context) =>
                                      paginaPrincipal(usuario)),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.save_as_outlined),
              backgroundColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                // Acción del segundo botón flotante
              },
              child: Icon(Icons.add_box_outlined),
              backgroundColor: Colors.orange,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 3.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                // Acción del segundo botón flotante
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraQR(widget.usuario,widget.inventarioexistente)),
                );
              },
              child: Icon(Icons.camera_alt),
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  Widget generarEstructuraProductos(TstocksInventarios inventarioexistente) {
    List<TstocksDetallesInventario>? listaProductos = inventarioexistente.detallesInventario;

    return ListView.builder(
      itemCount: listaProductos!.length,
      itemBuilder: (context, index) {
        var cantidad = listaProductos[index].cantidad.toString();
        var producto = listaProductos[index].descripcionProducto;
        var descripcionEmpaquet = listaProductos[index].empaquetadoDescripcion;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.orange,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center, // Alineación central
                            child: Text(
                              listaProductos[index].descripcionProducto,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_a_photo),
                                onPressed: () {
                                  // Acción al presionar el IconButton
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(cantidad + ' ' + listaProductos[index].empaquetadoDescripcion),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        buildCounterRow(listaProductos,index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildCounterRow(List<TstocksDetallesInventario> listaProductos, int index) {
    var number = listaProductos[index].cantidad;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: null,
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.horizontal_rule),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.all(4),
          child: Text('$number'),
        ),
        IconButton(
          onPressed: null,
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_circle),
          ),
        ),
        Container(
          child: Text(listaProductos[index].empaquetadoDescripcion),
        ),
      ],
    );
  }

  Future<void> _showFiltrosDialog() async {
    final productosJson = await API.getFiltrosProductos(usuario);
    final productos = filtrosProductos.fromJson(productosJson);
    final categoriaSet = productos.json
        .map((e) => e['idCategoriaEstadisticas_nombre']['descripcion'])
        .toSet();
    final categoriaList = categoriaSet.toList();
    final subCategoriaMap =
        productos.json.fold<Map<String, String>>({}, (map, e) {
      final descripcionCategoria =
          e['idCategoriaEstadisticas_nombre']['descripcion'];
      final pathCompleto =
          e['idCategoriaEstadisticas_pathCompleto']['descripcion'];
      return {...map, descripcionCategoria: pathCompleto};
    });
    final tipoConservacionList = productos.json
        .where((e) =>
            e.containsKey('idImpresoraCocina_descripcion') &&
            e['idImpresoraCocina_descripcion'] != null)
        .map<String>((e) => e['idImpresoraCocina_descripcion']['descripcion'])
        .toSet()
        .toList();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final List<CheckboxListTileOption> opciones = categoriaList
              .map((categoria) => CheckboxListTileOption(title: categoria))
              .toList();
          final List<CheckboxListTileOption> subCategoriasOpciones =
              subCategoriaMap
                  .entries
                  .map((entry) => CheckboxListTileOption(
                      title: entry.key + " / " + entry.value))
                  .toList();
          final List<CheckboxListTileOption> conservacionOpciones =
              tipoConservacionList
                  .map((conservacion) =>
                      CheckboxListTileOption(title: conservacion))
                  .toList();
          return AlertDialog(
            insetPadding: EdgeInsets.all(5),
            contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            title: Text('Filtros'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  buildListTile('Categorias'),
                  ...opciones,
                  Divider(),
                  buildListTile('Subcategorias'),
                  ...subCategoriasOpciones,
                  Divider(),
                  buildListTile('Tipos de conservacion'),
                  ...conservacionOpciones,
                  Divider(),
                  buildListTile('Criterios de ordenación'),
                  Wrap(spacing: 16.0, children: [
                    MyOrderListTile(
                      title: '1er',
                      criterios: criteriosOrdenacion,
                      ordenacion: opcionOrdenacion,
                      onCriterioSelected: (int selectedCriterioIndex) {
                        // código a ejecutar cuando se seleccione un criterio
                      },
                      onOrdenacionSelected: (int selectedOrdenacionIndex) {
                        // código a ejecutar cuando se seleccione un criterio
                      },
                    ),
                    MyOrderListTile(
                      title: '2o',
                      criterios: criteriosOrdenacion,
                      ordenacion: opcionOrdenacion,
                      onCriterioSelected: (int selectedCriterioIndex) {
                        // código a ejecutar cuando se seleccione un criterio
                      },
                      onOrdenacionSelected: (int selectedOrdenacionIndex) {
                        // código a ejecutar cuando se seleccione un criterio
                      },
                    ),
                    MyOrderListTile(
                      title: '3er',
                      criterios: criteriosOrdenacion,
                      ordenacion: opcionOrdenacion,
                      onCriterioSelected: (int selectedCriterioIndex) {
                        // código a ejecutar cuando se seleccione un criterio
                      },
                      onOrdenacionSelected: (int selectedOrdenacionIndex) {
                        // código a ejecutar cuando se seleccione una ordenación
                      },
                    ),
                  ]),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.check),
                color: Colors.green,
                alignment: Alignment.bottomRight,
                iconSize: 50.0,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close),
                color: Colors.red,
                alignment: Alignment.bottomLeft,
                iconSize: 50.0,
              ),
            ],
          );
        });
  }
}

class CheckboxListTileOption extends StatefulWidget {
  final String title;

  CheckboxListTileOption({required this.title});

  @override
  State<StatefulWidget> createState() => _CheckboxListTileOptionState();
}

class _CheckboxListTileOptionState extends State<CheckboxListTileOption> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

class MyOrderListTile extends StatefulWidget {
  final String title;
  final List<String> criterios;
  final List<String> ordenacion;
  final Function(int) onCriterioSelected;
  final Function(int) onOrdenacionSelected;

  const MyOrderListTile({
    required this.title,
    required this.criterios,
    required this.ordenacion,
    required this.onCriterioSelected,
    required this.onOrdenacionSelected,
  });

  @override
  _MyOrderListTileState createState() => _MyOrderListTileState();
}

class _MyOrderListTileState extends State<MyOrderListTile> {
  int _selectedCriterioIndex = 0;
  int _selectedOrdenacionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              isExpanded: true,
              items: widget.criterios
                  .map((criterio) => DropdownMenuItem<String>(
                value: criterio,
                child: Text(criterio),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCriterioIndex = widget.criterios.indexOf(newValue!);
                });
                widget.onCriterioSelected(_selectedCriterioIndex);
              },
              value: widget.criterios[_selectedCriterioIndex],
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: DropdownButton<String>(
              isExpanded: true,
              items: widget.ordenacion
                  .map((ordenacion) => DropdownMenuItem<String>(
                value: ordenacion,
                child: Text(ordenacion),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOrdenacionIndex = widget.ordenacion.indexOf(newValue!);
                });
                widget.onOrdenacionSelected(_selectedOrdenacionIndex);
              },
              value: widget.ordenacion[_selectedOrdenacionIndex],
            ),
          ),
        ],
      ),
    );
  }




}



//Funcion para devolver el titulo de filtros
ListTile buildListTile(String title) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    tileColor: Colors.grey[200],
  );
}

class TargetasProducto extends StatefulWidget {
  final TstocksInventarios inventarioexistente;
  TargetasProducto(this.inventarioexistente);

  @override
  _TargetaProducto createState() => _TargetaProducto();
}

class _TargetaProducto extends State<TargetasProducto> {
  bool mostrarTarjetaPrincipal = true; // Estado para alternar entre las tarjetas
  int selectedIndex = 0; // Índice seleccionado

  @override
  Widget build(BuildContext context) {
    List<TstocksDetallesInventario>? listaProductos =
        widget.inventarioexistente.detallesInventario;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: mostrarTarjetaPrincipal
                ? generarEstructuraProductos(widget.inventarioexistente)
                : buildCounterRow(listaProductos, selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget buildCounterRow(
      List<TstocksDetallesInventario>? listaProductos, int index) {
    if (listaProductos == null || index >= listaProductos.length) {
      return Container();
    }
    var number = listaProductos[index].cantidad;
    return Container(
      width: double.infinity, // Ancho máximo
      child: Card(
        color: Colors.cyan,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(listaProductos[index].descripcionProducto),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          mostrarTarjetaPrincipal = true;
                          selectedIndex = index;
                        });
                      },
                      icon: Icon(Icons.minimize),
                    ),
                  ),
                ],
              ),
              Text(
                  '${listaProductos[index].idProducto} ${listaProductos[index].categoriaprincipalDescripcion} ${listaProductos[index].subcategoriaDescripcion}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // Acción al presionar el IconButton de restar
                        if (number > 0) {
                          number--;
                        }
                      });
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.horizontal_rule),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Text('$number'),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // Acción al presionar el IconButton de sumar
                        number++;
                      });
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add_circle),
                    ),
                  ),
                  Container(
                    child: Text(listaProductos[index].empaquetadoDescripcion),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget generarEstructuraProductos(TstocksInventarios inventarioexistente) {
    List<TstocksDetallesInventario>? listaProductos =
        inventarioexistente.detallesInventario;

    return ListView.builder(
      itemCount: listaProductos!.length,
      itemBuilder: (context, index) {
        var cantidad = listaProductos[index].cantidad.toString();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.orange,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              listaProductos[index].descripcionProducto,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_a_photo),
                                onPressed: () {
                                  // Acción al presionar el IconButton
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      cantidad +
                                          ' ' +
                                          listaProductos[index]
                                              .empaquetadoDescripcion,
                                      style: TextStyle(
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          mostrarTarjetaPrincipal = false;
                          selectedIndex = index;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

