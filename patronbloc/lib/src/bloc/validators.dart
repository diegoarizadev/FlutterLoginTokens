import 'dart:async';

class Validators {
//Definicion de los StreamTransformers
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      //Que informacion fluye y sale.
      handleData: (password, sink) {
    //Que informacion sigue fluyendo y si existe un error retornarlo

    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Más de 6 caracteres por favor');
    }
  });

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
      //Que informacion fluye y sale.
      handleData: (email, sink) {
    RegExp regExp = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (email.length == 0) {
      sink.add(email);
    } else if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('El email no es correcto');
    }
  });
}
