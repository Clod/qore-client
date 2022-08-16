import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/routes/router.gr.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../../model/paciente.dart';
import '../../../model/patientsDAO.dart';

class PatientWidget extends StatefulWidget {
  const PatientWidget({Key? key, this.parametro}) : super(key: key);

  final Paciente? parametro;

  @override
  PatientWidgetState createState() {
    return PatientWidgetState();
  }
}

class PatientWidgetState extends State<PatientWidget> {
  int kMinWidthOfLargeScreen = 900;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  String unbornNameLabel = " de la madre";

  bool _diag1HasError = false;
  bool _diag2HasError = false;
  bool _diag3HasError = false;
  bool _diag4HasError = false;
  bool _countryHasError = false;
  bool _identHasError = false;
  bool _lastNameHasError = false;
  bool _firstNameHasError = false;
  bool _weeksOfPregnancyHasError = false;

  String? dropdownDiag1;
  String? dropdownDiag2;
  String? dropdownDiag3;
  int diag1Index = 0;
  int diag2Index = 0;
  int diag3Index = 0;

  // No habilito la selección de un subnivel hasta que el anterior esté seleccionado.
  bool inhabilitarDiag2 = true;
  bool inhabilitarDiag3 = true;
  bool inhabilitarDiag4 = true;

  bool creation = true;
  bool unbornPatient = false;

  int patientRow = 0;

  var diag1 = ['Diagnóstico 1', 'Diagnóstico 2'];

  var diag2 = [
    ['Diagnóstico 11', 'Diagnóstico 12'],
    ['Diagnóstico 21', 'Diagnóstico 22']
  ];

  var diag3 = [
    [
      ['Diagnóstico 111', 'Diagnóstico 112'],
      ['Diagnóstico 121', 'Diagnóstico 122']
    ],
    [
      ['Diagnóstico 211', 'Diagnóstico 212'],
      ['Diagnóstico 221', 'Diagnóstico 222']
    ]
  ];

  var diag4 = [
    [
      [
        ['Diagnóstico 1111', 'Diagnóstico 1112'],
        ['Diagnóstico 1121', 'Diagnóstico 1122']
      ],
      [
        ['Diagnóstico 1211', 'Diagnóstico 1212'],
        ['Diagnóstico 1221', 'Diagnóstico 1222']
      ]
    ],
    [
      [
        ['Diagnóstico 2111', 'Diagnóstico 2112'],
        ['Diagnóstico 2121', 'Diagnóstico 2122']
      ],
      [
        ['Diagnóstico 2211', 'Diagnóstico 2212'],
        ['Diagnóstico 2221', 'Diagnóstico 2222']
      ]
    ]
  ];

  var countries = [
    "Argentina",
    "Chile",
    "Perú",
    "Bolivia",
    "Paraguay",
    "Uruguay",
    "Italia",
    "Spain",
    "South Africa",
    "Otro (mencionarlo en comentarios)",
  ];

  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    debugPrint("patient_widget recibió: ${widget.parametro?.toString()}");
    if (widget.parametro == null) {
      creation = true;
      patientRow = 0;
    } else {
      creation = false;
      patientRow = widget.parametro!.id;
    }

    String? _birthDateStr = widget.parametro?.fechaNacimiento;

    // De la base de datos me viene "null" pero cuando estoy en alta me viene null
    if (_birthDateStr != null) {
      // Vengo de la base
      if (_birthDateStr == "null") {
        // En la base está en null
        _birthDate = null;
      } else {
        _birthDate = DateTime.parse(widget.parametro!.fechaNacimiento!);
      }
    }
    debugPrint("Fecha de Nacimiento: $_birthDate");
  }

  //Create key for subdiagnóstico
  final _dropDownKey2 = GlobalKey<FormBuilderFieldState>();
  final _dropDownKey3 = GlobalKey<FormBuilderFieldState>();
  final _dropDownKey4 = GlobalKey<FormBuilderFieldState>();

  void _onUnbornChanged(dynamic val) {
    debugPrint(val.toString());
    unbornPatient = val;
    setState(() {});
  }

  var formatter = DateFormat('dd-MM-yyy');

  @override
  Widget build(BuildContext context) {
    bool isScreenWide =
        MediaQuery.of(context).size.width >= kMinWidthOfLargeScreen;
    debugPrint("Screen width: ${MediaQuery.of(context).size.width}");
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
                'LastName': widget.parametro?.apellido,
                'FirstName': widget.parametro?.nombre,
                'BirthDate': _birthDate,
                'Country': widget.parametro?.nacionalidad,
                'Identification': widget.parametro?.documento,
                'FechaCreacionFicha': widget.parametro?.fechaCreacionFicha,
                'Sexo': widget.parametro?.sexo,
                'DiagnosticoPrenatal': widget.parametro?.diagnosticoPrenatal,
                'PacienteFallecido': (widget.parametro != null &&
                        widget.parametro!.pacienteFallecido != null &&
                        widget.parametro!.pacienteFallecido == "V")
                    ? true
                    : false,
                // final semanasGestacion = data['semanasGestacion'] as int;
                // final diagnostico = data['diagnostico'] as String;
                // final subDiagnostico = data['subDiagnostico'] as String;
                // final fechaPrimerDiagnostico = data['fechaPrimerDiagnostico'] as String;
                'NroHistClinicaPapel': widget.parametro?.nroHistClinicaPapel,
                'Comentarios': widget.parametro?.comentarios,
                // final comentarios = data['comentarios'] as String;
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
                      labelText: unbornPatient
                          ? 'Apellido(s) de la madre'
                          : 'Apellido(s)',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      suffixIcon: _lastNameHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _lastNameHasError = !(_formKey
                                .currentState?.fields['LastName']
                                ?.validate() ??
                            false);
                      });
                    },
                    // valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(70),
                      FormBuilderValidators.min(2),
                    ]),
                    // initialValue: '12',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10),
                  // First Name
                  FormBuilderTextField(
                    // autovalidateMode: AutovalidateMode.always,
                    name: 'FirstName',
                    decoration: InputDecoration(
                      labelText:
                          unbornPatient ? 'Nombre(s) de la madre' : 'Nombre(s)',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      suffixIcon: _firstNameHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
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
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(70),
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
                          initialValue: false,
                          decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              border: OutlineInputBorder()),
                          onChanged: _onUnbornChanged,
                          title: const Text("Diag. prenatal"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                        height: 15,
                      ),
                      Flexible(
                        flex: 2,
                        child: Visibility(
                          visible: !unbornPatient,
                          replacement: FormBuilderTextField(
                            name: 'WeeksOfPregnacy',
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              // FormBuilderValidators.required(),
                              // FormBuilderValidators.numeric(),
                              // FormBuilderValidators.max(40),
                            ]),
                            decoration: InputDecoration(
                              labelText: 'Semanas de gestación',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 10.0),
                              border: const OutlineInputBorder(),
                              suffixIcon: _weeksOfPregnancyHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check,
                                      color: Colors.green),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: FormBuilderDateTimePicker(
                                  name: 'BirthDate',
                                  // initialValue: DateTime.now(),
                                  inputType: InputType.date,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10.0),
                                    labelText: isScreenWide
                                        ? 'Fecha de nacimiento'
                                        : 'Fecha de\nnacimiento',
                                    suffixIcon: IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          _formKey.currentState!.fields['date']
                                              ?.didChange(null);
                                        }),
                                  ),
                                  // initialTime: const TimeOfDay(hour: 8, minute: 0),
                                  locale: const Locale.fromSubtags(
                                      languageCode: 'es'),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: FormBuilderTextField(
                                  // autovalidateMode: AutovalidateMode.always,
                                  name: 'FichaDiagPren',
                                  decoration: const InputDecoration(
                                    labelText: kIsWeb
                                        ? 'Nro. ficha diag. prenatal'
                                        : 'Nro. ficha\ndiag. prenatal',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 10.0),
                                    border: OutlineInputBorder(),
                                    // suffixIcon: _lastNameHasError
                                    //     ? const Icon(Icons.error, color: Colors.red)
                                    //     : const Icon(Icons.check, color: Colors.green),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.numeric(),
                                  ]),
                                  // initialValue: '12',
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
                          initialValue: "No informado",
                          decoration: const InputDecoration(
                            isDense: true,
                            label: Text("Sexo"),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                          ),
                          alignment: WrapAlignment.spaceAround,
                          options: const [
                            FormBuilderFieldOption(value: "M"),
                            FormBuilderFieldOption(value: "F"),
                            FormBuilderFieldOption(value: "N/I"),
                          ],
                          selectedColor: Colors.blueAccent,
                          onChanged: (value) {
                            debugPrint(value);
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: const OutlineInputBorder(),
                            labelText: 'País',
                            suffix: _countryHasError
                                ? const Icon(Icons.error)
                                : const Icon(Icons.check),
                          ),
                          allowClear: true,
                          hint: const Text('País'),
                          // validator: FormBuilderValidators.compose(
                          //     [FormBuilderValidators.required()]),
                          items: countries
                              .map(
                                (ctry) => DropdownMenuItem(
                                  value: ctry,
                                  child: Text(ctry),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            debugPrint("Cambió el país");
                            setState(() {
                              _countryHasError = !(_formKey
                                      .currentState?.fields['Country']
                                      ?.validate() ??
                                  false);
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 10.0),
                            border: const OutlineInputBorder(),
                            suffixIcon: _identHasError
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                          ),
                          onChanged: (val) {
                            setState(
                              () {
                                // _ageHasError = !(_formKey.currentState?.fields['age']
                                //     ?.validate() ??
                                //     false);
                              },
                            );
                          },
                          // valueTransformer: (text) => num.tryParse(text),
                          validator: FormBuilderValidators.compose([
                            // FormBuilderValidators.required(),
                            // FormBuilderValidators.numeric(),
                            // FormBuilderValidators.max(15),
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
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      labelText: 'Diag1',
                      suffix: _diag1HasError
                          ? const Icon(Icons.error)
                          : const Icon(Icons.check),
                    ),
                    // initialValue: 'Male',
                    allowClear: true,
                    hint: const Text('Seleccione el diagnóstico nivel 1'),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: diag1
                        .map(
                          (diag) => DropdownMenuItem(
                            value: diag,
                            child: Text(diag),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      debugPrint("Cambió el diag1");
                      // El diag1 elegido me indica la fila de la matriz de diag2
                      dropdownDiag1 = val!;
                      diag1Index = diag1.indexOf(dropdownDiag1!);
                      dropdownDiag2 = diag2[diag1Index][0];
                      // Como ya elegí diagnóstico, habilito la elección de subdiagnóstico
                      inhabilitarDiag2 = false;
                      // Desahbilito 3 por si estoy cambiando de idea con Diag1
                      inhabilitarDiag3 = true;
                      inhabilitarDiag4 = true;

                      setState(() {
                        // Reseteo el valor de subdiagnóstico para que no vuele por el aire si llego
                        // a cambiar el diagnóstico una vez que ya elegí el subdiagnóstico
                        // https://stackoverflow.com/questions/60057028/how-to-change-formbuilderdropdown-selected-value-using-setstate
                        _dropDownKey2.currentState!.reset();
                        _dropDownKey2.currentState!.setValue(null);

                        _dropDownKey3.currentState!.reset();
                        _dropDownKey3.currentState!.setValue(null);

                        _dropDownKey4.currentState!.reset();
                        _dropDownKey4.currentState!.setValue(null);

                        _diag1HasError = !(_formKey.currentState?.fields['Diag1']
                                ?.validate() ??
                            false);
                      });
                    },
                    valueTransformer: (val) => val?.toString(),
                  ),
                  const SizedBox(height: 10),

                  // Diag2
                  AbsorbPointer(
                    absorbing: inhabilitarDiag2,
                    child: FormBuilderDropdown<String>(
                      //Reference the key
                      key: _dropDownKey2,
                      // autovalidate: true,
                      name: 'Diag2',
                      decoration: InputDecoration(
                        labelText: 'Diag2',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        suffix: _diag2HasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                      ),
                      // initialValue: 'Male',
                      allowClear: true,
                      hint: const Text('Seleccione el diagnóstico nivel 2'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: diag2[diag1Index]
                          .map(
                            (subDiagIt) => DropdownMenuItem(
                              value: subDiagIt,
                              child: Text(subDiagIt),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        debugPrint("Cambió el diagnóstico nivel 2");
                        // El diag2 elegido me indica el segundo íncdice de la matriz de diag3
                        dropdownDiag2 = val!;
                        diag2Index = diag2[diag1Index].indexOf(dropdownDiag2!);
                        dropdownDiag2 = diag2[diag1Index][0];
                        // Como ya elegí diagnóstico, habilito la elección de subdiagnóstico
                        inhabilitarDiag3 = false;
                        inhabilitarDiag4 = false;
                        setState(() {
                          _dropDownKey3.currentState!.reset();
                          _dropDownKey3.currentState!.setValue(null);

                          _dropDownKey4.currentState!.reset();
                          _dropDownKey4.currentState!.setValue(null);

                          _diag2HasError = !(_formKey
                                  .currentState?.fields['Diag2']
                                  ?.validate() ??
                              false);
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
                    absorbing: inhabilitarDiag3,
                    child: FormBuilderDropdown<String>(
                      //Reference the key
                      key: _dropDownKey3,
                      // autovalidate: true,
                      name: 'Diag3',
                      decoration: InputDecoration(
                        labelText: 'Diag3',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        suffix: _diag3HasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                      ),
                      // initialValue: 'Male',
                      allowClear: true,
                      hint: const Text('Seleccione el diagnóstico nivel 3'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: diag3[diag1Index][diag2Index]
                          .map(
                            (subDiagIt) => DropdownMenuItem(
                              value: subDiagIt,
                              child: Text(subDiagIt),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        debugPrint("Cambió el diagnóstico nivel 3");

                        // El diag3 elegido me indica el segundo íncdice de la matriz de diag3
                        dropdownDiag3 = val!;
                        diag3Index = diag3[diag1Index][diag2Index].indexOf(dropdownDiag3!);
                        dropdownDiag3 = diag3[diag1Index][diag2Index][0];

                        inhabilitarDiag4 = false;

                        setState(() {

                          _dropDownKey4.currentState!.reset();
                          _dropDownKey4.currentState!.setValue(null);

                          _diag3HasError = !(_formKey
                                  .currentState?.fields['Diag3']
                                  ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // Diag4
                  AbsorbPointer(
                    absorbing: inhabilitarDiag4,
                    child: FormBuilderDropdown<String>(
                      //Reference the key
                      key: _dropDownKey4,
                      // autovalidate: true,
                      name: 'Diag4',
                      decoration: InputDecoration(
                        labelText: 'Diag4',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        suffix: _diag4HasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                      ),
                      allowClear: true,
                      hint: const Text('Seleccione el diagnóstico nivel 4'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: diag4[diag1Index][diag2Index][diag3Index]
                      // items: diag4[0][0][0]
                          .map(
                            (subDiagIt) => DropdownMenuItem(
                              value: subDiagIt,
                              child: Text(subDiagIt),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        debugPrint("Cambió el diagnóstico nivel 4");
                        setState(() {
                          _diag4HasError = !(_formKey
                                  .currentState?.fields['Diag4']
                                  ?.validate() ??
                              false);
                        });
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 10.0),
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
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10.0),
                            labelText: 'Fecha del primer diagnósico',
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _formKey.currentState!.fields['date']
                                      ?.didChange(null);
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 10.0),
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
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () {
                      if (creation) {
                        AutoRouter.of(context).pop();
                      } else {
                        // Vuelvo a la pantalla anterior manteniendo la lista de pacientes.
                        AutoRouter.of(context).navigateBack();
                        // AutoRouter.of(context).pop();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    child: const Text(
                      'Enviar',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        debugPrint(
                            "Valor de los campos: ${_formKey.currentState?.value.toString()}");
                      } else {
                        debugPrint(_formKey.currentState?.value.toString());
                        debugPrint('validation failed');
                        return;
                      }

                      debugPrint(
                          "Intento dar de alta al paciente: ${_formKey.currentState?.value.toString()}");

                      FormBuilderState base = _formKey.currentState!;

                      var sex = "";

                      switch (base.fields["Sexo"]?.value.toString()) {
                        case "Masculino":
                          sex = "M";
                          break;
                        case "Femenino":
                          sex = "F";
                          break;
                        default:
                          sex = "D";
                          break;
                      }

                      String? birthDate;
                      int _weeksOfPregnacy;

                      if (unbornPatient) {
                        birthDate = "1810-05-25";
                        _weeksOfPregnacy =
                            base.fields["WeeksOfPregnacy"]?.value;
                      } else {
                        birthDate = (base.fields["BirthDate"]?.value != null)
                            ? base.fields["BirthDate"]?.value
                                .toString()
                                .substring(0, 10)
                            : null;
                        _weeksOfPregnacy = 0;
                      }

                      // Paso la fecha de creación de la ficha en formato yyyy-MM-dd como lo espera la BD. Viene dd-MM-yyyy
                      String _fechaCreacionFicha =
                          base.fields["FechaCreacionFicha"]!.value!.toString();
                      _fechaCreacionFicha =
                          _fechaCreacionFicha.substring(6, 10) +
                              "-" +
                              _fechaCreacionFicha.substring(3, 5) +
                              "-" +
                              _fechaCreacionFicha.substring(0, 2);

                      var paciente = Paciente(
                        id: patientRow,
                        apellido:
                            base.fields["LastName"]!.value.toString().trim(),
                        nombre:
                            base.fields["FirstName"]!.value.toString().trim(),
                        documento: base.fields["Identification"]?.value,
                        nacionalidad: base.fields["Country"]?.value,
                        fechaNacimiento: birthDate,
                        fechaCreacionFicha: _fechaCreacionFicha,
                        sexo: sex,
                        diagnosticoPrenatal:
                            base.fields["DiagnosticoPrenatal"]?.value
                                ? "V"
                                : "F",
                        pacienteFallecido:
                            base.fields["PacienteFallecido"]?.value ? "V" : "F",
                        semanasGestacion: _weeksOfPregnacy,
                        diag1: base.fields["Diag1"]?.value,
                        diag2: base.fields["Diag2"]?.value,
                        diag3: base.fields["Diag3"]?.value,
                        diag4: base.fields["Diag4"]?.value,
                        // fechaPrimerDiagnostico: base?.fields["FechaPrimerDiagnostico"]?.value.toString().substring(0, 10),
                        fechaPrimerDiagnostico:
                            (base.fields["FechaPrimerDiagnostico"]?.value !=
                                    null)
                                ? base.fields["FechaPrimerDiagnostico"]?.value
                                    .toString()
                                    .substring(0, 10)
                                : null,
                        nroHistClinicaPapel:
                            base.fields["NroHistClinicaPapel"]?.value,
                        comentarios: base.fields["Comentarios"]?.value,
                      );

                      if (creation) {
                        addPatient(paciente);
                      } else {
                        updatePatient(paciente);
                      }

                      final snackBar = SnackBar(
                        content: Text(_formKey.currentState!.value.toString()),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      if (creation) {
                        AutoRouter.of(context).pop();
                      } else {
                        // AutoRouter.of(context).push(const DashboardRoute());
                        AutoRouter.of(context).push(const PatientsRoute());
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
