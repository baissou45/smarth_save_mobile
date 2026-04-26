import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/projet_model.dart';
import 'package:smarth_save/providers/projet_provider.dart';
import 'package:smarth_save/providers/userProvider.dart';

class ProjetPage extends StatefulWidget {
  const ProjetPage({super.key});

  @override
  State<ProjetPage> createState() => _ProjetPageState();
}

class _ProjetPageState extends State<ProjetPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProjetProvider>().loadProjets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProjetProvider, UserProvider>(
      builder: (context, projetProvider, userProvider, _) {
        final projects = projetProvider.projets;
        final totalTarget = projects.fold<double>(0, (s, p) => s + p.montant);
        final totalSaved = context.read<UserProvider>().user?.patrimoineEpargne ?? 0.0;

        if (projetProvider.isLoading) {
          return const _LoadingScaffold();
        }

        return Scaffold(
          backgroundColor: kBgPage,
          body: LiquidPullToRefresh(
            onRefresh: () => context.read<ProjetProvider>().loadProjets(),
            color: kNavyDark,
            backgroundColor: kBgPage,
            height: 80,
            animSpeedFactor: 2,
            showChildOpacityTransition: false,
            child: CustomScrollView(
              slivers: [
                _ProjetHeader(total: totalTarget, reached: totalSaved),
                if (projects.isEmpty)
                  const SliverFillRemaining(child: _EmptyProjetList())
                else
                  _ProjetGrid(projects: projects),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/creatProjet'),
            backgroundColor: kTeal,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text(
              'Nouveau projet',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}

// ─── Loading Scaffold ──────────────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgPage,
      body: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kTeal),
        ),
      ),
    );
  }
}

// ─── Empty Projet List ─────────────────────────────────────────────────────────

class _EmptyProjetList extends StatelessWidget {
  const _EmptyProjetList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_outlined, size: 64, color: kTextHint),
          const SizedBox(height: 16),
          const Text(
            'Aucun projet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Projet Header ─────────────────────────────────────────────────────────────

class _ProjetHeader extends StatelessWidget {
  final double total;
  final double reached;

  const _ProjetHeader({required this.total, required this.reached});

  @override
  Widget build(BuildContext context) {
    final globalProgress = total > 0 ? reached / total : 0.0;

    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: kNavyDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: kHeaderGradient),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Projets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              _SavingsInfoCard(
                total: total,
                reached: reached,
                globalProgress: globalProgress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Savings Info Card ─────────────────────────────────────────────────────────

class _SavingsInfoCard extends StatelessWidget {
  final double total;
  final double reached;
  final double globalProgress;

  const _SavingsInfoCard({
    required this.total,
    required this.reached,
    required this.globalProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Épargne totale',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${reached.toStringAsFixed(0)} € / ${total.toStringAsFixed(0)} €',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(globalProgress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: globalProgress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(kTealLight),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Projet Grid ───────────────────────────────────────────────────────────────

class _ProjetGrid extends StatelessWidget {
  final List<ProjetModel> projects;

  const _ProjetGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => _ProjectCard(project: projects[i]),
          childCount: projects.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
      ),
    );
  }
}

// ─── Project Card ─────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  final ProjetModel project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final userPatrimoine = context.read<UserProvider>().user?.patrimoineEpargne ?? 0.0;
    final progress = project.montant > 0 ? userPatrimoine / project.montant : 0.0;
    final color = project.color;

    return GestureDetector(
      onTap: () => context.push('/detailProjet', extra: project),
      child: Container(
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kNavyDark.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProjectCardHeader(project: project, progress: progress, color: color),
            _ProjectCardInfo(project: project, progress: progress, color: color),
          ],
        ),
      ),
    );
  }
}

// ─── Project Card Header ───────────────────────────────────────────────────────

class _ProjectCardHeader extends StatelessWidget {
  final ProjetModel project;
  final double progress;
  final Color color;

  const _ProjectCardHeader({
    required this.project,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.folder_outlined, color: color, size: 20),
          ),
          const Spacer(),
          _CircularProgress(progress: progress, color: color, size: 38),
        ],
      ),
    );
  }
}

// ─── Project Card Info ─────────────────────────────────────────────────────────

class _ProjectCardInfo extends StatelessWidget {
  final ProjetModel project;
  final double progress;
  final Color color;

  const _ProjectCardInfo({
    required this.project,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isAlmost = progress >= 0.9 && progress < 1.0;
    final isCompleted = progress >= 1.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.titre ?? 'Projet',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
                height: 1.3,
              ),
            ),
            const Spacer(),
            if (project.dateVoulue != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 11, color: kTextSecondary),
                  const SizedBox(width: 4),
                  Text(
                    project.dateVoulue.toString().split(' ')[0],
                    style: const TextStyle(fontSize: 11, color: kTextSecondary),
                  ),
                ],
              ),
            const SizedBox(height: 6),
            Text(
              '${project.montant.toStringAsFixed(0)} €',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              'sur ${project.montantPrev.toStringAsFixed(0)} €',
              style: const TextStyle(fontSize: 11, color: kTextSecondary),
            ),
            if (isCompleted) ...[
              const SizedBox(height: 6),
              _StatusBadge(label: 'Objectif atteint ! 🎉'),
            ] else if (isAlmost) ...[
              const SizedBox(height: 6),
              const _StatusBadge(label: 'Presque là, courage !'),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;

  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: kSuccess.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: kSuccess,
        ),
      ),
    );
  }
}

// ─── Circular Progress ─────────────────────────────────────────────────────────

class _CircularProgress extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;

  const _CircularProgress({
    required this.progress,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: 3.5,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
