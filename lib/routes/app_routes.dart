import 'package:flutter/material.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/quiz/presentation/quiz_attempt_screen.dart';
import '../features/quiz/presentation/quiz_detail_screen.dart';
import '../features/quiz/presentation/quiz_list_screen.dart';
import '../features/result/presentation/result_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
//admin screens
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/admin/presentation/manage_quizzes_screen.dart';
import '../features/admin/presentation/manage_questions_screen.dart';
import '../features/admin/presentation/manage_users_screen.dart';
import '../features/admin/presentation/reports_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String quizList = '/quiz-list';
  static const String quizDetail = '/quiz-detail';
  static const String quizAttempt = '/quiz-attempt';
  static const String result = '/result';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';
  //admin routes constants
  static const String adminDashboard = '/admin-dashboard';
  static const String manageQuizzes = '/manage-quizzes';
  static const String manageQuestions = '/manage-questions';
  static const String manageUsers = '/manage-users';
  static const String reports = '/reports';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    dashboard: (context) => const DashboardScreen(),
    quizList: (context) => const QuizListScreen(),
    quizDetail: (context) => const QuizDetailScreen(),
    quizAttempt: (context) => const QuizAttemptScreen(),
    result: (context) => const ResultScreen(),
    history: (context) => const HistoryScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
    //admin routes map
    adminDashboard: (context) => const AdminDashboardScreen(),
    manageQuizzes: (context) => const ManageQuizzesScreen(),
    manageQuestions: (context) => const ManageQuestionsScreen(),
    manageUsers: (context) => const ManageUsersScreen(),
    reports: (context) => const ReportsScreen(),
  };
}
