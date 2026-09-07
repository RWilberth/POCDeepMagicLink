class Producto {
  final int? id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json['id'] as int?,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String,
        precio: (json['precio'] as num).toDouble(),
        stock: json['stock'] as int,
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'stock': stock,
      };
}
