//Ejercicio 6: Sistema de Notificaciones Push
import 'dart:io';

class Notificacion {
  String titulo;
  String mensaje;
  String tipo; // info, advertencia, error
  DateTime fechaHora;
  bool leida;

  Notificacion(this.titulo, this.mensaje, this.tipo)
      : fechaHora = DateTime.now(),
        leida = false;

  void marcarComoLeida() {
    leida = true;
  }

  @override
  String toString() {
    String estado = leida ? " Leída" : " No leída";
    return "[${tipo.toUpperCase()}] $titulo - $mensaje ($estado) - ${fechaHora.toLocal()}";
  }
}

class SistemaNotificaciones {
  List<Notificacion> notificaciones = [];

  void crearNotificacion(String titulo, String mensaje, String tipo) {
    notificaciones.add(Notificacion(titulo, mensaje, tipo));
  }

  void mostrarTodas() {
    if (notificaciones.isEmpty) {
      print("📭 No hay notificaciones.");
      return;
    }
    for (var n in notificaciones) {
      print(n);
    }
  }

  void marcarLeida(int index) {
    if (index >= 0 && index < notificaciones.length) {
      notificaciones[index].marcarComoLeida();
      print(" Notificación marcada como leída.");
    } else {
      print(" Índice inválido.");
    }
  }

  void filtrarPorTipo(String tipo) {
    var filtradas = notificaciones.where((n) => n.tipo == tipo).toList();
    if (filtradas.isEmpty) {
      print("No hay notificaciones de tipo $tipo.");
    } else {
      print("\n=== Notificaciones tipo $tipo ===");
      for (var n in filtradas) {
        print(n);
      }
    }
  }

  void mostrarEstadisticas() {
    int total = notificaciones.length;
    int leidas = notificaciones.where((n) => n.leida).length;
    int noLeidas = total - leidas;

    print("\n=== ESTADÍSTICAS ===");
    print("Total: $total");
    print("Leídas: $leidas");
    print("No leídas: $noLeidas");

    int info = notificaciones.where((n) => n.tipo == "info").length;
    int advertencia = notificaciones.where((n) => n.tipo == "advertencia").length;
    int error = notificaciones.where((n) => n.tipo == "error").length;

    print("Por tipo:");
    print("- Info: $info");
    print("- Advertencia: $advertencia");
    print("- Error: $error");
  }
}

void main() {
  SistemaNotificaciones sistema = SistemaNotificaciones();
  int opcion;

  do {
    print("\n=== SISTEMA DE NOTIFICACIONES PUSH ===");
    print("1. Crear notificación");
    print("2. Mostrar todas");
    print("3. Marcar como leída");
    print("4. Filtrar por tipo");
    print("5. Mostrar estadísticas");
    print("0. Salir");
    stdout.write("Opción: ");
    opcion = int.tryParse(stdin.readLineSync() ?? "") ?? -1;

    switch (opcion) {
      case 1:
        stdout.write("Título: ");
        String titulo = stdin.readLineSync() ?? "";
        stdout.write("Mensaje: ");
        String mensaje = stdin.readLineSync() ?? "";
        print("Tipo (info, advertencia, error): ");
        String tipo = stdin.readLineSync() ?? "info";
        sistema.crearNotificacion(titulo, mensaje, tipo);
        print(" Notificación creada.");
        break;

      case 2:
        sistema.mostrarTodas();
        break;

      case 3:
        stdout.write("Ingrese el índice de la notificación: ");
        int? index = int.tryParse(stdin.readLineSync() ?? "");
        if (index != null) sistema.marcarLeida(index);
        break;

      case 4:
        stdout.write("Ingrese el tipo a filtrar (info, advertencia, error): ");
        String tipo = stdin.readLineSync() ?? "";
        sistema.filtrarPorTipo(tipo);
        break;

      case 5:
        sistema.mostrarEstadisticas();
        break;

      case 0:
        print(" Saliendo del sistema...");
        break;

      default:
        print(" Opción inválida.");
    }
  } while (opcion != 0);
}