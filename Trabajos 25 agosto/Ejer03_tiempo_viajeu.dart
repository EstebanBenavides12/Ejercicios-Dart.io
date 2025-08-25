//Ejercicio 3: Calculadora de Tiempo de Viaje Urbano
import 'dart:io';

void main() {
  print("=== CALCULADORA DE TIEMPO DE VIAJE URBANO ===");

  // Solicitar origen y destino
  stdout.write("Ingrese el lugar de origen: ");
  String origen = stdin.readLineSync() ?? "";
  stdout.write("Ingrese el lugar de destino: ");
  String destino = stdin.readLineSync() ?? "";

  // Solicitar distancia
  stdout.write("Ingrese la distancia en km: ");
  double? distancia = double.tryParse(stdin.readLineSync() ?? "");
  if (distancia == null || distancia <= 0) {
    print("Distancia inválida. Debe ser un número mayor que 0.");
    return;
  }

  // Seleccionar medio de transporte
  print("\nSeleccione el medio de transporte:");
  print("1. A pie");
  print("2. Bicicleta");
  print("3. Carro");
  print("4. Transporte público");
  stdout.write("Opción: ");
  int? opcionTransporte = int.tryParse(stdin.readLineSync() ?? "");

  String medioTransporte;
  double velocidad; // km/h
  double costoPorKm;

  switch (opcionTransporte) {
    case 1:
      medioTransporte = "A pie";
      velocidad = 5;
      costoPorKm = 0;
      break;
    case 2:
      medioTransporte = "Bicicleta";
      velocidad = 15;
      costoPorKm = 0;
      break;
    case 3:
      medioTransporte = "Carro";
      velocidad = 40;
      costoPorKm = 0.50; // costo estimado combustible
      break;
    case 4:
      medioTransporte = "Transporte público";
      velocidad = 25;
      costoPorKm = 0.30; // tarifa promedio
      break;
    default:
      print("Opción inválida.");
      return;
  }

  // Seleccionar hora del día
  print("\nSeleccione la hora del día:");
  print("1. Hora pico (más tráfico)");
  print("2. Horario normal");
  stdout.write("Opción: ");
  int? opcionHora = int.tryParse(stdin.readLineSync() ?? "");

  double factorTiempo;
  switch (opcionHora) {
    case 1:
      factorTiempo = 1.5; // se tarda 50% más
      break;
    case 2:
      factorTiempo = 1.0;
      break;
    default:
      print("Opción inválida.");
      return;
  }

  // Calcular tiempo estimado
  double tiempoHoras = (distancia / velocidad) * factorTiempo;
  double tiempoMinutos = tiempoHoras * 60;

  // Calcular costo
  double costoTotal = distancia * costoPorKm;

  // Mostrar resultados
  print("\n=== RESUMEN DE VIAJE ===");
  print("Origen: $origen");
  print("Destino: $destino");
  print("Distancia: ${distancia.toStringAsFixed(2)} km");
  print("Medio de transporte: $medioTransporte");
  print("Tiempo estimado: ${tiempoMinutos.toStringAsFixed(1)} minutos");
  print("Costo total: \$${costoTotal.toStringAsFixed(2)}");

  if (opcionHora == 1) {
    print(" Ten en cuenta que es hora pico, el tráfico puede ser pesado.");
  } else {
    print(" Viaje en horario normal, tráfico moderado.");
  }
}