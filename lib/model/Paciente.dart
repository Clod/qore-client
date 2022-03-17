import 'package:cardio_gut/model/Comentario.dart';

class Paciente {
   Paciente(
      {required this.nombre,
      required this.apellido,
      required this.fechaNacimiento,
      required this.documento,
      required this.nacionalidad});

  final String nombre;
  final String apellido;
  final String documento;
  final String nacionalidad;
  final DateTime fechaNacimiento;

  final comentarios = <Comentario>[];

}
