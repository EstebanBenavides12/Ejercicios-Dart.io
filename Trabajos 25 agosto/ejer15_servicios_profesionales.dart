class Cliente {
  String nombre;
  List<Solicitud> solicitudes = [];

  Cliente(this.nombre);

  void solicitarServicio(Servicio servicio, Prestador prestador) {
    var solicitud = Solicitud(this, prestador, servicio);
    solicitudes.add(solicitud);
    prestador.solicitudes.add(solicitud);
  }
}

class Prestador {
  String nombre;
  List<Solicitud> solicitudes = [];

  Prestador(this.nombre);
}

class Servicio {
  String nombre;
  double precio;

  Servicio(this.nombre, this.precio);
}

class Solicitud {
  Cliente cliente;
  Prestador prestador;
  Servicio servicio;
  String estado = "Pendiente";

  Solicitud(this.cliente, this.prestador, this.servicio);

  void aceptar() => estado = "Aceptada";
  void rechazar() => estado = "Rechazada";
}

void main() {
  var cliente = Cliente("Mauro");
  var prestador = Prestador("Juan");
  var servicio = Servicio("Reparación de PC", 150);

  cliente.solicitarServicio(servicio, prestador);

  var solicitud = prestador.solicitudes.first;
  solicitud.aceptar();

  print("Solicitud de ${cliente.nombre} para ${servicio.nombre}: ${solicitud.estado}");
}
