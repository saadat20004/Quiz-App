import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../admin/providers/quiz_management_provider.dart';
import '../../../shared/models/quiz_model.dart';
import '../../../shared/models/result_model.dart';
import '../../../shared/models/history_model.dart';

class QuizProvider extends ChangeNotifier {
  /// ================= STATE =================

  QuizModel? _selectedQuiz;
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};

  final List<HistoryModel> _history = [];

  bool _isResultSaved = false;

  /// TIMER
  Timer? _timer;
  int _remainingSeconds = 0;

  /// STORAGE KEY
  static const String _historyKey = 'quiz_history';

  /// ================= GETTERS =================

  QuizModel? get selectedQuiz => _selectedQuiz;

  int get currentQuestionIndex => _currentQuestionIndex;

  Map<int, int> get selectedAnswers => _selectedAnswers;

  List<HistoryModel> get history => List.unmodifiable(_history);

  bool get hasQuiz => _selectedQuiz != null;

  int get totalQuestions => _selectedQuiz?.questions.length ?? 0;

  int? get selectedAnswerForCurrentQuestion =>
      _selectedAnswers[_currentQuestionIndex];

  bool get isFirstQuestion => _currentQuestionIndex == 0;

  bool get isLastQuestion {
    if (_selectedQuiz == null) return true;
    return _currentQuestionIndex == _selectedQuiz!.questions.length - 1;
  }

  double get progress {
    if (_selectedQuiz == null || _selectedQuiz!.questions.isEmpty) return 0;
    return (_currentQuestionIndex + 1) / _selectedQuiz!.questions.length;
  }

  /// TIMER GETTERS
  int get remainingSeconds => _remainingSeconds;

  bool get isTimeUp => _remainingSeconds <= 0;

  /// ================= LOAD QUIZ =================

  void loadQuizById(String quizId, List<QuizModel> quizzes) {
    try {
      _selectedQuiz = quizzes.firstWhere((q) => q.id == quizId);

      _currentQuestionIndex = 0;
      _selectedAnswers.clear();
      _isResultSaved = false;

      _startTimer();

      notifyListeners();
    } catch (_) {
      _selectedQuiz = null;
      notifyListeners();
    }
  }

  /// ================= ANSWER =================

  void selectAnswer(int answerIndex) {
    _selectedAnswers[_currentQuestionIndex] = answerIndex;
    notifyListeners();
  }

  /// ================= NAVIGATION =================

  void nextQuestion() {
    if (_selectedQuiz == null) return;

    if (_currentQuestionIndex < _selectedQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  /// ================= RESULT =================

  ResultModel calculateResult() {
    if (_selectedQuiz == null) {
      return const ResultModel(
        totalQuestions: 0,
        correctAnswers: 0,
        wrongAnswers: 0,
        percentage: 0,
      );
    }

    int correct = 0;

    for (int i = 0; i < _selectedQuiz!.questions.length; i++) {
      final selected = _selectedAnswers[i];
      final correctIndex = _selectedQuiz!.questions[i].correctAnswerIndex;

      if (selected != null && selected == correctIndex) {
        correct++;
      }
    }

    final int total = _selectedQuiz!.questions.length;
    final int wrong = total - correct;
    final double percentage = total == 0 ? 0 : (correct / total) * 100;

    final result = ResultModel(
      totalQuestions: total,
      correctAnswers: correct,
      wrongAnswers: wrong,
      percentage: percentage,
    );

    /// Prevent duplicate saves
    if (!_isResultSaved) {
      _saveAttempt(result);
      _isResultSaved = true;
    }

    return result;
  }

  /// ================= HISTORY =================

  void _saveAttempt(ResultModel result) {
    if (_selectedQuiz == null) return;

    final historyItem = HistoryModel(
      quizId: _selectedQuiz!.id,
      quizTitle: _selectedQuiz!.title,
      totalQuestions: result.totalQuestions,
      correctAnswers: result.correctAnswers,
      wrongAnswers: result.wrongAnswers,
      percentage: result.percentage,
      completedAt: DateTime.now(),
    );

    _history.insert(0, historyItem);

    _persistHistory(); // 🔥 SAVE LOCALLY

    notifyListeners();
  }

  /// ================= LOCAL STORAGE =================

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedList = prefs.getStringList(_historyKey);

    if (storedList != null) {
      _history.clear();

      for (final item in storedList) {
        final decoded = jsonDecode(item);
        _history.add(HistoryModel.fromJson(decoded));
      }

      notifyListeners();
    }
  }

  Future<void> _persistHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> encodedList = _history
        .map((item) => jsonEncode(item.toJson()))
        .toList();

    await prefs.setStringList(_historyKey, encodedList);
  }

  /// ================= TIMER =================

  void _startTimer() {
    _timer?.cancel();

    if (_selectedQuiz == null) return;

    _remainingSeconds = _selectedQuiz!.durationMinutes * 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  /// ================= RESET =================

  void resetQuiz() {
    _timer?.cancel();

    _selectedQuiz = null;
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isResultSaved = false;
    _remainingSeconds = 0;

    notifyListeners();
  }
}
