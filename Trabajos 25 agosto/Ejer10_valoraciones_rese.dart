//Ejercicio 10: Sistema de Valoraciones y Reseñas
import 'dart:io';

class Resena {
  String usuario;
  int calificacion; // 1-5
  String comentario;
  DateTime fecha;
  int utilidad; // cantidad de veces que la reseña fue marcada como útil

  Resena({
    required this.usuario,
    required this.calificacion,
    required this.comentario,
    required this.fecha,
    this.utilidad = 0,
  });

  // Marcar reseña como útil
  void marcarComoUtil() {
    utilidad++;
  }

  @override
  String toString() {
    return " $usuario |  $calificacion | ${fecha.toLocal()} $comentario Útil: $utilidad";
  }
}

class SistemaResenas {
  List<Resena> resenas = [];

  // Agregar reseña
  void agregarResena(Resena resena) {
    resenas.add(resena);
  }

  // Calcular promedio de calificaciones
  double promedioCalificaciones() {
    if (resenas.isEmpty) return 0.0;
    int suma = resenas.fold(0, (prev, r) => prev + r.calificacion);
    return suma / resenas.length;
  }

  // Filtrar por calificación
  List<Resena> filtrarPorEstrellas(int estrellas) {
    return resenas.where((r) => r.calificacion == estrellas).toList();
  }

  // Mostrar reseñas más útiles
  List<Resena> masUtiles({int top = 3}) {
    List<Resena> copia = List.from(resenas);
    copia.sort((a, b) => b.utilidad.compareTo(a.utilidad));
    return copia.take(top).toList();
  }

  // Estadísticas básicas
  void mostrarEstadisticas() {
    print("\n=== ESTADÍSTICAS DE RESEÑAS ===");
    print("Total de reseñas: ${resenas.length}");
    print("Promedio de calificaciones: ${promedioCalificaciones().toStringAsFixed(2)}");
    for (int i = 5; i >= 1; i--) {
      print("Reseñas con $i estrellas: ${filtrarPorEstrellas(i).length}");
    }
  }

  // Listar todas las reseñas
  void mostrarTodas() {
    print("\n=== LISTA DE RESEÑAS ===");
    for (var r in resenas) {
      print(r);
      print("---------------------------");
    }
  }
}

// Ejemplo de uso
void main() {
  SistemaResenas sistema = SistemaResenas();

  // Agregar algunas reseñas de prueba
  sistema.agregarResena(Resena(
    usuario: "Ana",
    calificacion: 5,
    comentario: "Excelente app, muy útil!",
    fecha: DateTime.now(),
  ));

  sistema.agregarResena(Resena(
    usuario: "Luis",
    calificacion: 3,
    comentario: "Está bien, pero podría mejorar.",
    fecha: DateTime.now().subtract(Duration(days: 1)),
  ));

  sistema.agregarResena(Resena(
    usuario: "Carla",
    calificacion: 4,
    comentario: "Me gusta, pero algunos errores menores.",
    fecha: DateTime.now().subtract(Duration(days: 2)),
  ));

  // Marcar algunas reseñas como útiles
  sistema.resenas[0].marcarComoUtil();
  sistema.resenas[0].marcarComoUtil();
  sistema.resenas[2].marcarComoUtil();

  // Mostrar estadísticas y reseñas
  sistema.mostrarEstadisticas();
  sistema.mostrarTodas();

  // Mostrar las más útiles
  print("\n=== RESEÑAS MÁS ÚTILES ===");
  for (var r in sistema.masUtiles()) {
    print(r);
    print("---------------------------");
  }
}