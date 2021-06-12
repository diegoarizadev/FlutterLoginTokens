import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(
    json.decode(str)); //Recibe un String y retorna un modelo.

String productModelToJson(ProductModel data) =>
    json.encode(data.toJson()); //Recibe un modelo y lo retorna como un String

class ProductModel {
  ProductModel({
    this.id = '',
    this.titulo = '',
    this.valor = 0,
    this.disponible = true,
    this.fotoUrl = '',
  });

  String id;
  String titulo;
  int valor;
  bool disponible;
  String fotoUrl;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        //recibe un Mapa y retorna un modelo
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"],
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        //Toma el modelo y retorna un Json.
        "id": id,
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
      };
}
