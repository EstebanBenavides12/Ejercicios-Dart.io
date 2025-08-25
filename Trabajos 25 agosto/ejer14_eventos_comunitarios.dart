class Organizador {
  String nombre;
  List<Evento> eventos = [];

  Organizador(this.nombre);

  void crearEvento(Evento evento) => eventos.add(evento);
}

class Participante {
  String nombre;

  Participante(this.nombre);
}

class Evento {
  String titulo;
  String categoria;
  List<Participante> asistentes = [];

  Evento(this.titulo, this.categoria);

  void registrarParticipante(Participante p) {
    asistentes.add(p);
  }
}

void main() {
  var organizador = Organizador("Carlos");
  var evento = Evento("Concierto de Rock", "Música");
  organizador.crearEvento(evento);

  var participante1 = Participante("Mauro");
  evento.registrarParticipante(participante1);

  print("Evento: ${evento.titulo}, Asistentes: ${evento.asistentes.length}");
}
