import 'package:flutter/material.dart';

class Juego extends StatefulWidget {
  const Juego({super.key});

  @override
  State<Juego> createState() => _JuegoState();
}

class _JuegoState extends State<Juego> {
  static const int tamanioTablero = 4; // Tamaño del tablero 4x4
  List<List<String>> tablero = List.generate(
    tamanioTablero,
    (_) => List.generate(tamanioTablero, (_) => ''),
  );

  String turnoActual = 'Jugador 1'; // "Jugador 1" para X, "Jugador 2" para O
  int fichasColocadasJugador1 = 0; // Fichas del Jugador 1
  int fichasColocadasJugador2 = 0; // Fichas del Jugador 2
  bool faseColocacion = true; // Fase inicial de colocación de fichas

  void reiniciarJuego() {
    setState(() {
      tablero = List.generate(
          tamanioTablero, (_) => List.generate(tamanioTablero, (_) => ''));
      turnoActual = 'Jugador 1';
      fichasColocadasJugador1 = 0;
      fichasColocadasJugador2 = 0;
      faseColocacion = true;
    });
  }

  bool alBorde(int fila, int columna) {
    return fila == 0 ||
        fila == tamanioTablero - 1 ||
        columna == 0 ||
        columna == tamanioTablero - 1;
  }

  bool esAdyacente(int fila, int columna, int fichaFila, int fichaColumna) {
    return (fila - fichaFila).abs() <= 1 && (columna - fichaColumna).abs() <= 1;
  }

  void colocarFicha(int fila, int columna) {
    if (faseColocacion) {
      // Determinar si es la primera ficha del Jugador 1 (con restricción de borde)
      bool primeraFichaRestriccion =
          turnoActual == 'Jugador 1' && fichasColocadasJugador1 == 0;

      if (tablero[fila][columna].isEmpty &&
          (fichasColocadasJugador1 < 4 || fichasColocadasJugador2 < 4) &&
          (!primeraFichaRestriccion || alBorde(fila, columna))) {
        setState(() {
          tablero[fila][columna] =
              turnoActual == 'Jugador 1' ? 'X' : 'O'; // Asignar símbolo
          turnoActual == 'Jugador 1'
              ? fichasColocadasJugador1++
              : fichasColocadasJugador2++;
          if (fichasColocadasJugador1 == 4 && fichasColocadasJugador2 == 4) {
            faseColocacion = false;
          }
          turnoActual = turnoActual == 'Jugador 1' ? 'Jugador 2' : 'Jugador 1';
        });
      }
    } else {
      seleccionarOMoverFicha(fila, columna);
    }
  }

  int? fichaSeleccionadaFila;
  int? fichaSeleccionadaColumna;

  void seleccionarOMoverFicha(int fila, int columna) {
    if (faseColocacion) return; // Ignorar esta función en la fase de colocación

    if (fichaSeleccionadaFila == null && fichaSeleccionadaColumna == null) {
      // Seleccionar ficha del jugador actual
      if ((turnoActual == 'Jugador 1' && tablero[fila][columna] == 'X') ||
          (turnoActual == 'Jugador 2' && tablero[fila][columna] == 'O')) {
        setState(() {
          fichaSeleccionadaFila = fila;
          fichaSeleccionadaColumna = columna;
        });
      }
    } else {
      // Si ya hay una ficha seleccionada
      if ((turnoActual == 'Jugador 1' && tablero[fila][columna] == 'X') ||
          (turnoActual == 'Jugador 2' && tablero[fila][columna] == 'O')) {
        // Cambiar selección
        setState(() {
          fichaSeleccionadaFila = fila;
          fichaSeleccionadaColumna = columna;
        });
      } else if (esAdyacente(fila, columna, fichaSeleccionadaFila!,
              fichaSeleccionadaColumna!) &&
          tablero[fila][columna].isEmpty) {
        // Mover ficha seleccionada
        setState(() {
          tablero[fila][columna] = turnoActual == 'Jugador 1' ? 'X' : 'O';
          tablero[fichaSeleccionadaFila!][fichaSeleccionadaColumna!] = '';
          fichaSeleccionadaFila = null;
          fichaSeleccionadaColumna = null;
          turnoActual = turnoActual == 'Jugador 1' ? 'Jugador 2' : 'Jugador 1';
        });
      }
    }
  }

  bool verificarVictoria() {
    for (int fila = 0; fila < tamanioTablero; fila++) {
      for (int columna = 0; columna < tamanioTablero; columna++) {
        if (tablero[fila][columna].isNotEmpty) {
          if (_esCuatroEnRaya(fila, columna)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _esCuatroEnRaya(int fila, int columna) {
    const direcciones = [
      [1, 0], // Horizontal
      [0, 1], // Vertical
      [1, 1], // Diagonal principal
      [1, -1], // Diagonal secundaria
    ];

    for (var direccion in direcciones) {
      int consecutivos = 1;
      for (int i = 1; i < 4; i++) {
        int nuevaFila = fila + direccion[0] * i;
        int nuevaColumna = columna + direccion[1] * i;
        if (nuevaFila >= 0 &&
            nuevaFila < tamanioTablero &&
            nuevaColumna >= 0 &&
            nuevaColumna < tamanioTablero &&
            tablero[nuevaFila][nuevaColumna] == tablero[fila][columna]) {
          consecutivos++;
        } else {
          break;
        }
      }
      if (consecutivos == 4) {
        return true;
      }
    }
    return false;
  }

  Widget construirTablero() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tamanioTablero, (fila) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(tamanioTablero, (columna) {
            bool esSeleccionada = fichaSeleccionadaFila == fila &&
                fichaSeleccionadaColumna == columna;

            return GestureDetector(
              onTap: () {
                colocarFicha(fila, columna);
                if (verificarVictoria()) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("¡Victoria!"),
                      content: Text(
                          "${turnoActual == 'Jugador 1' ? 'Jugador 2' : 'Jugador 1'} ha ganado."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            reiniciarJuego();
                          },
                          child: Text("Reiniciar"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(4.0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: esSeleccionada ? Colors.yellow : Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    tablero[fila][columna],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuatro en Raya'),
      ),
      body: Center(
        child: construirTablero(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reiniciarJuego,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}