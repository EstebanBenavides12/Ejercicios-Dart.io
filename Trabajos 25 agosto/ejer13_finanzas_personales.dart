class Usuario {
  String nombre;
  List<Cuenta> cuentas = [];

  Usuario(this.nombre);

  void agregarCuenta(Cuenta cuenta) => cuentas.add(cuenta);
}

class Cuenta {
  String nombre;
  double saldo;
  List<Transaccion> transacciones = [];

  Cuenta(this.nombre, this.saldo);

  void agregarTransaccion(Transaccion t) {
    transacciones.add(t);
    saldo += t.monto;
  }
}

class Transaccion {
  double monto;
  String categoria;
  DateTime fecha;

  Transaccion(this.monto, this.categoria, this.fecha);
}

void main() {
  var usuario = Usuario("Mauro");
  var cuenta1 = Cuenta("Ahorros", 1000);
  usuario.agregarCuenta(cuenta1);

  var gasto = Transaccion(-200, "Comida", DateTime.now());
  var ingreso = Transaccion(500, "Trabajo", DateTime.now());

  cuenta1.agregarTransaccion(gasto);
  cuenta1.agregarTransaccion(ingreso);

  print("Saldo en ${cuenta1.nombre}: ${cuenta1.saldo}");
}
