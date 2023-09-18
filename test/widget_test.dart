// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cardio_gut/model/paciente.dart';
import 'package:cardio_gut/model/patients_dao_ws.dart';
import 'package:cardio_gut/screens/patient_widget_new.dart';
import 'package:cardio_gut/util/Connections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'widget_test.mocks.dart';



abstract class AddPatientWSFunction {
  String call(MockTransceiver transceiver, Paciente patient, Function callback);
}

class AddPatientWSFunctionMock extends Mock implements AddPatientWSFunction {}

class FunctionWrapper {
    String addPatientWS(MockTransceiver transceiver, Paciente patient, Function callback) {
    // Call the actual function here
    return addPatientWS(transceiver, patient, callback);
  }
}

@GenerateMocks([Paciente, Transceiver])
void main() {
  group('PatientWidget tests', () {
    final paciente = MockPaciente();
    final transceiver = MockTransceiver();
    final addPatientWS = AddPatientWSFunctionMock();

    // Set up the mock to return a specific value when called
    // when(addPatientWS(transceiver, paciente, (){}) => 'Mocked Value');

    testWidgets(
      'Should hit the Enviar button and call addPatientWS',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (context) => Connections(),
            child: MaterialApp(
              home: Material(
                child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: const FittedBox(
                              child: Text(
                                'Incorporar paciente al sistema',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const PatientWidget(parametro: null),
                        ],
                      ),
                    ),
                ),
              ),
              localizationsDelegates: const [
                FormBuilderLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
            ),
          ),
        );
        // Here we use physicalSizeTestValue to adjust the test screen size to
        // simulate running on a desktop computer which the app was designed for
//        tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
        await tester.binding.setSurfaceSize(Size(1920, 1080));
        // tester.binding.window.devicePixelRatioTestValue = 1.0;

        final apellidoInputText = find.byKey(const Key("LastName"));
        expect(apellidoInputText, findsOneWidget);
        final apellido = (tester.element(apellidoInputText).widget as FormBuilderTextField).initialValue;
        expect(apellido, null);
        await tester.enterText(apellidoInputText, "Cadorna");

        // https://stackoverflow.com/questions/66741458/tap-in-widget-test-showing-warning-in-flutter
        await tester.ensureVisible(find.byKey(const Key("EnviarButton")));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key("EnviarButton")));

        print ("Encontré el botón");
        final result = await addPatientWS(transceiver, paciente, (){});
        expect(result, 'Mocked Value');

        verify(addPatientWS(transceiver, paciente, (){})).called(1);

      },
    );
  });
}
