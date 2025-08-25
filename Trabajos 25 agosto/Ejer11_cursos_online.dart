//Ejercicio 11: Plataforma de Cursos Online Móvil
import 'dart:io';

// Clases base (igual que antes)
class Usuario {
  String nombre;
  List<Curso> cursosInscritos = [];
  Map<Curso, Progreso> progresoCursos = {};

  Usuario({required this.nombre});

  void inscribirseCurso(Curso curso) {
    if (!cursosInscritos.contains(curso)) {
      cursosInscritos.add(curso);
      progresoCursos[curso] = Progreso(curso: curso);
      print(" Te has inscrito en '${curso.titulo}'");
    } else {
      print(" Ya estás inscrito en '${curso.titulo}'");
    }
  }

  void verLeccion(Curso curso, int numeroLeccion) {
    if (!cursosInscritos.contains(curso)) {
      print(" Debes inscribirte primero en '${curso.titulo}'");
      return;
    }
    if (numeroLeccion < 1 || numeroLeccion > curso.lecciones.length) {
      print(" Lección inválida");
      return;
    }
    Leccion leccion = curso.lecciones[numeroLeccion - 1];
    print(" Leyendo lección: ${leccion.titulo}\n${leccion.contenido}\n");
    progresoCursos[curso]?.marcarLeccionCompletada(leccion);
  }

  void mostrarProgreso(Curso curso) {
    if (!cursosInscritos.contains(curso)) {
      print(" No estás inscrito en '${curso.titulo}'");
      return;
    }
    double porcentaje = progresoCursos[curso]?.porcentajeCompletado() ?? 0;
    print(" Progreso en '${curso.titulo}': ${porcentaje.toStringAsFixed(1)}%");
  }

  void obtenerCertificado(Curso curso) {
    if ((progresoCursos[curso]?.porcentajeCompletado() ?? 0) >= 100) {
      print(" ¡Felicidades! Has completado '${curso.titulo}' y obtenido tu certificado.");
    } else {
      print(" Aún no completaste todas las lecciones de '${curso.titulo}'");
    }
  }
}

class Curso {
  String titulo;
  List<Leccion> lecciones = [];
  double calificacionPromedio = 0.0;

  Curso({required this.titulo});

  void agregarLeccion(Leccion leccion) {
    lecciones.add(leccion);
  }

  void calificarCurso(double calificacion) {
    calificacionPromedio = (calificacionPromedio + calificacion) / 2;
  }
}

class Leccion {
  String titulo;
  String contenido;

  Leccion({required this.titulo, required this.contenido});
}

class Progreso {
  Curso curso;
  Set<Leccion> leccionesCompletadas = {};

  Progreso({required this.curso});

  void marcarLeccionCompletada(Leccion leccion) {
    leccionesCompletadas.add(leccion);
  }

  double porcentajeCompletado() {
    if (curso.lecciones.isEmpty) return 0.0;
    return (leccionesCompletadas.length / curso.lecciones.length) * 100;
  }
}

// Función principal interactiva
void main() {
  // Crear cursos y lecciones
  Curso cursoDart = Curso(titulo: "Dart para Principiantes");
  cursoDart.agregarLeccion(Leccion(titulo: "Introducción a Dart", contenido: "Variables, tipos y operadores"));
  cursoDart.agregarLeccion(Leccion(titulo: "Funciones y Clases", contenido: "Funciones, clases y objetos"));
  cursoDart.agregarLeccion(Leccion(titulo: "Programación Asíncrona", contenido: "Futures, async/await"));

  Curso cursoFlutter = Curso(titulo: "Flutter Básico");
  cursoFlutter.agregarLeccion(Leccion(titulo: "Widgets y Layouts", contenido: "Widgets básicos y diseños"));
  cursoFlutter.agregarLeccion(Leccion(titulo: "Navegación y Estado", contenido: "Rutas y manejo de estado"));

  List<Curso> cursosDisponibles = [cursoDart, cursoFlutter];

  // Crear usuario
  stdout.write("Ingresa tu nombre: ");
  String nombreUsuario = stdin.readLineSync() ?? "Usuario";
  Usuario usuario = Usuario(nombre: nombreUsuario);

  bool salir = false;

  while (!salir) {
    print("\n=== PLATAFORMA DE CURSOS ONLINE ===");
    print("1. Ver cursos disponibles");
    print("2. Inscribirse en un curso");
    print("3. Ver lecciones de un curso");
    print("4. Mostrar progreso de un curso");
    print("5. Obtener certificado de un curso");
    print("6. Salir");
    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        print(" Cursos disponibles:");
        for (int i = 0; i < cursosDisponibles.length; i++) {
          print("${i + 1}. ${cursosDisponibles[i].titulo}");
        }
        break;

      case "2":
        print("\nElige el curso para inscribirte:");
        for (int i = 0; i < cursosDisponibles.length; i++) {
          print("${i + 1}. ${cursosDisponibles[i].titulo}");
        }
        stdout.write("Número de curso: ");
        int? numCurso = int.tryParse(stdin.readLineSync() ?? "");
        if (numCurso != null && numCurso >= 1 && numCurso <= cursosDisponibles.length) {
          usuario.inscribirseCurso(cursosDisponibles[numCurso - 1]);
        } else {
          print("Opción inválida");
        }
        break;

      case "3":
        if (usuario.cursosInscritos.isEmpty) {
          print(" No estás inscrito en ningún curso");
          break;
        }
        print("\nElige el curso para ver lecciones:");
        for (int i = 0; i < usuario.cursosInscritos.length; i++) {
          print("${i + 1}. ${usuario.cursosInscritos[i].titulo}");
        }
        stdout.write("Número de curso: ");
        int? cursoSeleccionado = int.tryParse(stdin.readLineSync() ?? "");
        if (cursoSeleccionado != null &&
            cursoSeleccionado >= 1 &&
            cursoSeleccionado <= usuario.cursosInscritos.length) {
          Curso curso = usuario.cursosInscritos[cursoSeleccionado - 1];
          print("\nLecciones de '${curso.titulo}':");
          for (int j = 0; j < curso.lecciones.length; j++) {
            print("${j + 1}. ${curso.lecciones[j].titulo}");
          }
          stdout.write("Número de lección para ver: ");
          int? leccionNum = int.tryParse(stdin.readLineSync() ?? "");
          if (leccionNum != null) {
            usuario.verLeccion(curso, leccionNum);
          } else {
            print("Lección inválida");
          }
        } else {
          print("Curso inválido");
        }
        break;

      case "4":
        if (usuario.cursosInscritos.isEmpty) {
          print(" No estás inscrito en ningún curso");
          break;
        }
        print("\nElige el curso para ver el progreso:");
        for (int i = 0; i < usuario.cursosInscritos.length; i++) {
          print("${i + 1}. ${usuario.cursosInscritos[i].titulo}");
        }
        stdout.write("Número de curso: ");
        int? cursoProg = int.tryParse(stdin.readLineSync() ?? "");
        if (cursoProg != null &&
            cursoProg >= 1 &&
            cursoProg <= usuario.cursosInscritos.length) {
          usuario.mostrarProgreso(usuario.cursosInscritos[cursoProg - 1]);
        } else {
          print("Curso inválido");
        }
        break;

      case "5":
        if (usuario.cursosInscritos.isEmpty) {
          print(" No estás inscrito en ningún curso");
          break;
        }
        print("\nElige el curso para obtener el certificado:");
        for (int i = 0; i < usuario.cursosInscritos.length; i++) {
          print("${i + 1}. ${usuario.cursosInscritos[i].titulo}");
        }
        stdout.write("Número de curso: ");
        int? cursoCert = int.tryParse(stdin.readLineSync() ?? "");
        if (cursoCert != null &&
            cursoCert >= 1 &&
            cursoCert <= usuario.cursosInscritos.length) {
          usuario.obtenerCertificado(usuario.cursosInscritos[cursoCert - 1]);
        } else {
          print("Curso inválido");
        }
        break;

      case "6":
        print(" Gracias por usar la plataforma, ¡hasta luego!");
        salir = true;
        break;

      default:
        print("Opción inválida");
        break;
    }
  }
}