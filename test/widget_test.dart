import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:juegocuatroenrayas/src/juego.dart';

void main() {
  group('Cuatro en Raya Tests', () {
    testWidgets('El tablero se carga correctamente', (WidgetTester tester) async {
      // Construye el widget del juego
      await tester.pumpWidget(const MaterialApp(home: Juego()));

      // Comprueba que el tablero tiene el tamaño esperado (7x7 = 49 celdas)
      expect(find.byType(Container), findsNWidgets(49));
    });

    testWidgets('Los jugadores pueden colocar fichas en celdas vacías', (WidgetTester tester) async {
      // Construye el widget del juego
      await tester.pumpWidget(const MaterialApp(home: Juego()));

      // Simula un toque en una celda específica
      final primeraCelda = find.byType(Container).at(0);
      await tester.tap(primeraCelda);
      await tester.pump();

      // Comprueba que la celda cambió de estado (jugador X)
      expect(
        (tester.widget(primeraCelda) as Container).decoration,
        isA<BoxDecoration>().having(
          (d) => d.color,
          'color',
          Colors.blue,
        ),
      );
    });

    testWidgets('El turno alterna correctamente entre X y O', (WidgetTester tester) async {
      // Construye el widget del juego
      await tester.pumpWidget(const MaterialApp(home: Juego()));

      // Simula un toque en la primera celda
      final primeraCelda = find.byType(Container).at(0);
      await tester.tap(primeraCelda);
      await tester.pump();

      // Simula un toque en la segunda celda
      final segundaCelda = find.byType(Container).at(1);
      await tester.tap(segundaCelda);
      await tester.pump();

      // Comprueba que la primera celda es azul (X) y la segunda es roja (O)
      expect(
        (tester.widget(primeraCelda) as Container).decoration,
        isA<BoxDecoration>().having(
          (d) => d.color,
          'color',
          Colors.blue,
        ),
      );
      expect(
        (tester.widget(segundaCelda) as Container).decoration,
        isA<BoxDecoration>().having(
          (d) => d.color,
          'color',
          Colors.red,
        ),
      );
    });
  });
}