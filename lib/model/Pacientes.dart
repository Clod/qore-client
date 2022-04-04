import 'package:flutter/cupertino.dart';

import 'Comentario.dart';
import 'Paciente.dart';
import 'dart:async';

damePacientes() {

  Paciente uno = Paciente(
    id: 1000,
    nombre: 'Juan',
    apellido: 'Pérez',
    documento: '11111111',
    nacionalidad: 'Argentino',
    fechaNacimiento: "1980, 11, 9",
  );

  Comentario perez1 = Comentario(
      profesional: "Doctor Uno",
      fechaComentario: DateTime.utc(1980, 11, 9),
      comentario: "Lorem ipsum uno");
  Comentario perez2 = Comentario(
      profesional: "Doctor Dos",
      fechaComentario: DateTime.utc(1980, 11, 10),
      comentario: "Lorem ipsum dos");
  uno.comentarios.add(perez1);
  uno.comentarios.add(perez2);

  Paciente dos = Paciente(
    id: 1001,
    nombre: 'Luigi',
    apellido: 'Cadorna',
    documento: '22222222',
    nacionalidad: 'Italiano',
    fechaNacimiento: "2004, 6, 17",
  );

  Comentario luigi1 = Comentario(
      profesional: "Doctor CUno",
      fechaComentario: DateTime.utc(2000, 11, 9),
      comentario: "Cadorna Lorem ipsum uno");
  Comentario luigi2 = Comentario(
      profesional: "Doctor CDos",
      fechaComentario: DateTime.utc(2010, 11, 10),
      comentario: "Cadorna Lore ipsum dos");
  dos.comentarios.add(luigi1);
  dos.comentarios.add(luigi2);

  var algunosPacientes = <Paciente>[];
  algunosPacientes.add(dos);
  algunosPacientes.add(uno);

  // Generados en https://generatedata.com/generator para Python
  List<Paciente> otrosPacientes = [
    Paciente(
        id: 1002,
        nombre: "Drake",
        apellido: "Trujillo",
        documento: "80118011",
        nacionalidad: "Austria",
        fechaNacimiento: "2021-09-27"),
    Paciente(
        id: 1003,
        nombre: "Nash",
        apellido: "Steele",
        documento: "94979497",
        nacionalidad: "Sweden",
        fechaNacimiento: "2022-06-19"),
    Paciente(
        id: 1004,
        nombre: "Patiño",
        apellido: "lUIS",
        documento: "94979497",
        nacionalidad: "Sweden",
        fechaNacimiento: "2022-06-19"),
    Paciente(
        id: 1005,
        nombre: "Gibb",
        apellido: "Barry",
        documento: "94979497",
        nacionalidad: "Sweden",
        fechaNacimiento: "2022-06-19"),
    Paciente(
        id: 1006,
        nombre: "Mongo",
        apellido: "Aurelio",
        documento: "94979497",
        nacionalidad: "Sweden",
        fechaNacimiento: "2022-06-19")
  ];

  algunosPacientes.add(otrosPacientes[0]);
  algunosPacientes.add(otrosPacientes[1]);

  algunosPacientes += otrosPacientes;

  return algunosPacientes;
}

