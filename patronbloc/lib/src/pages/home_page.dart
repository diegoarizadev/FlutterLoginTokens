import 'package:flutter/material.dart';
import 'package:patronbloc/src/bloc/provider.dart';
import 'package:patronbloc/src/models/product_model.dart';
import 'package:patronbloc/src/providers/productos_provider.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final productoProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final productsBloc = ProviderInheritedWidget.productBloc(context);
    productsBloc.loadProducts(); //Cargar productos.

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _createListProduct(productsBloc),
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

  _createListProduct(ProductsBloc productsBloc) {
    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          //Se valida si hay información
          final products = snapshot.data;

          return ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, i) => _createItemProduct(products[i],
                context, productsBloc), //Se envia una instancia de ProductModel
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createItemProduct(
      ProductModel product, BuildContext context, ProductsBloc productsBloc) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) => productsBloc.deleteProduct(product.id),
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
