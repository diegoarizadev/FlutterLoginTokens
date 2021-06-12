import 'package:flutter/material.dart';
import 'package:patronbloc/src/bloc/login_bloc.dart';
export 'package:patronbloc/src/bloc/login_bloc.dart';

class ProviderInheritedWidget extends InheritedWidget {
  static ProviderInheritedWidget? _instancia;

  factory ProviderInheritedWidget({Key? key, required Widget child}) {
    if (_instancia == null) {
      //Si ya se tenia información en la instancia; se retorna la misma instancia, de lo contrario, se crea una nueva.
      _instancia = new ProviderInheritedWidget._internal(
        key: key,
        child: child,
      );
    }
    return _instancia!;
  }

  ProviderInheritedWidget._internal({Key? key, required Widget child})
      : super(
          //Inicializacion
          key: key, //identificador unico del widget
          child: child, //Puede ser cualquier widget
        );

  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
  //Al actualizarse, debe notificar a sus hijos.

  //Instancia de LoginBloc.
  static LoginBloc of(BuildContext context) {
    //El context tiene todo el arbol de widgets.
    return context //La función va abuscar en todo el arbol la instancia del provider que se definio
        .dependOnInheritedWidgetOfExactType<ProviderInheritedWidget>()!
        .loginBloc;
  }
}
