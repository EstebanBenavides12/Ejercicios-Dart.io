//Ejercicio 5: Calculadora de Descuentos por Volumen
import 'dart:io';

void main() {
  print("=== CALCULADORA DE DESCUENTOS POR VOLUMEN ===");

  // Solicitar monto de compra
  stdout.write("Ingrese el monto de la compra: ");
  double? montoCompra = double.tryParse(stdin.readLineSync() ?? "");

  if (montoCompra == null || montoCompra <= 0) {
    print("Monto inválido. Debe ser un número mayor que 0.");
    return;
  }

  // Determinar porcentaje de descuento según el rango
  double porcentajeDescuento;
  if (montoCompra <= 50) {
    porcentajeDescuento = 0.0;
  } else if (montoCompra <= 100) {
    porcentajeDescuento = 0.05;
  } else if (montoCompra <= 200) {
    porcentajeDescuento = 0.10;
  } else {
    porcentajeDescuento = 0.15;
  }

  // Calcular descuento y total
  double descuento = montoCompra * porcentajeDescuento;
  double subtotal = montoCompra - descuento;
  double iva = subtotal * 0.19;
  double totalFinal = subtotal + iva;

  // Mostrar resultados
  print("\n=== RESUMEN DE COMPRA ===");
  print("Monto de la compra: \$${montoCompra.toStringAsFixed(2)}");
  print("Descuento aplicado: ${porcentajeDescuento * 100}%");
  print("Ahorro: \$${descuento.toStringAsFixed(2)}");
  print("Subtotal (con descuento): \$${subtotal.toStringAsFixed(2)}");
  print("IVA (19%): \$${iva.toStringAsFixed(2)}");
  print("TOTAL A PAGAR: \$${totalFinal.toStringAsFixed(2)}");

  if (porcentajeDescuento == 0) {
    print(" Tip: Compra más de \$50 para obtener descuentos.");
  } else {
    print(" ¡Has ahorrado \$${descuento.toStringAsFixed(2)} con tu compra!");
  }
}