import 'Comentario.dart';
import 'Paciente.dart';

damePacientes() {

  Paciente uno = Paciente(
    nombre: 'Juan',
    apellido: 'Pérez',
    documento: '11111111',
    nacionalidad: 'Argentino',
    fechaNacimiento: DateTime.utc(1980, 11, 9),
  );

  Comentario perez1 = Comentario(profesional: "Doctor Uno", fechaComentario: DateTime.utc(1980, 11, 9), comentario: "Lorem ipsum uno");
  Comentario perez2 = Comentario(profesional: "Doctor Dos", fechaComentario: DateTime.utc(1980, 11, 10), comentario: "Lorem ipsum dos");
  uno.comentarios.add(perez1);
  uno.comentarios.add(perez2);

  Paciente dos = Paciente(
    nombre: 'Luigi',
    apellido: 'Cadorna',
    documento: '22222222',
    nacionalidad: 'Italiano',
    fechaNacimiento: DateTime.utc(2004, 6, 17),
  );

  Comentario luigi1 = Comentario(profesional: "Doctor CUno", fechaComentario: DateTime.utc(2000, 11, 9), comentario: "Cadorna Lorem ipsum uno");
  Comentario luigi2 = Comentario(profesional: "Doctor CDos", fechaComentario: DateTime.utc(2010, 11, 10), comentario: "Cadorna Lore ipsum dos");
  dos.comentarios.add(luigi1);
  dos.comentarios.add(luigi2);

  var algunosPacientes = <Paciente>[];
  algunosPacientes.add(dos);
  algunosPacientes.add(uno);

  for (int i = 1; i < 100; i++) {
    String nombre = "Nombre paciente " + i.toString();
    String apellido = "Apellido paciente " + i.toString();

    algunosPacientes.add(Paciente(nombre: nombre, apellido: apellido, documento: "1111", nacionalidad: 'Búlgaro', fechaNacimiento: DateTime.now()));

  }

  return algunosPacientes;

}
