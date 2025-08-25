//Ejercicio 8: Reproductor de Lista Musical
import 'dart:io';
import 'dart:math';

class Cancion {
  String titulo;
  String artista;
  int duracion; // en segundos
  String genero;
  double calificacion; // 1 a 5
  int vecesReproducida = 0;

  Cancion(this.titulo, this.artista, this.duracion, this.genero, this.calificacion);

  void reproducir() {
    vecesReproducida++;
    print("Reproduciendo: $titulo - $artista [$genero] (${_formatearDuracion(duracion)})");
  }

  String _formatearDuracion(int segundos) {
    int min = segundos ~/ 60;
    int sec = segundos % 60;
    return "${min}m ${sec}s";
  }

  @override
  String toString() {
    return "$titulo - $artista | ${_formatearDuracion(duracion)} | $genero |  ${calificacion.toStringAsFixed(1)}";
  }
}

class Playlist {
  String nombre;
  List<Cancion> canciones = [];

  Playlist(this.nombre);

  void agregarCancion(Cancion c) {
    canciones.add(c);
    print(" Canción '${c.titulo}' agregada a la playlist.");
  }

  void quitarCancion(String titulo) {
    canciones.removeWhere((c) => c.titulo.toLowerCase() == titulo.toLowerCase());
    print(" Canción '$titulo' eliminada (si existía).");
  }

  void reproducirAleatoria() {
    if (canciones.isEmpty) {
      print(" No hay canciones en la playlist.");
      return;
    }
    var random = Random();
    var cancion = canciones[random.nextInt(canciones.length)];
    cancion.reproducir();
  }

  void mostrarTodas() {
    if (canciones.isEmpty) {
      print(" Playlist vacía.");
      return;
    }
    print("\n=== Playlist: $nombre ===");
    for (var c in canciones) {
      print(c);
    }
  }

  void filtrarPorGenero(String genero) {
    var filtradas = canciones.where((c) => c.genero.toLowerCase() == genero.toLowerCase()).toList();
    if (filtradas.isEmpty) {
      print(" No hay canciones del género '$genero'.");
      return;
    }
    print("\n=== Canciones de género: $genero ===");
    for (var c in filtradas) {
      print(c);
    }
  }

  void calcularDuracionTotal() {
    int totalSegundos = canciones.fold(0, (suma, c) => suma + c.duracion);
    int min = totalSegundos ~/ 60;
    int sec = totalSegundos % 60;
    print(" Duración total de la playlist: ${min}m ${sec}s");
  }

  void mostrarEstadisticas() {
    if (canciones.isEmpty) {
      print(" No hay estadísticas, la playlist está vacía.");
      return;
    }
    int totalReproducciones = canciones.fold(0, (suma, c) => suma + c.vecesReproducida);
    double promedioCalificacion = canciones.fold(0.0, (suma, c) => suma + c.calificacion) / canciones.length;

    print("\n=== ESTADÍSTICAS ===");
    print("Canciones en la playlist: ${canciones.length}");
    print("Reproducciones totales: $totalReproducciones");
    print("Calificación promedio:  ${promedioCalificacion.toStringAsFixed(1)}");

    Cancion? masReproducida = canciones.reduce((a, b) => a.vecesReproducida > b.vecesReproducida ? a : b);
    print("Canción más reproducida: ${masReproducida.titulo} (${masReproducida.vecesReproducida} veces)");
  }
}

void main() {
  Playlist playlist = Playlist("Mis Favoritos");
  int opcion;

  do {
    print("\n=== REPRODUCTOR MUSICAL ===");
    print("1. Agregar canción");
    print("2. Quitar canción");
    print("3. Mostrar todas");
    print("4. Reproducir aleatoria");
    print("5. Filtrar por género");
    print("6. Duración total");
    print("7. Estadísticas");
    print("0. Salir");
    stdout.write("Opción: ");
    opcion = int.tryParse(stdin.readLineSync() ?? "") ?? -1;

    switch (opcion) {
      case 1:
        stdout.write("Título: ");
        String titulo = stdin.readLineSync() ?? "";
        stdout.write("Artista: ");
        String artista = stdin.readLineSync() ?? "";
        stdout.write("Duración (en segundos): ");
        int? duracion = int.tryParse(stdin.readLineSync() ?? "");
        stdout.write("Género: ");
        String genero = stdin.readLineSync() ?? "";
        stdout.write("Calificación (1-5): ");
        double? calificacion = double.tryParse(stdin.readLineSync() ?? "");

        if (duracion == null || calificacion == null) {
          print(" Datos inválidos.");
          break;
        }

        playlist.agregarCancion(Cancion(titulo, artista, duracion, genero, calificacion));
        break;

      case 2:
        stdout.write("Ingrese el título de la canción a quitar: ");
        String titulo = stdin.readLineSync() ?? "";
        playlist.quitarCancion(titulo);
        break;

      case 3:
        playlist.mostrarTodas();
        break;

      case 4:
        playlist.reproducirAleatoria();
        break;

      case 5:
        stdout.write("Ingrese el género: ");
        String genero = stdin.readLineSync() ?? "";
        playlist.filtrarPorGenero(genero);
        break;

      case 6:
        playlist.calcularDuracionTotal();
        break;

      case 7:
        playlist.mostrarEstadisticas();
        break;

      case 0:
        print("Cerrando reproductor...");
        break;

      default:
        print(" Opción inválida.");
    }
  } while (opcion != 0);
}