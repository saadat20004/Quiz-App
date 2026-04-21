class HistoryModel {
  final String quizId;
  final String quizTitle;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double percentage;
  final DateTime completedAt;

  const HistoryModel({
    required this.quizId,
    required this.quizTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.percentage,
    required this.completedAt,
  });

  /// 🔹 Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'quizTitle': quizTitle,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'percentage': percentage,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  /// 🔹 Convert from JSON
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      quizId: json['quizId'],
      quizTitle: json['quizTitle'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      wrongAnswers: json['wrongAnswers'],
      percentage: (json['percentage'] as num).toDouble(),
      completedAt: DateTime.parse(json['completedAt']),
    );
  }
}