class Paciente {
  Paciente({
    required this.id,
    required this.nombre,
    required this.apellido,
    this.fechaNacimiento,
    this.documento,
    this.nacionalidad,
    required this.fechaCreacionFicha,
    this.sexo,
    this.diagnosticoPrenatal,
    this.pacienteFallecido,
    this.semanasGestacion,
    this.diagnostico,
    this.subDiagnostico,
    this.fechaPrimerDiagnostico,
    this.nroHistClinicaPapel,
    this.comentarios,
  });

  final int id;
  String nombre;
  String apellido;
  String? documento;
  String? nacionalidad;
  String? fechaNacimiento;
  String fechaCreacionFicha;
  String? sexo;
  String? diagnosticoPrenatal;
  String? pacienteFallecido;
  int? semanasGestacion;
  String? diagnostico;
  String? subDiagnostico;
  String? fechaPrimerDiagnostico;
  String? nroHistClinicaPapel;
  String? comentarios;

  factory Paciente.fromJson(Map<String, dynamic> data) {
// note the explicit cast to String
// this is required if robust lint rules are enabled
    final id = data['id'] as int;
    final nombre = data['nombre'] as String;
    final apellido = data['apellido'] as String;
    final fechaNacimiento = data['fechaNacimiento'] as String?;
    final documento = data['documento'] as String?;
    final nacionalidad = data['nacionalidad'] as String?;
    final fechaCreacionFicha = data['fechaCreacionFicha'] as String;
    final sexo = data['sexo'] as String?;
    final diagnosticoPrenatal = data['diagnosticoPrenatal'] as String?;
    final pacienteFallecido = data['pacienteFallecido'] as String?;
    final semanasGestacion = data['semanasGestacion'] as int?;
    final diagnostico = data['diagnostico'] as String?;
    final subDiagnostico = data['subDiagnostico'] as String?;
    final fechaPrimerDiagnostico = data['fechaPrimerDiagnostico'] as String?;
    final nroHistClinicaPapel = data['nroHistClinicaPapel'] as String?;
    final comentarios = data['comentarios'] as String?;

    return Paciente(
      id: id,
      nombre: nombre,
      apellido: apellido,
      fechaNacimiento: fechaNacimiento,
      documento: documento,
      nacionalidad: nacionalidad,
      fechaCreacionFicha: fechaCreacionFicha,
      sexo: sexo,
      diagnosticoPrenatal: diagnosticoPrenatal,
      pacienteFallecido: pacienteFallecido,
      semanasGestacion: semanasGestacion,
      diagnostico: diagnostico,
      subDiagnostico: subDiagnostico,
      fechaPrimerDiagnostico: fechaPrimerDiagnostico,
      nroHistClinicaPapel: nroHistClinicaPapel,
      comentarios: comentarios,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'fechaNacimiento': fechaNacimiento,
        'documento': documento,
        'nacionalidad': nacionalidad,
        'fechaCreacionFicha': fechaCreacionFicha,
        'sexo': sexo,
        'diagnosticoPrenatal': diagnosticoPrenatal,
        'pacienteFallecido': pacienteFallecido,
        'semanasGestacion': semanasGestacion,
        'diagnostico': diagnostico,
        'subDiagnostico': subDiagnostico,
        'fechaPrimerDiagnostico': fechaPrimerDiagnostico,
        'nroHistClinicaPapel': nroHistClinicaPapel,
        'comentarios': comentarios,
      };

  @override
  String toString() {
    return (id.toString() + " " + nombre + " " + apellido);
  }
}
