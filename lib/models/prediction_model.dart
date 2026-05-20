class PredictionModel {
  final double predictedCredit;
  final double predictedDebit;
  final double predictedSolde;
  final String confidence;
  final String nextMonth;

  const PredictionModel({
    required this.predictedCredit,
    required this.predictedDebit,
    required this.predictedSolde,
    required this.confidence,
    required this.nextMonth,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      predictedCredit: (json['predicted_credit'] as num).toDouble(),
      predictedDebit: (json['predicted_debit'] as num).toDouble(),
      predictedSolde: (json['predicted_solde'] as num).toDouble(),
      confidence: json['confidence'] as String,
      nextMonth: json['next_month'] as String,
    );
  }
}
