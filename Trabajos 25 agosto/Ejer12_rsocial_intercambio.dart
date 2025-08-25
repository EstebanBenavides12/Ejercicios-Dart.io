//Ejercicio 12: Red Social de Intercambio de Libros
import 'dart:io';

// Clase Usuario
class Usuario {
  String nombre;
  List<Libro> librosPublicados = [];
  List<Intercambio> intercambios = [];
  double reputacion = 0.0;
  int valoracionesRecibidas = 0;

  Usuario({required this.nombre});

  void publicarLibro(Libro libro) {
    librosPublicados.add(libro);
    print(" Libro '${libro.titulo}' publicado por $nombre.");
  }

  void solicitarIntercambio(Libro libro, Usuario propietario) {
    if (propietario == this) {
      print(" No puedes intercambiar tus propios libros.");
      return;
    }
    Intercambio nuevo = Intercambio(libro: libro, solicitante: this, propietario: propietario);
    intercambios.add(nuevo);
    propietario.intercambios.add(nuevo);
    print(" Solicitud de intercambio enviada a ${propietario.nombre} por el libro '${libro.titulo}'.");
  }

  void calificarUsuario(double calificacion) {
    reputacion = ((reputacion * valoracionesRecibidas) + calificacion) / (valoracionesRecibidas + 1);
    valoracionesRecibidas += 1;
  }

  void mostrarLibros() {
    if (librosPublicados.isEmpty) {
      print(" No tienes libros publicados.");
      return;
    }
    print(" Libros de $nombre:");
    for (var libro in librosPublicados) {
      print("- ${libro.titulo} por ${libro.autor}");
    }
  }
}

// Clase Libro
class Libro {
  String titulo;
  String autor;
  String genero;

  Libro({required this.titulo, required this.autor, required this.genero});
}

// Clase Intercambio
class Intercambio {
  Libro libro;
  Usuario solicitante;
  Usuario propietario;
  bool completado = false;
  double calificacionSolicitante = 0.0;
  double calificacionPropietario = 0.0;

  Intercambio({required this.libro, required this.solicitante, required this.propietario});

  void completarIntercambio() {
    completado = true;
    print(" Intercambio completado: '${libro.titulo}' de ${propietario.nombre} a ${solicitante.nombre}");
  }

  void calificar(double calSolicitante, double calPropietario) {
    calificacionSolicitante = calSolicitante;
    calificacionPropietario = calPropietario;
    solicitante.calificarUsuario(calPropietario);
    propietario.calificarUsuario(calSolicitante);
    print(" Calificaciones registradas: ${solicitante.nombre} (${calPropietario}), ${propietario.nombre} (${calSolicitante})");
  }
}

// Función principal interactiva
void main() {
  List<Usuario> usuarios = [];
  bool salir = false;

  print("=== RED SOCIAL DE INTERCAMBIO DE LIBROS ===");

  // Crear usuario principal
  stdout.write("Ingresa tu nombre: ");
  String nombre = stdin.readLineSync() ?? "Usuario";
  Usuario usuarioActual = Usuario(nombre: nombre);
  usuarios.add(usuarioActual);

  while (!salir) {
    print("\nOpciones:");
    print("1. Publicar libro");
    print("2. Ver libros de todos los usuarios");
    print("3. Solicitar intercambio");
    print("4. Completar intercambio");
    print("5. Mostrar reputación");
    print("6. Salir");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        stdout.write("Título del libro: ");
        String titulo = stdin.readLineSync() ?? "";
        stdout.write("Autor: ");
        String autor = stdin.readLineSync() ?? "";
        stdout.write("Género: ");
        String genero = stdin.readLineSync() ?? "";
        usuarioActual.publicarLibro(Libro(titulo: titulo, autor: autor, genero: genero));
        break;

      case "2":
        print(" Libros disponibles:");
        for (var usuario in usuarios) {
          if (usuario.librosPublicados.isNotEmpty) {
            print("\nUsuario: ${usuario.nombre}");
            usuario.mostrarLibros();
          }
        }
        break;

      case "3":
        print("\nLibros disponibles para intercambio:");
        List<Libro> librosDisponibles = [];
        List<Usuario> propietarios = [];
        for (var usuario in usuarios) {
          for (var libro in usuario.librosPublicados) {
            if (usuario != usuarioActual) {
              librosDisponibles.add(libro);
              propietarios.add(usuario);
            }
          }
        }
        if (librosDisponibles.isEmpty) {
          print(" No hay libros disponibles por ahora.");
          break;
        }
        for (int i = 0; i < librosDisponibles.length; i++) {
          print("${i + 1}. '${librosDisponibles[i].titulo}' por ${librosDisponibles[i].autor} (Propietario: ${propietarios[i].nombre})");
        }
        stdout.write("Número del libro a solicitar: ");
        int? num = int.tryParse(stdin.readLineSync() ?? "");
        if (num != null && num >= 1 && num <= librosDisponibles.length) {
          usuarioActual.solicitarIntercambio(librosDisponibles[num - 1], propietarios[num - 1]);
        } else {
          print("Opción inválida");
        }
        break;

      case "4":
        if (usuarioActual.intercambios.isEmpty) {
          print(" No tienes intercambios pendientes.");
          break;
        }
        print("\nTus intercambios:");
        for (int i = 0; i < usuarioActual.intercambios.length; i++) {
          var inter = usuarioActual.intercambios[i];
          print("${i + 1}. Libro: '${inter.libro.titulo}' | Completado: ${inter.completado}");
        }
        stdout.write("Número de intercambio a completar: ");
        int? numInt = int.tryParse(stdin.readLineSync() ?? "");
        if (numInt != null && numInt >= 1 && numInt <= usuarioActual.intercambios.length) {
          var intercambio = usuarioActual.intercambios[numInt - 1];
          intercambio.completarIntercambio();
          stdout.write("Calificación al propietario (1-5): ");
          double calProp = double.tryParse(stdin.readLineSync() ?? "0") ?? 0;
          stdout.write("Calificación al solicitante (1-5): ");
          double calSol = double.tryParse(stdin.readLineSync() ?? "0") ?? 0;
          intercambio.calificar(calSol, calProp);
        } else {
          print("Intercambio inválido");
        }
        break;

      case "5":
        print(" Reputación de ${usuarioActual.nombre}: ${usuarioActual.reputacion.toStringAsFixed(2)}");
        break;

      case "6":
        print(" Gracias por usar la red social de intercambio de libros");
        salir = true;
        break;

      default:
        print("Opción inválida");
    }
  }
}