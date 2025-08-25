//Ejercicio 7: Gestor de Ubicaciones Favoritas
import 'dart:io';
import 'dart:math';

class Ubicacion {
  String nombre;
  double latitud;
  double longitud;
  String categoria; // casa, trabajo, restaurante, hospital
  String notas;

  Ubicacion(this.nombre, this.latitud, this.longitud, this.categoria, this.notas);

  @override
  String toString() {
    return "$nombre [${categoria.toUpperCase()}] - Lat: $latitud, Lon: $longitud - Notas: $notas";
  }
}

class GestorUbicaciones {
  List<Ubicacion> ubicaciones = [];

  void agregarUbicacion(String nombre, double lat, double lon, String categoria, String notas) {
    ubicaciones.add(Ubicacion(nombre, lat, lon, categoria, notas));
    print(" Ubicación '$nombre' agregada correctamente.");
  }

  void eliminarUbicacion(String nombre) {
    ubicaciones.removeWhere((u) => u.nombre.toLowerCase() == nombre.toLowerCase());
    print(" Ubicación '$nombre' eliminada (si existía).");
  }

  void mostrarTodas() {
    if (ubicaciones.isEmpty) {
      print(" No hay ubicaciones guardadas.");
      return;
    }
    print("\n=== LISTA DE UBICACIONES ===");
    for (var u in ubicaciones) {
      print(u);
    }
  }

  void buscarPorCategoria(String categoria) {
    var filtradas = ubicaciones.where((u) => u.categoria.toLowerCase() == categoria.toLowerCase()).toList();
    if (filtradas.isEmpty) {
      print(" No hay ubicaciones de categoría '$categoria'.");
      return;
    }
    print("\n=== Ubicaciones en categoría: $categoria ===");
    for (var u in filtradas) {
      print(u);
    }
  }

  double calcularDistancia(String nombre1, String nombre2) {
    Ubicacion? u1 = ubicaciones.firstWhere(
        (u) => u.nombre.toLowerCase() == nombre1.toLowerCase(),
        orElse: () => null as Ubicacion);
    Ubicacion? u2 = ubicaciones.firstWhere(
        (u) => u.nombre.toLowerCase() == nombre2.toLowerCase(),
        orElse: () => null as Ubicacion);

    if (u1 == null || u2 == null) {
      print("Una o ambas ubicaciones no existen.");
      return 0.0;
    }

    const double radioTierra = 6371; // km
    double dLat = _toRadians(u2.latitud - u1.latitud);
    double dLon = _toRadians(u2.longitud - u1.longitud);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(u1.latitud)) *
            cos(_toRadians(u2.latitud)) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radioTierra * c;
  }

  double _toRadians(double grados) => grados * pi / 180;
}

void main() {
  GestorUbicaciones gestor = GestorUbicaciones();
  int opcion;

  do {
    print("\n=== GESTOR DE UBICACIONES FAVORITAS ===");
    print("1. Agregar ubicación");
    print("2. Eliminar ubicación");
    print("3. Mostrar todas");
    print("4. Buscar por categoría");
    print("5. Calcular distancia entre dos ubicaciones");
    print("0. Salir");
    stdout.write("Opción: ");
    opcion = int.tryParse(stdin.readLineSync() ?? "") ?? -1;

    switch (opcion) {
      case 1:
        stdout.write("Nombre: ");
        String nombre = stdin.readLineSync() ?? "";
        stdout.write("Latitud: ");
        double? lat = double.tryParse(stdin.readLineSync() ?? "");
        stdout.write("Longitud: ");
        double? lon = double.tryParse(stdin.readLineSync() ?? "");
        stdout.write("Categoría (casa, trabajo, restaurante, hospital): ");
        String categoria = stdin.readLineSync() ?? "";
        stdout.write("Notas: ");
        String notas = stdin.readLineSync() ?? "";

        if (lat == null || lon == null) {
          print(" Coordenadas inválidas.");
          break;
        }

        gestor.agregarUbicacion(nombre, lat, lon, categoria, notas);
        break;

      case 2:
        stdout.write("Ingrese el nombre de la ubicación a eliminar: ");
        String nombre = stdin.readLineSync() ?? "";
        gestor.eliminarUbicacion(nombre);
        break;

      case 3:
        gestor.mostrarTodas();
        break;

      case 4:
        stdout.write("Ingrese la categoría a buscar: ");
        String categoria = stdin.readLineSync() ?? "";
        gestor.buscarPorCategoria(categoria);
        break;

      case 5:
        stdout.write("Nombre de la primera ubicación: ");
        String n1 = stdin.readLineSync() ?? "";
        stdout.write("Nombre de la segunda ubicación: ");
        String n2 = stdin.readLineSync() ?? "";
        double distancia = gestor.calcularDistancia(n1, n2);
        if (distancia > 0) {
          print(" La distancia entre '$n1' y '$n2' es de ${distancia.toStringAsFixed(2)} km.");
        }
        break;

      case 0:
        print(" Saliendo del sistema...");
        break;

      default:
        print(" Opción inválida.");
    }
  } while (opcion != 0);
}