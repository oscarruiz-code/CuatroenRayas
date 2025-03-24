import 'package:http/http.dart' as http;
import 'dart:convert';

class Servicios {
  static final Servicios _instance = Servicios._internal();
  factory Servicios() => _instance;

  Servicios._internal();

  Future<void> guardarJuego(String gameId, String gameName, List<List<String>> tablero) async {
    final url = Uri.parse("http://localhost:8080/guardar-juego");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "gameId": gameId,
          "gameName": gameName,
          "tablero": tablero
        }),
      );

      if (response.statusCode == 200) {
        print("Tablero guardado correctamente.");
      } else {
        print("Error al guardar el tablero: ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
  }

  Future<List<List<String>>?> cargarJuego(String gameId) async {
    final url = Uri.parse("http://localhost:8080/cargar-juego/$gameId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Tablero cargado correctamente.");
        return List<List<String>>.from(data["tablero"].map((fila) => List<String>.from(fila)));
      } else {
        print("Error al cargar el tablero: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return null;
    }
  }
}
