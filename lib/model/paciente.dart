import '../assets/global_data.dart';

class Paciente {
  Paciente({
    required this.id,
    required this.nombre,
    required this.apellido,
    this.fechaNacimiento,
    this.documento,
    this.pais,
    required this.fechaCreacionFicha,
    this.sexo,
    this.diagnosticoPrenatal,
    this.pacienteFallecido,
    this.semanasGestacion,
    this.diag1,
    this.diag2,
    this.diag3,
    this.diag4,
    this.sindAsocGen,
    this.fechaPrimerDiagnostico,
    this.nroHistClinicaPapel,
    this.nroFichaDiagPrenatal,
    this.comentarios,
    this.historial,
  });

  final int id;
  String nombre;
  String apellido;
  String? documento;
  String? pais;
  String? fechaNacimiento;
  String fechaCreacionFicha;
  String? sexo;
  String? diagnosticoPrenatal;
  String? pacienteFallecido;
  int? semanasGestacion;
  String? diag1;
  String? diag2;
  String? diag3;
  String? diag4;
  String? sindAsocGen;
  String? fechaPrimerDiagnostico;
  String? nroHistClinicaPapel;
  String? nroFichaDiagPrenatal;
  String? comentarios;
  String? historial;

  factory Paciente.fromJson(Map<String, dynamic> data) {
// note the explicit cast to String
// this is required if robust lint rules are enabled
    //final id = int.parse(data['id']);
    final id = data['id'];
    final nombre = data['nombre'] as String;
    final apellido = data['apellido'] as String;
    final fechaNacimiento = data['fecha_nacimiento'] as String?;
    final documento = data['documento'] as String?;
    final pais = data['pais'] as String?;
    final fechaCreacionFicha = data['fecha_creacion_ficha'] as String;
    final sexo = data['sexo'] as String?;
    final diagnosticoPrenatal = data['diagnostico_prenatal'] as String?;
    final pacienteFallecido = data['paciente_fallecido'] as String?;
    final semanasGestacion = data['semanas_gestacion'] != null ? int.parse(data['semanas_gestacion']) : null;
    final diag1 = data['diag1'] as String?;
    final diag2 = data['diag2'] as String?;
    final diag3 = data['diag3'] as String?;
    final diag4 = data['diag4'] as String?;
    final sindAsocGen = data['sind_y_asoc_gen'] as String?;
    final fechaPrimerDiagnostico = data['fecha_primer_diagnostico'] as String?;
    final nroHistClinicaPapel = data['nro_hist_clinica_papel'] as String?;
    final nroFichaDiagPrenatal = data['nro_ficha_diag_prenatal'] as String?;
    final comentarios = data['comentarios'] as String?;
    final historial = data['historial'] as String?;

    logger.d("Received Json: ${data.toString()}");

    return Paciente(
      id: id,
      nombre: nombre,
      apellido: apellido,
      fechaNacimiento: fechaNacimiento,
      documento: documento,
      pais: pais,
      fechaCreacionFicha: fechaCreacionFicha,
      sexo: sexo,
      diagnosticoPrenatal: diagnosticoPrenatal,
      pacienteFallecido: pacienteFallecido,
      semanasGestacion: semanasGestacion,
      diag1: diag1,
      diag2: diag2,
      diag3: diag3,
      diag4: diag4,
      sindAsocGen: sindAsocGen,
      fechaPrimerDiagnostico: fechaPrimerDiagnostico,
      nroHistClinicaPapel: nroHistClinicaPapel,
      nroFichaDiagPrenatal: nroFichaDiagPrenatal,
      comentarios: comentarios,
      historial: historial,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'fechaNacimiento': fechaNacimiento,
        'documento': documento,
        'pais': pais,
        'fechaCreacionFicha': fechaCreacionFicha,
        'sexo': sexo,
        'diagnosticoPrenatal': diagnosticoPrenatal,
        'pacienteFallecido': pacienteFallecido,
        'semanasGestacion': semanasGestacion,
        'diag1': diag1,
        'diag2': diag2,
        'diag3': diag3,
        'diag4': diag4,
        'sindAsocGen': sindAsocGen,
        'fechaPrimerDiagnostico': fechaPrimerDiagnostico,
        'nroHistClinicaPapel': nroHistClinicaPapel,
        'nroFichaDiagPrenatal': nroFichaDiagPrenatal,
        'comentarios': comentarios,
        'historial': historial,
      };

  @override
  String toString() {
    // return (id.toString() + " " + nombre + " " + apellido);
    return toJson().toString();
  }
}
