import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectobueno/listaProductos.dart';
import 'package:projectobueno/paginaPrincipal.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

const List<String> inventoryType = <String>['Total', 'Parcial'];

class newInventario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVENTARIO SUPERMERCADO',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: newInvPass(title: 'Nuevo Inventario'),
    );
  }
}

class newInvPass extends StatefulWidget {
  final String title;

  newInvPass({required this.title});

  @override
  _NuevoInventarioState createState() => _NuevoInventarioState();
}

class _NuevoInventarioState extends State<newInvPass> {
  String dropdownValue = list.first;
  String dropdowntypeinv = inventoryType.first;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Inventario'),
      ),
      resizeToAvoidBottomInset: false, //Impide que se adapte al teclado
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "Descripcion del Inventario",
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: dropdownValue,
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
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: dropdownValue,
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
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
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
              items: inventoryType.map<DropdownMenuItem<String>>((String value) {
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
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                  decoration: InputDecoration(
                    hintText: "Fecha del Inventario",
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
              onPressed: () {
                // Acción del primer botón flotante
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => paginaPrincipal()),
                );
              },
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                // Acción del segundo botón flotante
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaProductos(title: 'Lista Productos')),
                );
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