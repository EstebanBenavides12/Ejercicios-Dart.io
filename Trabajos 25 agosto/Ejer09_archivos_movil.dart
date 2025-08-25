//Ejercicio 9: Gestor de Archivos Móvil
import 'dart:io';

class Archivo {
  String nombre;
  int tamano; // en KB
  String tipo; // ej: txt, jpg, mp3
  DateTime fechaCreacion;
  String ruta;

  Archivo(this.nombre, this.tamano, this.tipo, this.ruta)
      : fechaCreacion = DateTime.now();

  @override
  String toString() {
    return "$nombre.$tipo | ${tamano}KB | Creado: ${fechaCreacion.toLocal()} | Ruta: $ruta";
  }
}

class GestorArchivos {
  List<Archivo> archivos = [];

  void agregarArchivo(Archivo archivo) {
    archivos.add(archivo);
    print(" Archivo '${archivo.nombre}.${archivo.tipo}' agregado.");
  }

  void listarArchivos() {
    if (archivos.isEmpty) {
      print(" No hay archivos.");
      return;
    }
    print("\n=== LISTA DE ARCHIVOS ===");
    for (var a in archivos) {
      print(a);
    }
  }

  void buscarPorNombre(String nombre) {
    var encontrados = archivos.where((a) => a.nombre.toLowerCase().contains(nombre.toLowerCase())).toList();
    if (encontrados.isEmpty) {
      print(" No se encontraron archivos con '$nombre'.");
      return;
    }
    print("\n=== Resultados de búsqueda por nombre '$nombre' ===");
    for (var a in encontrados) {
      print(a);
    }
  }

  void buscarPorTipo(String tipo) {
    var encontrados = archivos.where((a) => a.tipo.toLowerCase() == tipo.toLowerCase()).toList();
    if (encontrados.isEmpty) {
      print(" No se encontraron archivos de tipo '$tipo'.");
      return;
    }
    print("\n=== Archivos tipo '$tipo' ===");
    for (var a in encontrados) {
      print(a);
    }
  }

  void calcularEspacioUsado() {
    int total = archivos.fold(0, (suma, a) => suma + a.tamano);
    print(" Espacio usado: ${total}KB (${(total / 1024).toStringAsFixed(2)} MB)");
  }

  void organizarPorFecha() {
    archivos.sort((a, b) => a.fechaCreacion.compareTo(b.fechaCreacion));
    print(" Archivos organizados por fecha de creación (más antiguos primero).");
  }

  void organizarPorTamano() {
    archivos.sort((a, b) => a.tamano.compareTo(b.tamano));
    print("Archivos organizados por tamaño (de menor a mayor).");
  }

  void transferirArchivo(String nombre, String nuevaRuta) {
    var archivo = archivos.firstWhere(
      (a) => a.nombre.toLowerCase() == nombre.toLowerCase(),
      orElse: () => null as Archivo,
    );
    if (archivo == null) {
      print(" No se encontró el archivo '$nombre'.");
      return;
    }
    archivo.ruta = nuevaRuta;
    print("Archivo '${archivo.nombre}.${archivo.tipo}' transferido a: $nuevaRuta");
  }
}

void main() {
  GestorArchivos gestor = GestorArchivos();
  int opcion;

  do {
    print("\n=== GESTOR DE ARCHIVOS MÓVIL ===");
    print("1. Agregar archivo");
    print("2. Listar archivos");
    print("3. Buscar por nombre");
    print("4. Buscar por tipo");
    print("5. Calcular espacio usado");
    print("6. Organizar por fecha");
    print("7. Organizar por tamaño");
    print("8. Transferir archivo entre carpetas");
    print("0. Salir");
    stdout.write("Opción: ");
    opcion = int.tryParse(stdin.readLineSync() ?? "") ?? -1;

    switch (opcion) {
      case 1:
        stdout.write("Nombre del archivo (sin extensión): ");
        String nombre = stdin.readLineSync() ?? "";
        stdout.write("Tamaño en KB: ");
        int? tamano = int.tryParse(stdin.readLineSync() ?? "");
        stdout.write("Tipo (ej: txt, jpg, mp3): ");
        String tipo = stdin.readLineSync() ?? "";
        stdout.write("Ruta (ej: /Documentos): ");
        String ruta = stdin.readLineSync() ?? "";

        if (tamano == null) {
          print(" Tamaño inválido.");
          break;
        }

        gestor.agregarArchivo(Archivo(nombre, tamano, tipo, ruta));
        break;

      case 2:
        gestor.listarArchivos();
        break;

      case 3:
        stdout.write("Ingrese el nombre a buscar: ");
        String nombre = stdin.readLineSync() ?? "";
        gestor.buscarPorNombre(nombre);
        break;

      case 4:
        stdout.write("Ingrese el tipo a buscar: ");
        String tipo = stdin.readLineSync() ?? "";
        gestor.buscarPorTipo(tipo);
        break;

      case 5:
        gestor.calcularEspacioUsado();
        break;

      case 6:
        gestor.organizarPorFecha();
        gestor.listarArchivos();
        break;

      case 7:
        gestor.organizarPorTamano();
        gestor.listarArchivos();
        break;

      case 8:
        stdout.write("Ingrese el nombre del archivo a transferir: ");
        String nombre = stdin.readLineSync() ?? "";
        stdout.write("Ingrese la nueva ruta: ");
        String nuevaRuta = stdin.readLineSync() ?? "";
        gestor.transferirArchivo(nombre, nuevaRuta);
        break;

      case 0:
        print(" Cerrando gestor de archivos...");
        break;

      default:
        print(" Opción inválida.");
    }
  } while (opcion != 0);
}