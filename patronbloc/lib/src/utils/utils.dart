bool isNumeric(String value) {
  if (value.isEmpty) return false;

  final n = num.tryParse(
      value); // Se valida si, es posible parsear el valor String a entero.

  return (n == null) ? false : true;
}
