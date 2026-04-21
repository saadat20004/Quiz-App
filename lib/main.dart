import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/admin/providers/question_management_provider.dart';
import 'features/admin/providers/quiz_management_provider.dart';
import 'features/quiz/providers/quiz_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final quizProvider = QuizProvider();
  await quizProvider.loadHistory();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<QuizProvider>.value(value: quizProvider),
        ChangeNotifierProvider(create: (_) => QuizManagementProvider()),
        ChangeNotifierProvider(create: (_) => QuestionManagementProvider()),
      ],
      child: const MyApp(),
    ),
  );
}