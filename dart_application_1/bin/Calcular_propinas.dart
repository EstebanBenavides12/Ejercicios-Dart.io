// calculadora_propinas.dart
// Ejercicio 1: Calculadora de Propinas para Delivery
// Autor: Esteban Benavides (o tu nombre)
// Descripción: Calcula la propina sugerida y el total a pagar según el tipo de servicio y calidad.

import 'dart:io';

void main() {
  print("===== Calculadora de Propinas para Delivery =====");

  // 1️⃣ Solicitar valor del pedido
  double valorPedido = 0;
  while (valorPedido <= 0) {
    stdout.write("Ingrese el valor del pedido: ");
    String? input = stdin.readLineSync();
    if (input != null && double.tryParse(input) != null) {
      valorPedido = double.parse(input);
      if (valorPedido <= 0) {
        print("❌ El valor debe ser mayor que cero.");
      }
    } else {
      print("❌ Entrada inválida. Ingrese un número.");
    }
  }

  // 2️⃣ Seleccionar tipo de servicio
  print("\nSeleccione el tipo de servicio:");
  print("1. Comida");
  print("2. Farmacia");
  print("3. Supermercado");

  String tipoServicio = "";
  while (tipoServicio.isEmpty) {
    stdout.write("Opción: ");
    String? opcion = stdin.readLineSync();
    switch (opcion) {
      case "1":
        tipoServicio = "Comida";
        break;
      case "2":
        tipoServicio = "Farmacia";
        break;
      case "3":
        tipoServicio = "Supermercado";
        break;
      default:
        print("❌ Opción inválida. Intente de nuevo.");
    }
  }

  // 3️⃣ Seleccionar calidad del servicio
  print("\nSeleccione la calidad del servicio:");
  print("1. Excelente (20%)");
  print("2. Bueno (15%)");
  print("3. Regular (10%)");

  double porcentajePropina = 0;
  String mensajePersonalizado = "";

  while (porcentajePropina == 0) {
    stdout.write("Opción: ");
    String? opcion = stdin.readLineSync();
    switch (opcion) {
      case "1":
        porcentajePropina = 0.20;
        mensajePersonalizado = "¡Gracias por un servicio excelente! 🌟";
        break;
      case "2":
        porcentajePropina = 0.15;
        mensajePersonalizado = "Buen trabajo, gracias por su entrega.";
        break;
      case "3":
        porcentajePropina = 0.10;
        mensajePersonalizado = "Gracias por cumplir con el servicio.";
        break;
      default:
        print("❌ Opción inválidsa. Intente de nuevo.");
    }
  }

  // 4️⃣ Calcular propina y total
  double propina = valorPedido * porcentajePropina;
  double totalPagar = valorPedido + propina;

  // 5️⃣ Mostrar resultados
  print("\n===== RESULTADOS =====");
  print("Tipo de servicio: $tipoServicio");
  print("Valor del pedido: \$${valorPedido.toStringAsFixed(2)}");
  print("Propina sugerida: \$${propina.toStringAsFixed(2)}");
  print("Total a pagar: \$${totalPagar.toStringAsFixed(2)}");
  print("Mensaje: $mensajePersonalizado");
}
