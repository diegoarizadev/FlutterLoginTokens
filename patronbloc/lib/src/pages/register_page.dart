import 'package:flutter/material.dart';
import 'package:patronbloc/src/bloc/login_bloc.dart';
import 'package:patronbloc/src/bloc/provider.dart';

class RegisterPage extends StatelessWidget {
  //const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _createBackground(context),
          _loginFrom(context),
        ],
      ),
    );
  }

  _createBackground(BuildContext context) {
    final size = MediaQuery.of(context)
        .size; //recuperar el tamaño actual de la pantalla.

    final fondoMorado = Container(
      height: size.height * 0.4, //40% de la pantalla
      width: double.infinity, //Todo el ancho de la pantalla.
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ],
        ),
      ),
    );

    final circule = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(
          child: circule,
          top: 90.0,
          left: 30.0,
        ), //Posiciona un objeto o widget dentro del stack, se deben color solo 3 valores para la ubicación del widget
        Positioned(
          child: circule,
          top: -40.0,
          right: -30.0,
        ),
        Positioned(
          child: circule,
          bottom: -50.0,
          right: -10.0,
        ),
        Positioned(
          child: circule,
          top: 150.0,
          right: 150.0,
        ),
        Container(
          padding: EdgeInsets.only(
            //Separación superior
            top: 80.0,
          ),
          child: Column(
            children: [
              Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 100.0,
              ),
              SizedBox(
                //Centra los widgets
                height: 10.0,
                width: double.infinity,
              ), //Separador
              Text(
                'Alejandro Ariza',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30),
              )
            ],
          ),
        ),
      ],
    );
  }

  _loginFrom(BuildContext context) {
    final bloc = ProviderInheritedWidget.of(
        context); //invocara el metodo OF, el cual va ha buscar la instancia.
    final size = MediaQuery.of(context)
        .size; //recuperar el tamaño actual de la pantalla.

    return SingleChildScrollView(
      //Es un elemento que permite hacer scroll.
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0), //Bordes redondeados
              boxShadow: <BoxShadow>[
                //Sombra
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 0.5), //Posición de la sombra
                  spreadRadius: 3.0, //Fuerza de la sombra.
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Crear una cuenta',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  //Separación del texto con el TextField
                  height: 60.0,
                ),
                _crearEmail(bloc),
                SizedBox(
                  //Separación del texto con el TextField
                  height: 30.0,
                ),
                _crearPassword(bloc),
                SizedBox(
                  //Separación del texto con el TextField
                  height: 30.0,
                ),
                _crearBoton(bloc),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
            child: Text('Ya tienes una cuenta? Login'),
          ),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  _crearEmail(LoginBloc bloc) {
    //Se resive como parametro la referencia del Bloc.

    return StreamBuilder(
      //Se puede escuchar los cambios sobre el campo del email y reaccionar a ellos.
      stream: bloc.emailStream, //Stream a retornar
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20.0), //Separaciones de los costados
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(
                Icons.alternate_email,
                color: Colors.deepPurple,
              ),
              hintText: 'tucorreo@correo.co', //placeHolder.
              labelText: 'Correo Electrónico',
              counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc
                .changeEmail, //(value) => bloc.changeEmail(value), //Se detecto un cambio y se va ha reaccionar, se puede hacer de las dos formas que se ven en esta liena.
          ),
        );
      },
    );
  }

  _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20.0), //Separaciones de los costados
          child: TextField(
            obscureText: true, //Ocultar el texto escrito
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
                color: Colors.deepPurple,
              ),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            onPressed: snapshot.hasData
                ? () => _obtenerUltimoValorStream(
                    bloc, context) //Era una función anonima🧐
                : null, //si el snapshot tiene información, se invoca la funcion anonima normalmente,. de lo contrario null
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 80.0,
                vertical: 10.0,
              ),
              child: Text('Login'),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
            ),
          );
        });
  }

  _obtenerUltimoValorStream(LoginBloc bloc, BuildContext context) {
    print(' -> Contraseña : ${bloc.password}');
    print(' -> Email : ${bloc.email}');

    //redireccionar a otra pagina.
    Navigator.pushReplacementNamed(context,
        'home'); //pushReplacementNamed: lo redirecciona como un nuevo Root
  }
}
