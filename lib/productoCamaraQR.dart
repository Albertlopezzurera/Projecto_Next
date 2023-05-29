class productoCamaraQR{
  final List<String> productoEscaneado;
  productoCamaraQR({required this.productoEscaneado});

  factory productoCamaraQR.fromJson(List<dynamic> jsonList, String result) {
    List<String> productoEscaneado = [];
    for (int i = 0; i < jsonList.length; i++) {
      Map<String, dynamic> mapa = jsonList[i];
      String nombre = mapa['nombre'];
      String ean = mapa['ean13jan'].toString();
      String codigoProducto = mapa['codigo'];
      String categoriaPrincipal = mapa['idCategoriaEstadisticas_pathCompleto']['descripcion'];
      String categoriaSecundaria = mapa['idCategoriaEstadisticas_nombre']['descripcion'];
      //String imagen = mapa['idGrupoImagenes_imagenes']['fichero'];
      if (mapa['ean13jan'] == result) {
        // Agregar elementos a la lista solo cuando se cumple la condición
        productoEscaneado.add(nombre);
        productoEscaneado.add(ean);
        productoEscaneado.add(codigoProducto.toString());
        productoEscaneado.add(categoriaPrincipal);
        productoEscaneado.add(categoriaSecundaria);
        List<dynamic> imagenes = mapa['idGrupoImagenes_imagenes'];
        if (imagenes.isNotEmpty) {
          String primerFicheroUid = imagenes[0]['ficheroUid'];
          productoEscaneado.add(primerFicheroUid);
        } else {
          // Agregar un valor por defecto o un marcador para indicar que no hay imágenes
          productoEscaneado.add('No hay imágenes');
        }


      }
    }
    return productoCamaraQR(productoEscaneado: productoEscaneado);
  }

}