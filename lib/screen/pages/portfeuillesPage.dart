import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/categorie.dart';
import 'package:smarth_save/services/api_categorie_service.dart';

class PortfeuillesPage extends StatefulWidget {
  const PortfeuillesPage({super.key});

  @override
  State<PortfeuillesPage> createState() => _PortfeuillesPageState();
}

class _PortfeuillesPageState extends State<PortfeuillesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Categorie> _categories = [];

  // static const _categories = [
  //   _CategoryBudget('Alimentation', Icons.restaurant_outlined, 0.78, 312, 400, Color(0xFFFF6B35)),
  //   _CategoryBudget('Transport', Icons.directions_car_outlined, 0.52, 104, 200, Color(0xFF009688)),
  //   _CategoryBudget('Loisirs', Icons.sports_soccer_outlined, 0.91, 182, 200, Color(0xFFEF4444)),
  //   _CategoryBudget('Santé', Icons.favorite_outline, 0.18, 36, 200, Color(0xFF22C55E)),
  //   _CategoryBudget('Habitation', Icons.home_outlined, 0.45, 360, 800, Color(0xFF7C3AED)),
  //   _CategoryBudget('Éducation', Icons.school_outlined, 0.80, 160, 200, Color(0xFFEF4444)),
  // ];

  Future<void> getCategories() async {
    final response = await ApiCategorieService().getMyCategories();
    setState(() {
      _categories = response;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgPage,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [_buildHeader()],
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBudgetList(),
                  _buildSummary(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/addCategorie'),
        backgroundColor: kTeal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nouvelle catégorie',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  SliverAppBar _buildHeader() {
    final overBudget = _categories.where((c) => (c.progress ?? 0.0) >= 0.9).length;
    return SliverAppBar(
      expandedHeight: 160,
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
                'Budget',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatPill(
                    label: 'Catégories',
                    value: '${_categories.length}',
                    icon: Icons.grid_view_rounded,
                    color: kTealLight,
                  ),
                  const SizedBox(width: 10),
                  if (overBudget > 0)
                    _StatPill(
                      label: 'Dépassements',
                      value: '$overBudget',
                      icon: Icons.warning_amber_rounded,
                      color: kDanger,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── TabBar ───────────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: kBgCard,
      child: TabBar(
        controller: _tabController,
        labelColor: kTeal,
        unselectedLabelColor: kTextSecondary,
        indicatorColor: kTeal,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        tabs: const [
          Tab(text: 'Catégories'),
          Tab(text: 'Résumé'),
        ],
      ),
    );
  }

  // ─── Budget list ──────────────────────────────────────────────────────────────

  Widget _buildBudgetList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _BudgetCard(category: _categories[i]),
    );
  }

  // ─── Summary ──────────────────────────────────────────────────────────────────

  Widget _buildSummary() {
    final totalBudget = _categories.fold<double>(0, (s, c) => s + (c.total ?? 0));
    final totalSpent  = _categories.fold<double>(0, (s, c) => s + (c.spent ?? 0));
    final remaining   = totalBudget - totalSpent;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SummaryCard(
          label: 'Budget total',
          value: '$totalBudget €',
          icon: Icons.account_balance_wallet_outlined,
          color: kNavyMid,
        ),
        const SizedBox(height: 10),
        _SummaryCard(
          label: 'Dépensé',
          value: '$totalSpent €',
          icon: Icons.arrow_upward_rounded,
          color: kDanger,
        ),
        const SizedBox(height: 10),
        _SummaryCard(
          label: 'Restant',
          value: '$remaining €',
          icon: Icons.savings_outlined,
          color: kSuccess,
        ),
        const SizedBox(height: 20),
        const Text(
          'Répartition',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: kTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._categories.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.color?.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(c.icon, color: c.color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.label ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kTextPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '${'${(c.progress ?? 0.0) * 100}'.replaceAll('.', ',')}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: budgetBarColor(c.progress ?? 0.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: c.progress?.clamp(0.0, 1.0) ?? 0.0,
                            minHeight: 5,
                            backgroundColor: kBgPage,
                            valueColor: AlwaysStoppedAnimation<Color>(budgetBarColor(c.progress ?? 0.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),),
      ],
    );
  }
}

// ─── Budget Card ──────────────────────────────────────────────────────────────

class _BudgetCard extends StatelessWidget {
  final Categorie category;
  const _BudgetCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final color     = budgetBarColor(category.progress ?? 0.0);
    final isOverdue = (category.progress ?? 0.0) >= 0.9;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kNavyDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        border: isOverdue
            ? Border.all(color: kDanger.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: category.color?.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, color: category.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category.label ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: kTextPrimary,
                          ),
                        ),
                        if (isOverdue) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: kDanger.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Limite atteinte',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: kDanger,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.spent} € sur ${category.total} €',
                      style: const TextStyle(fontSize: 12, color: kTextSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '${'${(category.progress ?? 0.0) * 100}'.replaceAll('.', ',')}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: category.progress?.clamp(0.0, 1.0) ?? 0.0,
              minHeight: 8,
              backgroundColor: kBgPage,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kNavyDark.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: kTextSecondary)),
              Text(
                value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Stat Pill ────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            '$value $label',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

// class _CategoryBudget {
//   final String label;
//   final IconData icon;
//   final double progress;
//   final int spent;
//   final int total;
//   final Color color;

//   const _CategoryBudget(
//     this.label,
//     this.icon,
//     this.progress,
//     this.spent,
//     this.total,
//     this.color,
//   );
// }
