import 'package:cardio_gut/model/Comentario.dart';

class Paciente {
  Paciente(
      {required this.id,
      required this.nombre,
      required this.apellido,
      required this.fechaNacimiento,
      required this.documento,
      required this.nacionalidad});

  final int id;
  final String nombre;
  final String apellido;
  final String documento;
  final String nacionalidad;
  final String fechaNacimiento;

  factory Paciente.fromJson(Map<String, dynamic> data) {
// note the explicit cast to String
// this is required if robust lint rules are enabled
    final id = data['id'] as int;
    final nombre = data['nombre'] as String;
    final apellido = data['apellido'] as String;
    final fechaNacimiento = data['fechaNacimiento'] as String;
    final documento = data['documento'] as String;
    final nacionalidad = data['nacionalidad'] as String;
    return Paciente(
        id: id,
        nombre: nombre,
        apellido: apellido,
        fechaNacimiento: fechaNacimiento,
        documento: documento,
        nacionalidad: nacionalidad);
  }
  final comentarios = <Comentario>[];

  @override
  String toString() {
    return (id.toString() + " " + nombre + " " + apellido);
  }
}


