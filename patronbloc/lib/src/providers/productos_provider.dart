import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:patronbloc/src/Preferences/preferences_users.dart';
import 'package:patronbloc/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

class ProductsProvider {
//Peticiones Http
  final String _urlFirebase =
      'flutterdev-ba32a-default-rtdb.firebaseio.com'; //Base de datos en FireBase

  final String _uploadPreset = '';
  final String _cloudName = '';

  final _prefs =
      new PreferencesUsers(); //Singleton, siempre será la misma instancia.

//Insertar Productos.
  Future<bool> createProduct(ProductModel product) async {
    final _uriS =
        Uri.https(_urlFirebase, 'productos.json?auth=${_prefs.token}');

    http.Response response = await http.post(_uriS,
        //headers: {"Content-Type": "application/json"},
        body: productModelToJson(product)); //retorna un future

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final _uriS =
        Uri.https(_urlFirebase, 'productos.json', {'auth': _prefs.token});

    print('loadProducts - _uriS : $_uriS');

    http.Response response = await http.get(_uriS); //retorna un future

    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<ProductModel> products = [];

    if (decodedData.isEmpty)
      return []; //Validación de la información de la respuesta.

    print('decodedData      : ${decodedData.length}');

    decodedData.forEach((id, prodd) {
      print('id      : $id');
      print('prodd : $prodd');

      final prodTmp = ProductModel.fromJson(
          prodd); //convierte el json en un objeto de tipo ProductModel

      prodTmp.id = id; //Id que retorna FireBase.

      print('prodTmp : $prodTmp');

      products.add(prodTmp); //Se agrega el producto al List<ProductModel>

      print('products : $products');
      print('products : ${products.length}');
    });

    print('products : $products');

    return products;
  }

  Future<int> deleteProducts(String? idProduct) async {
    //Eliminar Producto.
    final _uriS = Uri.https(
        _urlFirebase, '/productos/$idProduct.json', {'auth': _prefs.token});
    //print(_uriS);

    http.Response response = await http.delete(_uriS); //retorna un future

    print(json.decode(response.body));

    return 1;
  }

  Future<bool> editProduct(ProductModel product) async {
    final _uriS = Uri.https(
        _urlFirebase, '/productos/${product.id}.json', {'auth': _prefs.token});

    http.Response response = await http.put(_uriS,
        //headers: {"Content-Type": "application/json"},
        body: productModelToJson(product)); //retorna un future

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<String> upLoadImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload?upload_preset=$_uploadPreset');
    final mimeType =
        mime(imagen.path)!.split('/'); //identificar el tipo de image/jpeg

    final imageUploadRequest = http.MultipartRequest('POST', url); //Request

    final file = await http.MultipartFile.fromPath(
      'file', imagen.path, //Adjuntar la imagen al request
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);

    final streamResponse =
        await imageUploadRequest.send(); //Ejecuta la petición.
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return ''; //Se retorna Vacio.
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url']; //retorna la url de la imagenx
  }
}
