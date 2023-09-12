import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../assets/global_data.dart';
import '../model/arbol_de_diagnosticos.dart';
import '../model/paciente.dart';
import '../model/paises.dart';
import '../model/patients_dao_ws.dart';
import '../routes/app_router.dart';
import '../util/aux_functions.dart';

class PatientWidget extends StatelessWidget {
  final Paciente? parametro;

  const PatientWidget({super.key, required this.parametro});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Paciente>(
      future: traerPacienteByIdWS(
        parametro!.id,
        informConectionProblems,
        informErrorsReportedByServer,
      ), // Replace with your WebSocket channel function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // The future is still executing
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // The future completed successfully, populate your widget with the data
          return PatientWidgetForm(parametro: snapshot.data);
        } else if (snapshot.hasError) {
          // An error occurred, handle it appropriately
          return Text('Error: ${snapshot.error}');
        } else {
          // The future completed with no data
          return const Text('No data available.');
        }
      },
    );
  }
}

class PatientWidgetForm extends StatefulWidget {
  const PatientWidgetForm({Key? key, this.parametro}) : super(key: key);

  final Paciente? parametro;

  @override
  PatientWidgetFormState createState() {
    return PatientWidgetFormState();
  }
}

class PatientWidgetFormState extends State<PatientWidgetForm> {
  int kMinWidthOfLargeScreen = 900;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  String unbornNameLabel = " de la madre";

  // Campos de paciente
  int _idRegistroPaciente = 0;
  String? _lastName = '';
  String? _firstName = '';
  DateTime? _fechaNacimiento;
  String? _nroFichaDiagPrenatal = '';
  String? _paisOrigen;
  String? _idDocumento = '';
  DateTime? _fechaPrimerDiagnostico;
  String? _fechaCreacionFicha = '';
  String _sex = 'N/I';
  // String? _diagnosticoPrenatal = '';
  bool _pacienteFallecido = false;
  String? _diag1;
  String? _diag2;
  String? _diag3;
  String? _diag4;
  String? _semanasGestacion;
  String? _nroHistClinicaPapel = '';
  String? _comentarios = '';

  bool _diag1HasError = false;
  final bool _diag2HasError = false;
  bool _diag3HasError = false;
  bool _countryHasError = false;
  bool _identHasError = false;
  bool _lastNameHasError = false;
  bool _firstNameHasError = false;
  final bool _weeksOfPregnancyHasError = false;

  // No habilito la selección de un subnivel hasta que el anterior esté seleccionado.
  bool _inhabilitarDiag2 = true;
  bool _inhabilitarDiag3 = true;
  bool _inhabilitarDiag4 = true;

  bool _creandoFicha = true;
  bool _esDiagPrenatal = false;

  @override
  void initState() {
    super.initState();
    logger.d("patient_widget recibió: ${widget.parametro?.toString()}");

    // Me fijo se entré desde crear paciente (para,etro = null) o desde modificar
    if (widget.parametro == null) {
      // Creando
      _creandoFicha = true;
      _idRegistroPaciente = 0;
      // logger.d("Países: $countries");
    } else {
      // Modificando
      _creandoFicha = false;
      _idRegistroPaciente = widget.parametro!.id;

      if (widget.parametro!.diagnosticoPrenatal != null && widget.parametro!.diagnosticoPrenatal == "V") {
        _esDiagPrenatal = true;
        if (widget.parametro!.semanasGestacion != null) {
          _semanasGestacion = widget.parametro!.semanasGestacion.toString();
        }
      }

      _lastName = widget.parametro?.apellido;
      _firstName = widget.parametro?.nombre;
      String? _fechaNacimientoStr = widget.parametro?.fechaNacimiento;

      // De la base de datos me viene "null" pero cuando estoy en alta me viene null
      if (_fechaNacimientoStr != null) {
        // Vengo de la base
        if (_fechaNacimientoStr == "null") {
          // En la base está en null
          _fechaNacimiento = null;
        } else {
          var fechaNacimiento = widget.parametro!.fechaNacimiento!;
          var year = fechaNacimiento.split("-")[0];
          var month = fechaNacimiento.split("-")[1].padLeft(2, '0');
          var day = fechaNacimiento.split("-")[2].padLeft(2, '0');

          _fechaNacimiento = DateTime.parse("$year-$month-$day");
        }
      }
      logger.d("Fecha nacimiento: $_fechaNacimiento");

      _nroFichaDiagPrenatal = widget.parametro?.nroFichaDiagPrenatal;

      _paisOrigen = widget.parametro?.pais;
      _idDocumento = widget.parametro?.documento;
      _fechaCreacionFicha = widget.parametro?.fechaCreacionFicha;
      // Sexo
      if (widget.parametro!.sexo! == 'D') {
        _sex = 'N/I';
      } else {
        _sex = widget.parametro!.sexo!;
      }
      // _diagnosticoPrenatal = widget.parametro?.diagnosticoPrenatal;
      _pacienteFallecido =
          (widget.parametro != null && widget.parametro!.pacienteFallecido != null && widget.parametro!.pacienteFallecido == "V")
              ? true
              : false;
      _diag1 = widget.parametro?.diag1;
      _diag2 = widget.parametro?.diag2;
      _diag3 = widget.parametro?.diag3;
      _diag4 = widget.parametro?.diag4;
      // final semanasGestacion = data[semanasGestacion] as int;
      // final fechaPrimerDiagnostico = data[fechaPrimerDiagnostico] as String;
      _nroHistClinicaPapel = widget.parametro?.nroHistClinicaPapel;

      String? _fechaPrimerDiag = widget.parametro?.fechaPrimerDiagnostico;

      // De la base de datos me viene "null" pero cuando estoy en alta me viene null
      if (_fechaPrimerDiag != null) {
        // Vengo de la base
        if (_fechaPrimerDiag == "null") {
          // En la base está en null
          _fechaPrimerDiagnostico = null;
        } else {
          var fechaPrimerDiagnostico = widget.parametro!.fechaPrimerDiagnostico!;
          var year = fechaPrimerDiagnostico.split("-")[0];
          var month = fechaPrimerDiagnostico.split("-")[1].padLeft(2, '0');
          var day = fechaPrimerDiagnostico.split("-")[2].padLeft(2, '0');
          _fechaPrimerDiagnostico = DateTime.parse("$year-$month-$day");
        }
      }
      logger.d("Fecha primer diagnóstico: $_fechaPrimerDiagnostico");

      _comentarios = widget.parametro?.comentarios;
    }
  } // Fin initState

  //Create key for subdiagnóstico
  final _dropDownKey2 = GlobalKey<FormBuilderFieldState>();
  final _dropDownKey3 = GlobalKey<FormBuilderFieldState>();
  final _dropDownKey4 = GlobalKey<FormBuilderFieldState>();

  void _onUnbornChanged(dynamic val) {
    logger.d(val.toString());
    setState(() {
      _esDiagPrenatal = val;
    });
  }

  var formatter = DateFormat('dd/MM/yyy');

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= kMinWidthOfLargeScreen;
    // logger.d("Screen width: ${MediaQuery.of(context).size.width}");

    logger.d("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    logger.d("Building patient_widget");
    logger.d("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              // enabled: false,
              autovalidateMode: AutovalidateMode.disabled,
              initialValue: {
                'LastName': _lastName,
                'FirstName': _firstName,
                'FechaNacimiento': _fechaNacimiento,
                'Country': _paisOrigen,
                'Identification': _idDocumento,
                'FechaCreacionFicha': _fechaCreacionFicha,
                'NroFichaDiagPrenatal': _nroFichaDiagPrenatal,
                'Sexo': _sex,
                'DiagnosticoPrenatal': _esDiagPrenatal,
                'PacienteFallecido': _pacienteFallecido,
                'Diag1': _diag1,
                'Diag2': _diag2,
                'Diag3': _diag3,
                'Diag4': _diag4,
                'SemanasGestacion': _semanasGestacion,
                'NroHistClinicaPapel': _nroHistClinicaPapel,
                'FechaPrimerDiagnostico': _fechaPrimerDiagnostico,
                'Comentarios': _comentarios,
              },
              skipDisabled: true,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 15),
                  // Last Name
                  FormBuilderTextField(
                    // autovalidateMode: AutovalidateMode.always,
                    name: 'LastName',
                    decoration: InputDecoration(
                      labelText: _esDiagPrenatal ? 'Apellido(s) de la madre' : 'Apellido(s)',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      suffixIcon: _lastNameHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.match("[a-zA-Z ]+"),
                      FormBuilderValidators.maxLength(30),
                      FormBuilderValidators.minLength(2),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10),
                  // First Name
                  FormBuilderTextField(
                    name: 'FirstName',
                    decoration: InputDecoration(
                      labelText: _esDiagPrenatal ? 'Nombre(s) de la madre' : 'Nombre(s)',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      suffixIcon: _firstNameHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.match("[a-zA-Z ]+"),
                      FormBuilderValidators.maxLength(30),
                      FormBuilderValidators.minLength(2),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 5),
                  // ¿Gestación? Fecha nacimiento
                  Flex(
                    direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 1,
                        child: FormBuilderCheckbox(
                          name: 'DiagnosticoPrenatal',
                          // initialValue: false,
                          decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              border: OutlineInputBorder()),
                          onChanged: _onUnbornChanged,
                          title: const Text("Diagnóstico prenatal"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                        height: 15,
                      ),
                      Flexible(
                        flex: 2,
                        child: Visibility(
                          visible: !_esDiagPrenatal,
                          replacement: FormBuilderTextField(
                            name: 'SemanasGestacion',
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([]),
                            decoration: InputDecoration(
                              labelText: 'Semanas de gestación',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                              border: const OutlineInputBorder(),
                              suffixIcon: _weeksOfPregnancyHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check, color: Colors.green),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: FormBuilderDateTimePicker(
                                  name: 'FechaNacimiento',
                                  // initialValue: DateTime.now(),
                                  inputType: InputType.date,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                                    labelText: isScreenWide ? 'Fecha de nacimiento' : 'Fecha de\nnacimiento',
                                    suffixIcon: IconButton(
                                        icon: const Icon(Icons.close),
                                        // Reset field
                                        onPressed: () {
                                          _formKey.currentState!.fields['FechaNacimiento']?.didChange(null);
                                        }),
                                  ),
                                  // initialTime: const TimeOfDay(hour: 8, minute: 0),
                                  locale: const Locale.fromSubtags(languageCode: 'es'),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: FormBuilderTextField(
                                  // autovalidateMode: AutovalidateMode.always,
                                  name: 'NroFichaDiagPrenatal',
                                  decoration: const InputDecoration(
                                    labelText: kIsWeb ? 'Nro. de ficha del diagnóstico prenatal' : 'Nro. ficha\ndiag. prenatal',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.numeric(),
                                  ]),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: FormBuilderChoiceChip<String>(
                          name: 'Sexo',
                          // initialValue: "N/I",
                          decoration: const InputDecoration(
                            isDense: true,
                            label: Text("Sexo"),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                          ),
                          alignment: WrapAlignment.spaceAround,
                          options: const [
                            FormBuilderChipOption(value: "M"),
                            FormBuilderChipOption(value: "F"),
                            FormBuilderChipOption(value: "N/I"),
                          ],
                          selectedColor: Colors.blueAccent,
                          onChanged: (value) {
                            logger.t(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Country - Identification
                  Row(
                    children: [
                      // Country
                      Expanded(
                        child: FormBuilderDropdown<String>(
                          // autovalidate: true,
                          name: 'Country',
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            border: const OutlineInputBorder(),
                            labelText: 'País emisor del documento',
                            suffix: _countryHasError ? const Icon(Icons.error) : const Icon(Icons.check),
                          ),
                          // allowClear: false,   xxxx
                          // hint: const Text('País emisor del documento'), xxxx
                          items: countries
                              .map(
                                (ctry) => DropdownMenuItem(
                                  value: ctry,
                                  child: Text(ctry),
                                ),
                              )
                              .toList(),
                          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                          onChanged: (val) {
                            logger.t("Cambió el país");
                            setState(() {
                              _countryHasError = !(_formKey.currentState?.fields['Country']?.validate() ?? false);
                            });
                          },
                          valueTransformer: (val) => val?.toString(),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      // Identification
                      Expanded(
                        child: FormBuilderTextField(
                          // autovalidateMode: AutovalidateMode.always,
                          name: 'Identification',
                          decoration: InputDecoration(
                            labelText: 'Documento',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                            border: const OutlineInputBorder(),
                            suffixIcon: _identHasError
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                          ),
                          onChanged: (val) {
                            setState(
                              () {},
                            );
                          },
                          // valueTransformer: (text) => num.tryParse(text),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            // FormBuilderValidators.numeric(), FormBuilderValidators.max(15),
                          ]),
                          // initialValue: '12',
                          // keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  /***************** Diagnósticos *****************/
                  // Diag1
                  FormBuilderDropdown<String>(
                    // autovalidate: true,
                    name: 'Diag1',
                    decoration: InputDecoration(
                      labelText: 'Diagnóstico de nivel 1',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      suffix: _diag1HasError ? const Icon(Icons.error) : const Icon(Icons.check),
                    ),
                    // allowClear: false, // Muestro (o no) una x a la derecha para resetear el campo xxx
                    // hint: const Text('Seleccione el diagnóstico nivel 1'), xxx
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                    items: diags.keys
                        .map(
                          (diag) => DropdownMenuItem(
                            value: diag,
                            child: Text(diag),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      logger.t("Cambió el diag1 a $val");

                      // Como ya elegí diagnóstico, habilito la elección de subdiagnóstico
                      _inhabilitarDiag2 = false;

                      // Desahbilito 3 por si estoy cambiando de idea con Diag1
                      _inhabilitarDiag3 = true;
                      _inhabilitarDiag4 = true;

                      setState(() {
                        // me guardo el valor del diagnóstico elegido para después usarlo
                        // para mostrar los subdiagnósticos correspondientes
                        _diag1 = val;

                        logger.t("Diags de nivel 2: " + diags[_diag1]!.keys.toString());
                        logger.t((diags[_diag1]!.keys).toString());

                        // Reseteo el valor de subdiagnóstico para que no vuele por el aire si llego
                        // a cambiar el diagnóstico una vez que ya elegí el subdiagnóstico
                        // https://stackoverflow.com/questions/60057028/how-to-change-formbuilderdropdown-selected-value-using-setstate
                        _dropDownKey2.currentState!.reset();
                        _dropDownKey2.currentState!.setValue(null);
                        _diag2 = null;

                        _dropDownKey3.currentState!.reset();
                        _dropDownKey3.currentState!.setValue(null);
                        _diag3 = null;

                        _dropDownKey4.currentState!.reset();
                        _dropDownKey4.currentState!.setValue(null);
                        _diag4 = null;

                        _diag1HasError = !(_formKey.currentState?.fields['Diag1']?.validate() ?? false);
                      });
                    },
                    valueTransformer: (val) => val?.toString(),
                  ),
                  const SizedBox(height: 10),

                  // Diag2
                  AbsorbPointer(
                    absorbing: _inhabilitarDiag2,
                    child: FormBuilderDropdown<String>(
                      //Reference the key
                      key: _dropDownKey2,
                      // autovalidate: true,
                      name: 'Diag2',
                      decoration: InputDecoration(
                        labelText: 'Diagnóstico de nivel 2',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        suffix: _diag2HasError ? const Icon(Icons.error) : const Icon(Icons.check),
                      ),
                      // allowClear: false,  xxxx
                      // hint: const Text('Seleccione el diagnóstico nivel 2'), xxxx
                      // Intenta armar las listas aunque el widget no esté habilitado.
                      // Si la lista está vacía no habilita la elección.
                      // Cuando entro la primera vez _diag1 = null pero
                      // "No hay nivel 2" nunca se muestra porque el combo está
                      // inhabilitado. Recién se habilita cuando se elige el nivel 1
                      // y ahí _dia1 ya no es null (puede ser vacía si no hay subnivel)
                      items: (_diag1 != null)
                          ? diags[_diag1]!
                              .keys
                              .map(
                                (diag2It) => DropdownMenuItem(
                                  value: diag2It,
                                  child: Text(diag2It),
                                ),
                              )
                              .toList()
                          : [""].map((diag2It) => DropdownMenuItem(value: diag2It, child: const Text("No hay nivel 2"))).toList(),
                      onChanged: (val) {
                        logger.t("Cambió el diagnóstico nivel 2 a $val");

                        _inhabilitarDiag3 = false;

                        setState(() {
                          _diag2 = val;

                          _dropDownKey3.currentState!.reset();
                          _dropDownKey3.currentState!.setValue(null);

                          _dropDownKey4.currentState!.reset();
                          _dropDownKey4.currentState!.setValue(null);
                          // No puede tener error. Es opcional y sale de un combo
                          // _diag2HasError = !(_formKey
                          //         .currentState?.fields['Diag2']
                          //         ?.validate() ??
                          //     false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // Diag3
                  AbsorbPointer(
                    absorbing: _inhabilitarDiag3,
                    child: FormBuilderDropdown<String>(
                      //Reference the key
                      key: _dropDownKey3,
                      // autovalidate: true,
                      name: 'Diag3',
                      decoration: InputDecoration(
                        labelText: 'Diagnóstico de nivel 3',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        suffix: _diag3HasError ? const Icon(Icons.error) : const Icon(Icons.check),
                      ),
                      // initialValue: 'Male',
                      // allowClear: false, xxxx
                      // hint: const Text('Seleccione el diagnóstico nivel 3'), xxxx
                      // validator: FormBuilderValidators.compose(
                      //     [FormBuilderValidators.required()]),
                      items: (_diag1 != null && _diag2 != null)
                          ? diags[_diag1]![_diag2]!
                              .keys
                              .map(
                                (diag3It) => DropdownMenuItem(
                                  value: diag3It,
                                  child: Text(diag3It),
                                ),
                              )
                              .toList()
                          : [""]
                              .map(
                                (diag3It) => DropdownMenuItem(
                                  value: diag3It,
                                  child: Text(diag3It),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        logger.t("Cambió el diagnóstico nivel 3");

                        // Habilito el nivel siguiente
                        _inhabilitarDiag4 = false;

                        setState(() {
                          _diag3 = val;

                          _dropDownKey4.currentState!.reset();
                          _dropDownKey4.currentState!.setValue(null);

                          _diag3HasError = !(_formKey.currentState?.fields['Diag3']?.validate() ?? false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Diag4
                  AbsorbPointer(
                    absorbing: _inhabilitarDiag4,
                    child: FormBuilderDropdown<String>(
                      //Reference the key
                      key: _dropDownKey4,
                      // autovalidate: true,
                      name: 'Diag4',
                      decoration: const InputDecoration(
                        labelText: 'Diagnóstico de nivel 4',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        border: OutlineInputBorder(),
                        // suffix: _diag4HasError
                        //     ? const Icon(Icons.error)
                        //     : const Icon(Icons.check),
                      ),
                      // allowClear: false,   xxxx
                      // hint: const Text('Seleccione el diagnóstico nivel 4'),   xxxxx
                      // validator: FormBuilderValidators.compose(
                      //     [FormBuilderValidators.required()]),
                      items: (_diag1 != null && _diag2 != null && _diag3 != null)
                          ? diags[_diag1]![_diag2]![_diag3]!
                              .map(
                                (diag4It) => DropdownMenuItem(
                                  value: diag4It,
                                  child: Text(diag4It),
                                ),
                              )
                              .toList()
                          : [""]
                              .map(
                                (diag4It) => DropdownMenuItem(
                                  value: diag4It,
                                  child: const Text("No hay nivel 4"),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        logger.t("Cambió el diagnóstico nivel 4");
                        setState(() {});
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Flex(
                    direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FormBuilderTextField(
                          name: 'NroHistClinicaPapel',
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                            labelText: 'Nro. historia clínica en papel',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Flexible(
                        child: FormBuilderDateTimePicker(
                          name: 'FechaPrimerDiagnostico',
                          // initialValue: DateTime.now(),
                          inputType: InputType.date,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                            labelText: 'Fecha del primer diagnósico',
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _formKey.currentState!.fields['FechaPrimerDiagnostico']?.didChange(null);
                                }),
                          ),
                          // initialTime: const TimeOfDay(hour: 8, minute: 0),
                          locale: const Locale.fromSubtags(languageCode: 'es'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Flexible(
                        child: FormBuilderTextField(
                          name: 'FechaCreacionFicha',
                          enabled: false,
                          initialValue: formatter.format(DateTime.now()),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                            labelText: 'Fecha de creación de la ficha',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      SizedBox(
                        // width: 260.0,
                        width: 200.0,
                        child: FormBuilderSwitch(
                          name: "PacienteFallecido",
                          contentPadding: const EdgeInsets.only(top: 1.0),
                          title: const Text("Paciente fallecido"),
                          decoration: const InputDecoration(
                            // border: InputBorder.none,
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Comments
                  FormBuilderTextField(
                    // autovalidateMode: AutovalidateMode.always,
                    name: 'Comentarios',
                    minLines: 3,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Comentarios',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        // _ageHasError = !(_formKey.currentState?.fields['age']
                        //     ?.validate() ??
                        //     false);
                      });
                    },
                    // valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      // FormBuilderValidators.required(),
                      // // FormBuilderValidators.numeric(),
                      // FormBuilderValidators.max(70),
                    ]),
                    // initialValue: '12',
                    // keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () {
                    rollbackWS();
                    if (_creandoFicha) {
                      AutoRouter.of(context).pop();
                    } else {
                      // Vuelvo a la pantalla anterior manteniendo la lista de pacientes.
                      // navigateBack Deprecated :-(
                      AutoRouter.of(context).pop();
                    }
                  },
                ),
                const SizedBox(width: 30),
                MaterialButton(
                  child: const Text(
                    'Enviar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      logger.d("Valor de los campos: ${_formKey.currentState?.value.toString()}");
                    } else {
                      logger.d(_formKey.currentState?.value.toString());
                      setState(() {
                        if (!_formKey.currentState!.fields["LastName"]!.validate()) _lastNameHasError = true;
                        if (!_formKey.currentState!.fields["FirstName"]!.validate()) _firstNameHasError = true;
                        if (!_formKey.currentState!.fields["Identification"]!.validate()) _identHasError = true;
                      });
                      logger.d('validation failed');
                      return;
                    }

                    logger.d("Intento dar de alta al paciente: ${_formKey.currentState?.value.toString()}");

                    FormBuilderState base = _formKey.currentState!;

                    var _sexChar = "";

                    switch (base.fields["Sexo"]?.value.toString()) {
                      case "M":
                        _sexChar = "M";
                        break;
                      case "F":
                        _sexChar = "F";
                        break;
                      default:
                        _sexChar = "D";
                        break;
                    }

                    String? _fechaNacimientoEnviar;
                    int? _semanasGestacionEnviar;
                    String? _nroFichaDiagPreEnviar;

                    if (_esDiagPrenatal) {
                      _fechaNacimientoEnviar = null;
                      logger.d("Semanas gestación: " + base.fields["SemanasGestacion"]?.value);
                      _semanasGestacionEnviar = int.parse(base.fields["SemanasGestacion"]?.value);
                      _nroFichaDiagPreEnviar = null;
                    } else {
                      _fechaNacimientoEnviar = (base.fields["FechaNacimiento"]?.value != null)
                          ? base.fields["FechaNacimiento"]?.value.toString().substring(0, 10)
                          : null;
                      _nroFichaDiagPreEnviar = base.fields["NroFichaDiagPrenatal"]?.value;
                      _semanasGestacionEnviar = null;
                    }

                    // Paso la fecha de creación de la ficha en formato yyyy-MM-dd como lo espera la BD. Viene dd-MM-yyyy
                    String _fechaCreacionFicha = base.fields["FechaCreacionFicha"]!.value!.toString();
                    _fechaCreacionFicha = _fechaCreacionFicha.substring(6, 10) +
                        "-" +
                        _fechaCreacionFicha.substring(3, 5) +
                        "-" +
                        _fechaCreacionFicha.substring(0, 2);

                    var paciente = Paciente(
                      id: _idRegistroPaciente,
                      apellido: base.fields["LastName"]!.value.toString().trim(),
                      nombre: base.fields["FirstName"]!.value.toString().trim(),
                      documento: base.fields["Identification"]?.value,
                      pais: base.fields["Country"]?.value,
                      fechaNacimiento: _fechaNacimientoEnviar,
                      nroFichaDiagPrenatal: _nroFichaDiagPreEnviar,
                      fechaCreacionFicha: _fechaCreacionFicha,
                      sexo: _sexChar,
                      diagnosticoPrenatal: base.fields["DiagnosticoPrenatal"]?.value ? "V" : "F",
                      pacienteFallecido: base.fields["PacienteFallecido"]?.value ? "V" : "F",
                      semanasGestacion: _semanasGestacionEnviar,
                      diag1: base.fields["Diag1"]?.value,
                      diag2: base.fields["Diag2"]?.value,
                      diag3: base.fields["Diag3"]?.value,
                      diag4: base.fields["Diag4"]?.value,
                      // fechaPrimerDiagnostico: base?.fields["FechaPrimerDiagnostico"]?.value.toString().substring(0, 10),
                      fechaPrimerDiagnostico: (base.fields["FechaPrimerDiagnostico"]?.value != null)
                          ? base.fields["FechaPrimerDiagnostico"]?.value.toString().substring(0, 10)
                          : null,
                      nroHistClinicaPapel: base.fields["NroHistClinicaPapel"]?.value,
                      comentarios: base.fields["Comentarios"]?.value,
                    );

                    String _respuesta = "";
                    String _accion = "";

                    if (_creandoFicha) {
                      // _respuesta = await addPatient(paciente);
                      logger.d("Enviando solicitud de alta");
                      _respuesta = await addPatientWS(paciente, informConectionProblems);
                      logger.d("Respuesta del servidor: $_respuesta");
                      _accion = 'creó';
                    } else {
                      _respuesta = await updatePatientWS(paciente, informConectionProblems);
//                      _respuesta = await updatePatientLockingWS(paciente, informConectionProblems);
                      _accion = 'modificó';
                    }

                    //final snackBar = buildSnackBar2(_respuesta, _accion);

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    showSnackBar(_respuesta, _accion);

                    if (_creandoFicha) {
                      AutoRouter.of(context).pop();
                    } else {
                      // AutoRouter.of(context).push(const DashboardRoute());
                      AutoRouter.of(context).push(const PatientsRoute());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  informConectionProblems() {
    const snackBar = SnackBar(
      content: Text('Error de conexión con el serivdor.'),
      duration: Duration(seconds: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SnackBar buildSnackBar2(String _respuesta, String _accion) {
    // Remove curly braces from the string
    String keyValueString = _respuesta.replaceAll('{', '').replaceAll('}', '').replaceAll('"', '');

// Split the string into an array of key-value pairs
    List<String> keyValuePairs = keyValueString.split(',');
// Create a new Map<String, dynamic> object
    Map<String, dynamic> resultMap = {};

// Populate the Map with key-value pairs
    for (String keyValue in keyValuePairs) {
      // Split each key-value pair by the colon
      List<String> pair = keyValue.split(':');

      // Trim whitespace from the key and value strings
      String key = pair[0].trim();
      String? value = (pair[1].trim() == 'null' ? null : pair[1].trim());

      // Add the key-value pair to the Map
      resultMap[key] = value;
    }

    return SnackBar(
      duration: const Duration(seconds: 15),
      content: Text(resultMap['Message']),
/*      content: (_respuesta != "" && _respuesta != "-1")
          ? Text(
              'Se $_accion la ficha Nro.:  $_respuesta',
              textAlign: TextAlign.center,
            )
          : (_respuesta != ""
              ? const Text(
                  'Ya existe un paciente con ese documento',
                  textAlign: TextAlign.center,
                )
              : const Text(
                  'No se creó la ficha. El servidor no responde',
                  textAlign: TextAlign.center,
                )),*/
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          logger.d("Listo");
        },
      ),
    );
  }

  void showSnackBar(String _respuesta, String _accion) {
    // Remove curly braces from the string
    String keyValueString = _respuesta.replaceAll('{', '').replaceAll('}', '').replaceAll('"', '');

// Split the string into an array of key-value pairs
    List<String> keyValuePairs = keyValueString.split(',');
// Create a new Map<String, dynamic> object
    Map<String, dynamic> resultMap = {};

// Populate the Map with key-value pairs
    for (String keyValue in keyValuePairs) {
      // Split each key-value pair by the colon
      List<String> pair = keyValue.split(':');

      // Trim whitespace from the key and value strings
      String key = pair[0].trim();
      String? value = (pair[1].trim() == 'null' ? null : pair[1].trim());

      // Add the key-value pair to the Map
      resultMap[key] = value;
    }

    final snackBar = SnackBar(
      duration: const Duration(seconds: 15),
      content: Text(resultMap['Message']),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          logger.d("Listo");
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
