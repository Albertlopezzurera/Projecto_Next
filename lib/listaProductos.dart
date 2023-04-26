import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projectobueno/newInventario.dart';

const List<String> categorias = ['Bebidas', 'Carnes', 'Limpieza'];
const List<String> subcategorias = ['Bebidas/Refrescos','Bebidas/Cafeterias', 'Bebidas/Licores'];
const List<String> tiposConservacion = ['Congelados', 'Refrigerados', 'Ambiente'];
const List<String> opcionOrdenacion = ['ASC', 'DESC'];
const List<String> criteriosOrdenacion = ['Codigo','Descripción','Categoria','Categoria/Subcategoria','Tipo de conservación'];
List<bool> categoriasChecked = List.generate(
  categorias.length,
      (index) => false,
);

class ListaProductos extends StatefulWidget {
  final String title;
  ListaProductos({required this.title});
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
            onPressed: () {
              buildFiltros(context);
            },
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
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
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  // Agrega un espacio entre el icono y el texto
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
                  const SizedBox(width: 8),
                  // Agrega un espacio entre el icono y el texto
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
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  // Agrega un espacio entre el icono y el texto
                  Text('Cerrar sesion'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text("Contenido de la lista de productos"),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  print("Agregar nuevo producto");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buildFiltros(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Lista de Inventarios'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Categorias')),
                ),
                CheckboxListTileOption(title: 'Opción 1'),
                CheckboxListTileOption(title: 'Opción 2'),
                CheckboxListTileOption(title: 'Opción 3'),
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Subcategorias')),
                ),
                CheckboxListTileOption(title: 'Opción 1'),
                CheckboxListTileOption(title: 'Opción 2'),
                CheckboxListTileOption(title: 'Opción 3'),
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Tipos de conservacion')),
                ),
                CheckboxListTileOption(title: 'Opción 1'),
                CheckboxListTileOption(title: 'Opción 2'),
                CheckboxListTileOption(title: 'Opción 3'),
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Criterios de ordenación')),
                ),
                //ACABAR DROPDOWNBUTTON
              ],
            ),
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () {
                          // Acción del primer botón
                        },
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                      SizedBox(width: 16.0),
                      FloatingActionButton(
                        onPressed: () {
                          // Acción del segundo botón
                        },
                        child: Icon(Icons.check),
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: null,
          ),
        );
      },
    );
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
