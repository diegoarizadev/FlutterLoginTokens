import 'dart:io';

import 'package:patronbloc/src/models/product_model.dart';
import 'package:patronbloc/src/providers/productos_provider.dart';
import 'package:rxdart/subjects.dart';

class ProductsBloc {
  //Stream para cargar informacion
  final _productosController =
      new BehaviorSubject<List<ProductModel>>(); //Rxdart

  //Stream para subiendo informacion
  final _productosLoadController = new BehaviorSubject<bool>(); //Rxdart

  //Referencias
  final _productosProvider = new ProductsProvider();

  //Escuchar Streams.
  Stream<List<ProductModel>> get productsStream => _productosController;
  Stream<bool> get productsLoadStream => _productosLoadController;

  //Implementacion de metodos para insertar la información al Stream.

  void loadProducts() async {
    //async por que el metodo _productosProvider.loadProducts() retorna un future.
    final products =
        await _productosProvider.loadProducts(); //Retorna un future
    _productosController.sink.add(products); //Insertar los productos al Stream
  }

  void addProduct(ProductModel product) async {
    _productosLoadController.sink
        .add(true); //notifica que se esta cargando un producto
    await _productosProvider
        .createProduct(product); //Esperar a que agrege el producto.
    //Notificacion de la carga del producto.
    _productosLoadController.sink
        .add(false); //notifica que ya NO se esta cargando un producto
  }

  Future<String> loadPhoto(File photo) async {
    _productosLoadController.sink
        .add(true); //notifica que se esta cargando un producto
    final photoUrl = await _productosProvider.upLoadImagen(photo);
    //Notificacion de la carga del producto.
    _productosLoadController.sink
        .add(false); //notifica que ya NO se esta cargando un producto
    return photoUrl;
  }

  void editProduct(ProductModel product) async {
    _productosLoadController.sink
        .add(true); //notifica que se esta cargando un producto
    await _productosProvider
        .editProduct(product); //Esperar a que agrege el producto.
    //Notificacion de la carga del producto.
    _productosLoadController.sink
        .add(false); //notifica que ya NO se esta cargando un producto
  }

  void deleteProduct(String id) async {
    await _productosProvider.deleteProducts(id);
  }

  dispose() {
    _productosLoadController
        .close(); // el ? dice : si _productosLoadController existe, cerrar.
    _productosController.close();
  }
}
