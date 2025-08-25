// Ejercicio 1: Calculadora de Propinas para Delivery

import 'dart:io';

void main() {
  // Entrada: valor del pedido
  stdout.write("Ingrese el valor del pedido: ");
  double valorPedido = double.parse(stdin.readLineSync()!);

  // Entrada: tipo de servicio
  stdout.write("Ingrese el tipo de servicio (comida/farmacia/supermercado): ");
  String tipoServicio = stdin.readLineSync()!.toLowerCase();

  // Entrada: calidad del servicio
  stdout.write("Ingrese la calidad del servicio (excelente/bueno/regular): ");
  String calidad = stdin.readLineSync()!.toLowerCase();

  // Definir porcentaje de propina según calidad
  double porcentajePropina;
  switch (calidad) {
    case "excelente":
      porcentajePropina = 0.20;
      break;
    case "bueno":
      porcentajePropina = 0.15;
      break;
    case "regular":
      porcentajePropina = 0.10;
      break;
    default:
      print(" Calidad no válida, se asumirá 'regular'.");
      porcentajePropina = 0.10;
  }

  // Cálculo de propina y total
  double propina = valorPedido * porcentajePropina;
  double totalPagar = valorPedido + propina;

  // Mensaje personalizado
  String mensaje;
  if (calidad == "excelente") {
    mensaje = "¡Gracias por su confianza! El repartidor hizo un trabajo sobresaliente.";
  } else if (calidad == "bueno") {
    mensaje = "El servicio fue bueno, gracias por apoyar al repartidor.";
  } else {
    mensaje = "El servicio fue aceptable, siempre se aprecia la propina.";
  }

  // Salida
  print("\n--- Resumen del pedido ---");
  print("Tipo de servicio: $tipoServicio");
  print("Valor del pedido: \$${valorPedido.toStringAsFixed(2)}");
  print("Propina sugerida: \$${propina.toStringAsFixed(2)}");
  print("Total a pagar: \$${totalPagar.toStringAsFixed(2)}");
  print("Mensaje: $mensaje");
}
