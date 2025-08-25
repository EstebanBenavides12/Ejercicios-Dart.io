//Ejercicio 4: Generador de QR para WiFi
import 'dart:io';

void main() {
  print("=== GENERADOR DE QR PARA WIFI ===");

  // Solicitar datos de la red
  stdout.write("Ingrese el nombre de la red (SSID): ");
  String ssid = stdin.readLineSync() ?? "";

  print("\nSeleccione el tipo de seguridad:");
  print("1. WPA/WPA2");
  print("2. WEP");
  print("3. Abierta (sin contraseña)");
  stdout.write("Opción: ");
  int? opcionSeguridad = int.tryParse(stdin.readLineSync() ?? "");

  String seguridad;
  String password = "";

  switch (opcionSeguridad) {
    case 1:
      seguridad = "WPA";
      stdout.write("Ingrese la contraseña: ");
      password = stdin.readLineSync() ?? "";
      break;
    case 2:
      seguridad = "WEP";
      stdout.write("Ingrese la contraseña: ");
      password = stdin.readLineSync() ?? "";
      break;
    case 3:
      seguridad = "nopass";
      break;
    default:
      print("Opción inválida.");
      return;
  }

  // Validar seguridad de la contraseña (si no es abierta)
  if (seguridad != "nopass") {
    bool longitudValida = password.length >= 8;
    bool tieneMayuscula = password.contains(RegExp(r'[A-Z]'));
    bool tieneMinuscula = password.contains(RegExp(r'[a-z]'));
    bool tieneNumero = password.contains(RegExp(r'[0-9]'));
    bool tieneEspecial = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    if (!longitudValida ||
        !tieneMayuscula ||
        !tieneMinuscula ||
        !tieneNumero ||
        !tieneEspecial) {
      print("\ Advertencia: La contraseña no es segura.");
      print("Sugerencias:");
      if (!longitudValida) print("- Usa al menos 8 caracteres.");
      if (!tieneMayuscula) print("- Agrega letras mayúsculas (A-Z).");
      if (!tieneMinuscula) print("- Agrega letras minúsculas (a-z).");
      if (!tieneNumero) print("- Incluye números (0-9).");
      if (!tieneEspecial) print("- Agrega caracteres especiales (!, @, #, etc).");
    }
  }

  
}