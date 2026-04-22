import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/utils/report_export_helper.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/admin_sidebar.dart';
import '../../../shared/widgets/admin_top_bar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  /// ✅ Export dialog (moved OUTSIDE build)
  void _showExportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Export Reports'),
        content: const Text('Choose a format for report export.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ReportExportHelper.exportPdf();
            },
            child: const Text('PDF'),
          ),
          TextButton(
            onPressed: () async {
              await ReportExportHelper.exportExcel();
            },
            child: const Text('Excel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
              const AdminSidebar(selectedRoute: AppRoutes.reports),

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
                      /// TOP BAR
                      AdminTopBar(
                        hintText: 'Search reports...',
                        actions: [
                          AppButton(
                            text: 'Export',
                            icon: Icons.download_outlined,
                            isFullWidth: false,
                            onPressed: () => _showExportDialog(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.lg),

                      const SectionTitle(
                        title: 'Reports & Analytics',
                        subtitle:
                            'Track quiz performance, user activity, and engagement insights.',
                      ),

                      const SizedBox(height: AppSizes.lg),

                      /// ✅ FULL WIDTH STATS
                      Row(
                        children: const [
                          Expanded(
                            child: _ReportSummaryCard(
                              title: 'Total Attempts',
                              value: '9,620',
                              icon: Icons.play_circle_outline,
                              iconColor: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _ReportSummaryCard(
                              title: 'Average Score',
                              value: '86%',
                              icon: Icons.auto_graph_outlined,
                              iconColor: AppColors.success,
                            ),
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _ReportSummaryCard(
                              title: 'Completion Rate',
                              value: '91%',
                              icon: Icons.check_circle_outline,
                              iconColor: AppColors.info,
                            ),
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _ReportSummaryCard(
                              title: 'Active Participants',
                              value: '1,284',
                              icon: Icons.people_outline,
                              iconColor: AppColors.warning,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.lg),

                      _buildMainGrid(context),
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

  /// =========================
  /// MAIN GRID
  /// =========================
  Widget _buildMainGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT SIDE
        Expanded(
          flex: 3,
          child: Column(
            children: [
              /// ✅ CHART FIXED
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionTitle(
                      title: 'Performance Overview',
                      subtitle: 'Quiz attempts over time',
                    ),
                    SizedBox(height: AppSizes.lg),
                    _SimpleBarChart(),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),
              const _QuizPerformanceCard(),
              const SizedBox(height: AppSizes.lg),
              const _UserPerformanceCard(),
            ],
          ),
        ),

        const SizedBox(width: AppSizes.lg),

        /// RIGHT SIDE
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const _LeaderboardCard(),
              const SizedBox(height: AppSizes.lg),

              /// ✅ EXPORT CARD CONNECTED
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Export Options',
                      subtitle: 'Download reports',
                    ),
                    const SizedBox(height: AppSizes.lg),

                    AppButton(
                      text: 'Export as PDF',
                      icon: Icons.picture_as_pdf_outlined,
                      onPressed: () => _showExportDialog(context),
                    ),

                    const SizedBox(height: AppSizes.md),

                    AppButton(
                      text: 'Export as Excel',
                      icon: Icons.table_chart_outlined,
                      isOutlined: true,
                      onPressed: () => _showExportDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  const _SimpleBarChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _bar(0, 8),
            _bar(1, 12),
            _bar(2, 10),
            _bar(3, 15),
            _bar(4, 9),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 18,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}

class _ReportSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _ReportSummaryCard({
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

class _QuizPerformanceCard extends StatelessWidget {
  const _QuizPerformanceCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(
            title: 'Quiz Performance',
            subtitle: 'Top quizzes by attempts and scores',
          ),
          SizedBox(height: AppSizes.lg),
          _ReportTableHeader(
            first: 'Quiz',
            second: 'Attempts',
            third: 'Avg Score',
            fourth: 'Status',
          ),
          SizedBox(height: AppSizes.md),
          _QuizReportRow(
            title: 'Science Challenge',
            attempts: '164',
            avgScore: '85%',
            status: 'Active',
          ),
          Divider(height: 24),
          _QuizReportRow(
            title: 'Math Speed Test',
            attempts: '98',
            avgScore: '80%',
            status: 'Active',
          ),
          Divider(height: 24),
          _QuizReportRow(
            title: 'History Basics',
            attempts: '205',
            avgScore: '78%',
            status: 'Inactive',
          ),
        ],
      ),
    );
  }
}

class _UserPerformanceCard extends StatelessWidget {
  const _UserPerformanceCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(
            title: 'User Performance',
            subtitle: 'Top participants by quiz results',
          ),
          SizedBox(height: AppSizes.lg),
          _ReportTableHeader(
            first: 'User',
            second: 'Attempts',
            third: 'Avg Score',
            fourth: 'Status',
          ),
          SizedBox(height: AppSizes.md),
          _UserReportRow(
            name: 'Ayesha Noor',
            attempts: '12',
            avgScore: '96%',
            status: 'Active',
          ),
          Divider(height: 24),
          _UserReportRow(
            name: 'Muhammad Bilal',
            attempts: '9',
            avgScore: '88%',
            status: 'Active',
          ),
          Divider(height: 24),
          _UserReportRow(
            name: 'Saadat Sohail',
            attempts: '7',
            avgScore: '84%',
            status: 'Active',
          ),
        ],
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(title: 'Leaderboard', subtitle: 'Highest performers'),
          SizedBox(height: AppSizes.lg),
          _LeaderboardRow(rank: 1, name: 'Ayesha Noor', score: '980'),
          Divider(height: 24),
          _LeaderboardRow(rank: 2, name: 'Muhammad Bilal', score: '945'),
          Divider(height: 24),
          _LeaderboardRow(rank: 3, name: 'Sophia Ahmed', score: '920'),
          Divider(height: 24),
          _LeaderboardRow(rank: 4, name: 'Saadat Sohail', score: '890'),
        ],
      ),
    );
  }
}

class _ExportOptionsCard extends StatelessWidget {
  const _ExportOptionsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Export Options',
            subtitle: 'Download analytics and performance reports',
          ),
          const SizedBox(height: AppSizes.lg),
          AppButton(
            text: 'Export as PDF',
            icon: Icons.picture_as_pdf_outlined,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PDF export will be connected next'),
                ),
              );
            },
          ),
          const SizedBox(height: AppSizes.md),
          AppButton(
            text: 'Export as Excel',
            icon: Icons.table_chart_outlined,
            isOutlined: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Excel export will be connected next'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReportTableHeader extends StatelessWidget {
  final String first;
  final String second;
  final String third;
  final String fourth;

  const _ReportTableHeader({
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);

    return Row(
      children: [
        Expanded(flex: 3, child: Text(first, style: style)),
        Expanded(child: Text(second, style: style)),
        Expanded(child: Text(third, style: style)),
        Expanded(child: Text(fourth, style: style)),
      ],
    );
  }
}

class _QuizReportRow extends StatelessWidget {
  final String title;
  final String attempts;
  final String avgScore;
  final String status;

  const _QuizReportRow({
    required this.title,
    required this.attempts,
    required this.avgScore,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(attempts)),
        Expanded(child: Text(avgScore)),
        Expanded(
          child: Text(
            status,
            style: TextStyle(
              color: status == 'Active' ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _UserReportRow extends StatelessWidget {
  final String name;
  final String attempts;
  final String avgScore;
  final String status;

  const _UserReportRow({
    required this.name,
    required this.attempts,
    required this.avgScore,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(attempts)),
        Expanded(child: Text(avgScore)),
        Expanded(
          child: Text(
            status,
            style: TextStyle(
              color: status == 'Active' ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final int rank;
  final String name;
  final String score;

  const _LeaderboardRow({
    required this.rank,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          score,
          style: const TextStyle(
            color: AppColors.warning,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
