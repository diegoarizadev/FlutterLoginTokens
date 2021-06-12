import 'package:flutter/material.dart';
import 'package:patronbloc/src/models/product_model.dart';
import 'package:patronbloc/src/providers/productos_provider.dart';
//import 'package:patronbloc/src/bloc/provider.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productoProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    //final bloc = ProviderInheritedWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _createListProduct(),
      floatingActionButton: _createButton(context),
    );
  }

  _createButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(
        context,
        'product',
      ).then((value) => {setState(() {})}),
      child: Icon(Icons.add),
      backgroundColor: Colors.purple,
    );
  }

  _createListProduct() {
    return FutureBuilder(
      future: productoProvider.loadProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          //Se valida si hay información

          final products = snapshot.data;

          return ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, i) => _createItemProduct(
                products[i], context), //Se envia una instancia de ProductModel
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createItemProduct(ProductModel product, BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          productoProvider.deleteProducts(product.id);
        },
        child: Card(
          child: Column(
            children: [
              (product.fotoUrl == '')
                  ? Image(
                      image: AssetImage('assets/no-image.png'),
                    )
                  : FadeInImage(
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(product.fotoUrl),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${product.titulo} - ${product.valor}'),
                subtitle: Text(product.id),
                onTap: () => Navigator.pushNamed(
                  context,
                  'product',
                  arguments: product, //Se envia el producto como argumento.
                ).then((value) => {setState(() {})}),
              ),
            ],
          ),
        ));
  }
}
