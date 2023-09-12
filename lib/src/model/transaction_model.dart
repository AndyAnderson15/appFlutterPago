class TransactionModel {
  final String transactionId;
  final String fecha;
  final String monto;
  final String tipoPago;
  final String estado;

  TransactionModel({
    required this.transactionId,
    required this.fecha,
    required this.monto,
    required this.tipoPago,
    required this.estado,
  });

  // Constructor para convertir un mapa JSON en una instancia de TransactionModel
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'],
      fecha: json['fecha'],
      monto: json['monto'],
      tipoPago: json['tipoPago'],
      estado: json['estado'],
    );
  }

  // Método para convertir una instancia de TransactionModel en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'fecha': fecha,
      'monto': monto,
      'tipoPago': tipoPago,
      'estado': estado,
    };
  }
}
