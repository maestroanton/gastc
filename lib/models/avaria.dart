class Avaria {
  int? id; // optional for auto-increment
  String dataAvaria;
  String utilidade;
  String descricao;
  int valorAvaria;

  Avaria({
    this.id,
    required this.dataAvaria,
    required this.utilidade,
    required this.descricao,
    required this.valorAvaria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataAvaria': dataAvaria,
      'utilidade': utilidade,
      'descricao': descricao,
      'valorAvaria': valorAvaria,
    };
  }

  factory Avaria.fromMap(Map<String, dynamic> map) {
    return Avaria(
      id: map['id'],
      dataAvaria: map['dataAvaria'],
      utilidade: map['utilidade'],
      descricao: map['descricao'],
      valorAvaria: map['valorAvaria'],
    );
  }
}
