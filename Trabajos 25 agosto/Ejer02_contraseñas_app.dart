//Ejercicio 2: Verificador de Contraseñas Seguras
import 'dart:io';

void main() {
  print("=== VERIFICADOR DE CONTRASEÑAS SEGURAS ===");

  // Solicitar contraseña al usuario
  stdout.write("Ingrese una contraseña: ");
  String password = stdin.readLineSync() ?? "";

  // Validaciones
  bool tieneMayuscula = password.contains(RegExp(r'[A-Z]'));
  bool tieneMinuscula = password.contains(RegExp(r'[a-z]'));
  bool tieneNumero = password.contains(RegExp(r'[0-9]'));
  bool tieneEspecial = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  bool longitudValida = password.length >= 8;

  // Calcular puntaje
  int puntaje = 0;
  if (longitudValida) puntaje++;
  if (tieneMayuscula) puntaje++;
  if (tieneMinuscula) puntaje++;
  if (tieneNumero) puntaje++;
  if (tieneEspecial) puntaje++;

  String nivelSeguridad;
  switch (puntaje) {
    case 5:
      nivelSeguridad = "Muy fuerte";
      break;
    case 4:
      nivelSeguridad = "Fuerte";
      break;
    case 3:
      nivelSeguridad = "Media";
      break;
    default:
      nivelSeguridad = "Débil";
  }

  // Mostrar resultados
  print("\n=== RESULTADO DE LA EVALUACIÓN ===");
  print("Contraseña ingresada: $password");
  print("Nivel de seguridad: $nivelSeguridad");

  // Sugerencias de mejora
  print("\nSugerencias de mejora:");
  if (!longitudValida) print("- Usa al menos 8 caracteres.");
  if (!tieneMayuscula) print("- Agrega letras mayúsculas (A-Z).");
  if (!tieneMinuscula) print("- Agrega letras minúsculas (a-z).");
  if (!tieneNumero) print("- Incluye números (0-9).");
  if (!tieneEspecial) print("- Agrega caracteres especiales (!, @, #, etc).");

  if (puntaje == 5) {
    print(" ¡Excelente! Tu contraseña es muy segura.");
  }
}