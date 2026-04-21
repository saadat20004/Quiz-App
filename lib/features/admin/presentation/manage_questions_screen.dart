import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/models/question_model.dart';
import '../../../shared/widgets/admin_sidebar.dart';
import '../../../shared/widgets/admin_top_bar.dart';
import '../providers/question_management_provider.dart';

class ManageQuestionsScreen extends StatefulWidget {
  const ManageQuestionsScreen({super.key});

  @override
  State<ManageQuestionsScreen> createState() => _ManageQuestionsScreenState();
}

class _ManageQuestionsScreenState extends State<ManageQuestionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCorrectFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateQuestionDialog() {
    final questionController = TextEditingController();
    final option1Controller = TextEditingController();
    final option2Controller = TextEditingController();
    final option3Controller = TextEditingController();
    final option4Controller = TextEditingController();
    final correctAnswerController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Question'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppTextField(
                    hintText: 'Question Text',
                    prefixIcon: Icons.help_outline,
                    controller: questionController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Option 1',
                    prefixIcon: Icons.looks_one_outlined,
                    controller: option1Controller,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Option 2',
                    prefixIcon: Icons.looks_two_outlined,
                    controller: option2Controller,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Option 3',
                    prefixIcon: Icons.looks_3_outlined,
                    controller: option3Controller,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Option 4',
                    prefixIcon: Icons.looks_4_outlined,
                    controller: option4Controller,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Correct Answer Index (0-3)',
                    prefixIcon: Icons.check_circle_outline,
                    controller: correctAnswerController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final questionText = questionController.text.trim();
                final option1 = option1Controller.text.trim();
                final option2 = option2Controller.text.trim();
                final option3 = option3Controller.text.trim();
                final option4 = option4Controller.text.trim();
                final correctAnswerIndex =
                    int.tryParse(correctAnswerController.text.trim()) ?? -1;

                final options = [option1, option2, option3, option4];

                if (questionText.isEmpty ||
                    options.any((o) => o.isEmpty) ||
                    correctAnswerIndex < 0 ||
                    correctAnswerIndex > 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all question fields correctly',
                      ),
                    ),
                  );
                  return;
                }

                Provider.of<QuestionManagementProvider>(
                  context,
                  listen: false,
                ).addQuestion(
                  questionText: questionText,
                  options: options,
                  correctAnswerIndex: correctAnswerIndex,
                );

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Question created successfully'),
                  ),
                );
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _editQuestion(QuestionModel question) {
    final questionController = TextEditingController(
      text: question.questionText,
    );
    final option1Controller = TextEditingController(text: question.options[0]);
    final option2Controller = TextEditingController(text: question.options[1]);
    final option3Controller = TextEditingController(text: question.options[2]);
    final option4Controller = TextEditingController(text: question.options[3]);
    final correctAnswerController = TextEditingController(
      text: question.correctAnswerIndex.toString(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Question'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppTextField(
                    hintText: 'Question Text',
                    prefixIcon: Icons.help_outline,
                    controller: questionController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Option 1',
                    prefixIcon: Icons.looks_one_outlined,
                    controller: option1Controller,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Option 2',
                    prefixIcon: Icons.looks_two_outlined,
                    controller: option2Controller,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Option 3',
                    prefixIcon: Icons.looks_3_outlined,
                    controller: option3Controller,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Option 4',
                    prefixIcon: Icons.looks_4_outlined,
                    controller: option4Controller,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Correct Answer Index (0-3)',
                    prefixIcon: Icons.check_circle_outline,
                    controller: correctAnswerController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final questionText = questionController.text.trim();
                final options = [
                  option1Controller.text.trim(),
                  option2Controller.text.trim(),
                  option3Controller.text.trim(),
                  option4Controller.text.trim(),
                ];
                final correctAnswerIndex =
                    int.tryParse(correctAnswerController.text.trim()) ?? -1;

                if (questionText.isEmpty ||
                    options.any((o) => o.isEmpty) ||
                    correctAnswerIndex < 0 ||
                    correctAnswerIndex > 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all question fields correctly',
                      ),
                    ),
                  );
                  return;
                }

                Provider.of<QuestionManagementProvider>(
                  context,
                  listen: false,
                ).updateQuestion(
                  questionId: question.id,
                  questionText: questionText,
                  options: options,
                  correctAnswerIndex: correctAnswerIndex,
                );

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Question updated successfully'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteQuestion(String questionId, String questionText) {
    Provider.of<QuestionManagementProvider>(
      context,
      listen: false,
    ).deleteQuestion(questionId);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Question deleted: $questionText')));
  }

  List<QuestionModel> _applyFilters(List<QuestionModel> questions) {
    final search = _searchController.text.trim().toLowerCase();

    return questions.where((question) {
      final correctLabel = 'option ${question.correctAnswerIndex + 1}'
          .toLowerCase();

      final matchesSearch =
          search.isEmpty ||
          question.questionText.toLowerCase().contains(search) ||
          question.options.any(
            (option) => option.toLowerCase().contains(search),
          );

      final matchesCorrect =
          _selectedCorrectFilter == 'All' ||
          (_selectedCorrectFilter == 'Option 1' &&
              question.correctAnswerIndex == 0) ||
          (_selectedCorrectFilter == 'Option 2' &&
              question.correctAnswerIndex == 1) ||
          (_selectedCorrectFilter == 'Option 3' &&
              question.correctAnswerIndex == 2) ||
          (_selectedCorrectFilter == 'Option 4' &&
              question.correctAnswerIndex == 3) ||
          correctLabel == _selectedCorrectFilter.toLowerCase();

      return matchesSearch && matchesCorrect;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final questionProvider = Provider.of<QuestionManagementProvider>(context);
    final questions = questionProvider.questions;
    final filteredQuestions = _applyFilters(questions);

    final totalQuestions = questions.length;
    final multipleChoiceQuestions = questions.length;
    final totalOptions = questions.fold<int>(
      0,
      (sum, item) => sum + item.options.length,
    );
    final averageOptions = questions.isEmpty
        ? 0
        : (totalOptions / questions.length).round();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          gradient: isDark ? AppColors.darkBackgroundGlow : null,
        ),
        child: SafeArea(
          child: Row(
            children: [
              const AdminSidebar(selectedRoute: AppRoutes.manageQuestions),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminTopBar(
                        hintText: 'Search questions...',
                        controller: _searchController,
                        onSearchChanged: () {
                          setState(() {});
                        },
                        actions: [
                          AppButton(
                            text: 'Create Question',
                            icon: Icons.add,
                            isFullWidth: false,
                            onPressed: _showCreateQuestionDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Manage Questions',
                        subtitle:
                            'Build and maintain the question bank for all quizzes.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      Wrap(
                        spacing: AppSizes.md,
                        runSpacing: AppSizes.md,
                        children: [
                          _AdminSummaryCard(
                            title: 'Total Questions',
                            value: '$totalQuestions',
                            icon: Icons.help_outline,
                            iconColor: AppColors.primary,
                          ),
                          _AdminSummaryCard(
                            title: 'MCQ Questions',
                            value: '$multipleChoiceQuestions',
                            icon: Icons.list_alt_outlined,
                            iconColor: AppColors.success,
                          ),
                          _AdminSummaryCard(
                            title: 'Total Options',
                            value: '$totalOptions',
                            icon: Icons.format_list_bulleted,
                            iconColor: AppColors.info,
                          ),
                          _AdminSummaryCard(
                            title: 'Avg Options',
                            value: '$averageOptions',
                            icon: Icons.analytics_outlined,
                            iconColor: AppColors.warning,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),

                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle(
                              title: 'Filters',
                              subtitle: 'Search and filter questions quickly.',
                            ),
                            const SizedBox(height: AppSizes.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _selectedCorrectFilter,
                                    decoration: const InputDecoration(
                                      labelText: 'Correct Answer',
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'All',
                                        child: Text('All'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Option 1',
                                        child: Text('Option 1'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Option 2',
                                        child: Text('Option 2'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Option 3',
                                        child: Text('Option 3'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Option 4',
                                        child: Text('Option 4'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCorrectFilter = value ?? 'All';
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: AppSizes.md),
                                AppButton(
                                  text: 'Reset',
                                  isOutlined: true,
                                  isFullWidth: false,
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _selectedCorrectFilter = 'All';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSizes.lg),

                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionTitle(
                              title: 'Question Bank',
                              subtitle:
                                  'Showing ${filteredQuestions.length} of ${questions.length} questions.',
                            ),
                            const SizedBox(height: AppSizes.lg),
                            _buildHeaderRow(context),
                            const SizedBox(height: AppSizes.md),
                            if (filteredQuestions.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSizes.xl,
                                ),
                                child: Center(
                                  child: Text(
                                    'No questions match the current filter',
                                  ),
                                ),
                              )
                            else
                              ...List.generate(filteredQuestions.length, (
                                index,
                              ) {
                                final question = filteredQuestions[index];
                                return Column(
                                  children: [
                                    _AdminQuestionRow(
                                      question: question,
                                      onEdit: () => _editQuestion(question),
                                      onDelete: () => _deleteQuestion(
                                        question.id,
                                        question.questionText,
                                      ),
                                    ),
                                    if (index != filteredQuestions.length - 1)
                                      Divider(
                                        color: isDark
                                            ? AppColors.darkBorder
                                            : AppColors.lightBorder,
                                        height: 24,
                                      ),
                                  ],
                                );
                              }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);

    return Row(
      children: [
        Expanded(flex: 4, child: Text('Question', style: style)),
        Expanded(child: Text('Options', style: style)),
        Expanded(child: Text('Correct', style: style)),
        Expanded(flex: 2, child: Text('Actions', style: style)),
      ],
    );
  }
}

class _AdminSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _AdminSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 250,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminQuestionRow extends StatelessWidget {
  final QuestionModel question;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AdminQuestionRow({
    required this.question,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(Icons.help_outline, color: Colors.white),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  question.questionText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            '${question.options.length}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            'Option ${question.correctAnswerIndex + 1}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionIconButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit question',
                onTap: onEdit,
              ),
              _ActionIconButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete question',
                onTap: onDelete,
                color: AppColors.danger,
                borderColor: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;
  final Color? borderColor;

  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  borderColor ??
                  (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Icon(icon, color: color ?? AppColors.primary, size: 20),
        ),
      ),
    );
  }
}
