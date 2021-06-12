import 'dart:io';

import 'package:flutter/material.dart';
import 'package:patronbloc/src/models/product_model.dart';
import 'package:patronbloc/src/providers/productos_provider.dart';
import 'package:patronbloc/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  //const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  ProductModel product = new ProductModel();
  final productProvider = new ProductsProvider();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _save = false;
  File photo = File(''); //Inicialización.
  @override
  Widget build(BuildContext context) {
    final prodData =
        ModalRoute.of(context)!.settings.arguments; //se captura el argumento.

    if (prodData != null) {
      product = prodData as ProductModel; //Se reinicializa el product.
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            onPressed: _selectedPhoto,
            icon: Icon(Icons.photo_size_select_actual),
          ),
          IconButton(
            onPressed: _capturePhoto,
            icon: Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _seePhoto(),
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton(product),
              ],
            ),
          ), //Parecido a un formulario HTML pero es un Container
        ),
      ),
    );
  }

  _createName() {
    return TextFormField(
      initialValue: product.titulo, //Valor inicial
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre del Producto',
      ),
      onSaved: (value) => product.titulo =
          value!, //Se ejecuta despues de validado el campo y asigna el valor al modelo
      validator: (value) {
        //Se debe retornar un error, en casso de no existir un error se retorna null
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto'; //Este es el error.
        } else {
          return null;
        }
      },
    );
  }

  _createPrice() {
    return TextFormField(
      initialValue: product.valor
          .toString(), //Valor inicial, se muestra el valor que tiene actualmente es el modelo.
      keyboardType: TextInputType.numberWithOptions(
          decimal:
              true), //Tipo de teclado numerico y habilite el decimal o punto en el teclado.
      decoration: InputDecoration(
        labelText: 'Valor',
      ),
      onSaved: (value) => product.valor = int.parse(
          value!), //Se ejecuta despues de validado el campo y asigna el valor al modelo
      validator: (value) {
        //Se debe retornar un error, en casso de no existir un error se retorna null
        if (utils.isNumeric(value!)) {
          return null; // es un mnumero
        } else {
          return 'Sólo, números!';
        }
      },
    );
  }

  _createButton(ProductModel dataProd) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: (_save) ? null : _sudmit,
      icon: Icon(Icons.save),
      label: dataProd.id.isNotEmpty ? Text('Editar') : Text('Guardar'),
    );
  }

  void _sudmit() async {
    print('_sudmit');

    if (!formKey.currentState!.validate())
      return; //si el formulario no es valido

    formKey.currentState!
        .save(); //instrucciones para ejeucar el OnSave de Widgets, se ejecuta despues de las validaciones.

    setState(() {
      _save = true;
    });

    if (photo != null) {
      product.fotoUrl =
          await productProvider.upLoadImagen(photo); //Cargar imagen en la nube
    }

    if (product.id.isEmpty) {
      productProvider.createProduct(product);
      seeSnackbar('Registro guardado 😃');
    } else {
      productProvider.editProduct(product);
      seeSnackbar('Registro actualizado 👍🏻');
    }

    Navigator.pop(context); //Retorna a la pantalla anterior.

    //formKey.currentState!.validate(); //Si el formulario es valido retorna un true, de los contrario un false
  }

  _createAvailable() {
    return SwitchListTile(
      value: product.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        product.disponible = value;
      }),
    );
  }

  void seeSnackbar(String message) {
    final snack = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  _selectedPhoto() async {
    _processImage(ImageSource.gallery);
  }

  void _capturePhoto() async {
    _processImage(ImageSource.camera);
  }

  _seePhoto() {
    print('product.fotoUrl : ${product.fotoUrl}');
    print('photo.path: ${photo.path}');

    if (product.fotoUrl.isEmpty && photo.path.isEmpty) {
      print('product.fotoUrl.isEmpty');
      return Image(
        image: AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else if (photo.path.isNotEmpty) {
      print('photo.path.isNotEmpty');

      return Image(
        image: AssetImage(photo.path),
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else {
      print('!!product.fotoUrl.isNotEmpty');
      return FadeInImage(
        image: NetworkImage(product.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    }
  }

  _processImage(ImageSource origen) async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: origen);
    print('pickedFile: ${pickedFile!.path}');
    setState(() {
      if (pickedFile != null) {
        photo = File(pickedFile.path);
        product.fotoUrl = pickedFile.path;
      }
    });
  }
}
