import 'package:flutter/material.dart';

bool isNumeric(String value) {
  if (value.isEmpty) return false;

  final n = num.tryParse(
      value); // Se valida si, es posible parsear el valor String a entero.

  return (n == null) ? false : true;
}

void seeAlert(BuildContext context, String message) {
  print('seeAlert - message  : $message');
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Datos incorrectos'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), //Cierra el Alert.
              child: Text('Ok'), //Texto del Botón.
            )
          ],
        );
      });
}
