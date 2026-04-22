import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/models/quiz_model.dart';
import '../../../shared/widgets/admin_sidebar.dart';
import '../../../shared/widgets/admin_top_bar.dart';
import '../providers/question_management_provider.dart';
import '../providers/quiz_management_provider.dart';

class ManageQuizzesScreen extends StatefulWidget {
  const ManageQuizzesScreen({super.key});

  @override
  State<ManageQuizzesScreen> createState() => _ManageQuizzesScreenState();
}

class _ManageQuizzesScreenState extends State<ManageQuizzesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateQuizDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final difficultyController = TextEditingController();
    final durationController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Quiz'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppTextField(
                    hintText: 'Quiz Title',
                    prefixIcon: Icons.title,
                    controller: titleController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Description',
                    prefixIcon: Icons.description_outlined,
                    controller: descriptionController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Category',
                    prefixIcon: Icons.category_outlined,
                    controller: categoryController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Difficulty',
                    prefixIcon: Icons.signal_cellular_alt_outlined,
                    controller: difficultyController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Duration (minutes)',
                    prefixIcon: Icons.timer_outlined,
                    controller: durationController,
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
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                final category = categoryController.text.trim();
                final difficulty = difficultyController.text.trim();
                final duration =
                    int.tryParse(durationController.text.trim()) ?? 0;

                if (title.isEmpty ||
                    description.isEmpty ||
                    category.isEmpty ||
                    difficulty.isEmpty ||
                    duration <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all quiz fields correctly'),
                    ),
                  );
                  return;
                }

                Provider.of<QuizManagementProvider>(
                  context,
                  listen: false,
                ).addQuiz(
                  title: title,
                  description: description,
                  category: category,
                  difficulty: difficulty,
                  durationMinutes: duration,
                );

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz created successfully')),
                );
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _deleteQuiz(String quizId, String title) {
    Provider.of<QuizManagementProvider>(
      context,
      listen: false,
    ).deleteQuiz(quizId);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title deleted successfully')));
  }

  void _editQuiz(QuizModel quiz) {
    final titleController = TextEditingController(text: quiz.title);
    final descriptionController = TextEditingController(text: quiz.description);
    final categoryController = TextEditingController(text: quiz.category);
    final difficultyController = TextEditingController(text: quiz.difficulty);
    final durationController = TextEditingController(
      text: quiz.durationMinutes.toString(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Quiz'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppTextField(
                    hintText: 'Quiz Title',
                    prefixIcon: Icons.title,
                    controller: titleController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Description',
                    prefixIcon: Icons.description_outlined,
                    controller: descriptionController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Category',
                    prefixIcon: Icons.category_outlined,
                    controller: categoryController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Difficulty',
                    prefixIcon: Icons.signal_cellular_alt_outlined,
                    controller: difficultyController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Duration (minutes)',
                    prefixIcon: Icons.timer_outlined,
                    controller: durationController,
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
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                final category = categoryController.text.trim();
                final difficulty = difficultyController.text.trim();
                final duration =
                    int.tryParse(durationController.text.trim()) ?? 0;

                if (title.isEmpty ||
                    description.isEmpty ||
                    category.isEmpty ||
                    difficulty.isEmpty ||
                    duration <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all quiz fields correctly'),
                    ),
                  );
                  return;
                }

                Provider.of<QuizManagementProvider>(
                  context,
                  listen: false,
                ).updateQuiz(
                  quizId: quiz.id,
                  title: title,
                  description: description,
                  category: category,
                  difficulty: difficulty,
                  durationMinutes: duration,
                );

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz updated successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignQuestionsDialog(QuizModel quiz) {
    final questionProvider = Provider.of<QuestionManagementProvider>(
      context,
      listen: false,
    );
    final allQuestions = questionProvider.questions;

    final Set<String> selectedIds = quiz.questions.map((q) => q.id).toSet();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final selectedQuestions = allQuestions
                .where((q) => selectedIds.contains(q.id))
                .toList();

            return AlertDialog(
              title: Text('Assign Questions - ${quiz.title}'),
              content: SizedBox(
                width: 560,
                height: 520,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assigned Questions (${selectedQuestions.length})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          if (selectedQuestions.isEmpty)
                            const Text(
                              'No questions assigned yet',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            ...selectedQuestions.map(
                              (question) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.check_circle_outline,
                                        size: 18,
                                        color: AppColors.success,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        question.questionText,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    const Text(
                      'Question Bank',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Expanded(
                      child: allQuestions.isEmpty
                          ? const Center(
                              child: Text(
                                'No questions available in question bank',
                              ),
                            )
                          : ListView.separated(
                              itemCount: allQuestions.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 16),
                              itemBuilder: (context, index) {
                                final question = allQuestions[index];
                                final isSelected = selectedIds.contains(
                                  question.id,
                                );

                                return CheckboxListTile(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      if (value == true) {
                                        selectedIds.add(question.id);
                                      } else {
                                        selectedIds.remove(question.id);
                                      }
                                    });
                                  },
                                  title: Text(
                                    question.questionText,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Options: ${question.options.length} | Correct: Option ${question.correctAnswerIndex + 1}',
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              },
                            ),
                    ),
                  ],
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
                    final updatedSelectedQuestions = allQuestions
                        .where((q) => selectedIds.contains(q.id))
                        .toList();

                    Provider.of<QuizManagementProvider>(
                      context,
                      listen: false,
                    ).assignQuestionsToQuiz(
                      quizId: quiz.id,
                      selectedQuestions: updatedSelectedQuestions,
                    );

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${updatedSelectedQuestions.length} question(s) assigned to "${quiz.title}"',
                        ),
                      ),
                    );
                  },
                  child: const Text('Assign'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showQuizQuestionsPreviewDialog(QuizModel quiz) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Assigned Questions - ${quiz.title}'),
          content: SizedBox(
            width: 560,
            height: 460,
            child: quiz.questions.isEmpty
                ? const Center(
                    child: Text('No questions assigned to this quiz yet'),
                  )
                : ListView.separated(
                    itemCount: quiz.questions.length,
                    separatorBuilder: (_, __) => const Divider(height: 20),
                    itemBuilder: (context, index) {
                      final question = quiz.questions[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${index + 1}. ${question.questionText}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          ...List.generate(question.options.length, (
                            optionIndex,
                          ) {
                            final isCorrect =
                                optionIndex == question.correctAnswerIndex;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    size: 18,
                                    color: isCorrect
                                        ? AppColors.success
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Option ${optionIndex + 1}: ${question.options[optionIndex]}',
                                      style: TextStyle(
                                        fontWeight: isCorrect
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: isCorrect
                                            ? AppColors.success
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<QuizModel> _applyFilters(List<QuizModel> quizzes) {
    final search = _searchController.text.trim().toLowerCase();

    return quizzes.where((quiz) {
      final isPlayable = quiz.questions.isNotEmpty;

      final matchesSearch =
          search.isEmpty ||
          quiz.title.toLowerCase().contains(search) ||
          quiz.description.toLowerCase().contains(search) ||
          quiz.category.toLowerCase().contains(search) ||
          quiz.difficulty.toLowerCase().contains(search);

      final matchesStatus =
          _selectedStatusFilter == 'All' ||
          (_selectedStatusFilter == 'Playable' && isPlayable) ||
          (_selectedStatusFilter == 'Not Ready' && !isPlayable);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final quizManagementProvider = Provider.of<QuizManagementProvider>(context);
    final quizzes = quizManagementProvider.quizzes;
    final filteredQuizzes = _applyFilters(quizzes);

    final totalQuizzes = quizzes.length;
    final totalQuestions = quizzes.fold<int>(
      0,
      (sum, item) => sum + item.totalQuestions,
    );
    final playableQuizzes = quizzes.where((q) => q.questions.isNotEmpty).length;
    final notReadyQuizzes = totalQuizzes - playableQuizzes;

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
              const AdminSidebar(selectedRoute: AppRoutes.manageQuizzes),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg,
                    AppSizes.md,
                    AppSizes.lg,
                    AppSizes.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminTopBar(
                        hintText: 'Search quizzes...',
                        controller: _searchController,
                        onSearchChanged: () {
                          setState(() {});
                        },
                        actions: [
                          AppButton(
                            text: 'Create Quiz',
                            icon: Icons.add,
                            isFullWidth: false,
                            onPressed: _showCreateQuizDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Manage Quizzes',
                        subtitle: 'Create, review, edit, and organize quizzes.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      Row(
                        children: [
                          Expanded(
                            child: _AdminSummaryCard(
                              title: 'Total Quizzes',
                              value: '$totalQuizzes',
                              icon: Icons.quiz_outlined,
                              iconColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _AdminSummaryCard(
                              title: 'Assigned Questions',
                              value: '$totalQuestions',
                              icon: Icons.help_outline,
                              iconColor: AppColors.info,
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _AdminSummaryCard(
                              title: 'Playable Quizzes',
                              value: '$playableQuizzes',
                              icon: Icons.check_circle_outline,
                              iconColor: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _AdminSummaryCard(
                              title: 'Not Ready',
                              value: '$notReadyQuizzes',
                              icon: Icons.pause_circle_outline,
                              iconColor: AppColors.warning,
                            ),
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
                              subtitle:
                                  'Search and filter quiz records quickly.',
                            ),
                            const SizedBox(height: AppSizes.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _selectedStatusFilter,
                                    decoration: const InputDecoration(
                                      labelText: 'Status',
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'All',
                                        child: Text('All'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Playable',
                                        child: Text('Playable'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Not Ready',
                                        child: Text('Not Ready'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedStatusFilter = value ?? 'All';
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
                                      _selectedStatusFilter = 'All';
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
                              title: 'Quiz Library',
                              subtitle:
                                  'Showing ${filteredQuizzes.length} of ${quizzes.length} quizzes.',
                            ),
                            const SizedBox(height: AppSizes.lg),
                            _buildHeaderRow(context),
                            const SizedBox(height: AppSizes.md),
                            if (filteredQuizzes.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSizes.xl,
                                ),
                                child: Center(
                                  child: Text(
                                    'No quizzes match the current filter',
                                  ),
                                ),
                              )
                            else
                              ...List.generate(filteredQuizzes.length, (index) {
                                final quiz = filteredQuizzes[index];
                                return Column(
                                  children: [
                                    _AdminQuizRow(
                                      quiz: quiz,
                                      onEdit: () => _editQuiz(quiz),
                                      onDelete: () =>
                                          _deleteQuiz(quiz.id, quiz.title),
                                      onAssignQuestions: () =>
                                          _showAssignQuestionsDialog(quiz),
                                      onPreviewQuestions: () =>
                                          _showQuizQuestionsPreviewDialog(quiz),
                                    ),
                                    if (index != filteredQuizzes.length - 1)
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
        Expanded(flex: 3, child: Text('Quiz', style: style)),
        Expanded(child: Text('Difficulty', style: style)),
        Expanded(child: Text('Questions', style: style)),
        Expanded(child: Text('Duration', style: style)),
        Expanded(child: Text('Status', style: style)),
        Expanded(flex: 3, child: Text('Actions', style: style)),
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

class _AdminQuizRow extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAssignQuestions;
  final VoidCallback onPreviewQuestions;

  const _AdminQuizRow({
    required this.quiz,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignQuestions,
    required this.onPreviewQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isPlayable = quiz.questions.isNotEmpty;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(Icons.quiz_outlined, color: Colors.white),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quiz.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            quiz.difficulty,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            '${quiz.totalQuestions}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            '${quiz.durationMinutes} min',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (isPlayable ? AppColors.success : AppColors.warning)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isPlayable ? 'Playable' : 'Not Ready',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isPlayable ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionIconButton(
                icon: Icons.visibility_outlined,
                tooltip: 'Preview assigned questions',
                onTap: onPreviewQuestions,
                color: AppColors.success,
              ),
              _ActionIconButton(
                icon: Icons.assignment_outlined,
                tooltip: 'Assign questions',
                onTap: onAssignQuestions,
                color: AppColors.info,
              ),
              _ActionIconButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit quiz',
                onTap: onEdit,
              ),
              _ActionIconButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete quiz',
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
