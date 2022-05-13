import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../../model/Paciente.dart';
import '../../../model/PatientsDAO.dart';

class PatientWidget extends StatefulWidget {
   PatientWidget({Key? key, this.parametro}) : super(key: key);

  Paciente? parametro;

  @override
  PatientWidgetState createState() {
    return PatientWidgetState();
  }
}

class PatientWidgetState extends State<PatientWidget> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  String unbornNameLabel = " de la madre";

  bool _diagHasError = false;
  bool _subDiagHasError = false;
  bool _countryHasError = false;
  bool _identHasError = false;
  bool _commentsHasError = false;
  bool _lastNameHasError = false;
  bool _firstNameHasError = false;
  bool _weeksOfPregnancyHasError = false;

  String? dropdownDiag;
  String? dropdownSubDiag;
  int subDiagIndex = 0;
  bool inhabilitarSubDiag = true;

  bool creation = true;
  bool unbornPatient = false;

  int patientRow = 0;

  var diagnosticos = ['Diagnóstico 1', 'Diagnóstico 2', 'Diagnóstico 3'];
  var subDiags = [
    ['Diagnóstico 1A', 'Diagnóstico 1B', 'Diagnóstico 1C', 'Diagnóstico 1D'],
    ['Diagnóstico 2A', 'Diagnóstico 2B', 'Diagnóstico 2C', 'Diagnóstico 2D'],
    ['Diagnóstico 3A', 'Diagnóstico 3B', 'Diagnóstico 3C', 'Diagnóstico 3D']
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
    "Otro",
  ];

  @override
  void initState() {
    super.initState();
    debugPrint("patient_widget recibió: ${widget.parametro?.apellido}");
    if (widget.parametro == null) {
      creation = true;
      patientRow = 0;
    } else {
      creation = false;
      patientRow = widget.parametro!.id;
    }
    ; // Creation or update?
  }

  //Create key for subdiagnóstico
  final _dropDownKey = GlobalKey<FormBuilderFieldState>();

  void _onUnbornChanged(dynamic val) {
    debugPrint(val.toString());
    unbornPatient = val;
    setState(() {});
  }

  var formatter = DateFormat('dd-MM-yyy');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
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
                // Si vino el parámetro y la fecha es no vacía, la uso. Si no, mando null
                'BirthDate': (widget.parametro != null &&
                        widget.parametro!.fechaNacimiento.isNotEmpty)
                    ? DateTime.parse(widget.parametro!.fechaNacimiento)
                    : null,
                'Country': widget.parametro?.nacionalidad,
                'Identification': widget.parametro?.documento,
                'FechaCreacionFicha' : widget.parametro?.fechaCreacionFicha
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
                    // initialValue: '12',
                    // keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 5),
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
                    // initialValue: '12',
                    // keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 5),
                  // ¿Gestación? Fecha nacimiento
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderCheckbox(
                          name: 'unborn',
                          initialValue: false,
                          decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              border: OutlineInputBorder()),
                          onChanged: _onUnbornChanged,
                          title: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Diagnóstico prenatal',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Visibility(
                          visible: !unbornPatient,
                          replacement: FormBuilderTextField(
                            name: 'WeeksOfPregnacy',
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
                          child: FormBuilderDateTimePicker(
                            name: 'BirthDate',
                            // initialValue: DateTime.now(),
                            inputType: InputType.date,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10.0),
                              labelText: 'Fecha de nacimiento',
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['date']
                                        ?.didChange(null);
                                  }),
                            ),
                            // initialTime: const TimeOfDay(hour: 8, minute: 0),
                            locale:
                                const Locale.fromSubtags(languageCode: 'es'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: FormBuilderChoiceChip<String>(
                          name: 'sexo',
                          initialValue: "",
                          decoration: const InputDecoration(
                            isDense: true,
                            label: Text("Sexo"),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                          ),
                          alignment: WrapAlignment.center,
                          options: const [
                            FormBuilderFieldOption(value: "Masculino"),
                            FormBuilderFieldOption(value: "Femenino"),
                            FormBuilderFieldOption(value: "No informado"),
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
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: const Text('Seleccione el país'),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
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
                            FormBuilderValidators.required(),
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
                  // Diagnóstico
                  FormBuilderDropdown<String>(
                    // autovalidate: true,
                    name: 'Diagnostico',
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      labelText: 'Diagnóstico',
                      suffix: _diagHasError
                          ? const Icon(Icons.error)
                          : const Icon(Icons.check),
                    ),
                    // initialValue: 'Male',
                    allowClear: true,
                    hint: const Text('Seleccione el diagnóstico'),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: diagnosticos
                        .map(
                          (diag) => DropdownMenuItem(
                            value: diag,
                            child: Text(diag),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      debugPrint("Cambió el diagnóstico");
                      // El diagnósitco elegido me indica la fila de la matriz de subdiagnósticos
                      dropdownDiag = val!;
                      subDiagIndex = diagnosticos.indexOf(dropdownDiag!);
                      dropdownSubDiag = subDiags[subDiagIndex][0];
                      // Como ya elegí diagnóstico, habilito la elección de subdiagnóstico
                      inhabilitarSubDiag = false;
                      setState(() {
                        // Reseteo el valor de subdiagnóstico para que no vuele por el aire si llego
                        // a cambiar el diagnóstico una vez que ya elegí el subdiagnóstico
                        // https://stackoverflow.com/questions/60057028/how-to-change-formbuilderdropdown-selected-value-using-setstate
                        _dropDownKey.currentState!.reset();
                        _dropDownKey.currentState!.setValue(null);

                        _diagHasError = !(_formKey
                                .currentState?.fields['diagnostico']
                                ?.validate() ??
                            false);
                      });
                    },
                    valueTransformer: (val) => val?.toString(),
                  ),
                  const SizedBox(height: 10),
                  // Subdiagnóstico
                  AbsorbPointer(
                    absorbing: inhabilitarSubDiag,
                    child: FormBuilderDropdown<String>(
                      //Reference the key
                      key: _dropDownKey,
                      // autovalidate: true,
                      name: 'SubDiag',
                      decoration: InputDecoration(
                        labelText: 'Sub Diagnóstico',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        suffix: _subDiagHasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                      ),
                      // initialValue: 'Male',
                      allowClear: true,
                      hint: const Text('Seleccione el sub-diagnóstico'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: subDiags[subDiagIndex]
                          .map(
                            (subDiagIt) => DropdownMenuItem(
                              value: subDiagIt,
                              child: Text(subDiagIt),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        debugPrint("Cambió el subdiagnóstico");
                        setState(() {
                          _subDiagHasError = !(_formKey
                                  .currentState?.fields['subDiag']
                                  ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'nroHistClinPapel',
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 10.0),
                      border: const OutlineInputBorder(),
                      labelText: 'Nro. historia clínica en papel',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
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
                  width: 10.0,
                ),
                SizedBox(
                  // height: 40.0,
                  width: 260.0,
                  child: FormBuilderSwitch(
                    name: "fallecido",
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
              name: 'Comments',
              minLines: 3,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Comentarios',
                border: const OutlineInputBorder(),
                suffixIcon: _commentsHasError
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
              // initialValue: '12',
              // keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        debugPrint(
                            "Valor de los campos: ${_formKey.currentState?.value.toString()}");
                      } else {
                        debugPrint(_formKey.currentState?.value.toString());
                        debugPrint('validation failed');
                      }

                      debugPrint(
                          "Intento dar de alta al paciente: ${_formKey.currentState?.value.toString()}");

                      var base = _formKey.currentState;

                      var paciente = Paciente(
                        id: patientRow,
                        apellido: base?.fields["LastName"]?.value,
                        nombre: base?.fields["FirstName"]?.value,
                        documento: base?.fields["Identification"]?.value,
                        nacionalidad: base?.fields["Country"]?.value,
                        fechaNacimiento: base!.fields["BirthDate"]!.value!
                            .toString()
                            .substring(0, 10),
                        fechaCreacionFicha: base.fields["FechaCreacionFicha"]!.value!.toString()
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
                        AutoRouter.of(context).push(const DashboardRoute());
                      }
                    },
                    child: const Text(
                      'Enviar',
                      style: TextStyle(color: Colors.white),
                    ),
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
