class Cliente {
  final int? id;
  final String nombre;
  final String email;
  final String telefono;
  final String direccion;

  Cliente({
    this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.direccion,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json['id'] as int?,
        nombre: json['nombre'] as String,
        email: json['email'] as String,
        telefono: json['telefono'] as String,
        direccion: json['direccion'] as String,
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'email': email,
        'telefono': telefono,
        'direccion': direccion,
      };
}
