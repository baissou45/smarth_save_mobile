import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/widgets/portefeuilleWidget.dart';

class PortfeuillesPage extends StatefulWidget {
  const PortfeuillesPage({super.key});

  @override
  State<PortfeuillesPage> createState() => _PortfeuillesPageState();
}

class _PortfeuillesPageState extends State<PortfeuillesPage> {
  final List<_BudgetCategory> _categories = const [
    _BudgetCategory(title: 'Restauration', amount: 100, actuelAmount: 30),
    _BudgetCategory(title: 'Transport', amount: 100, actuelAmount: 20),
    _BudgetCategory(title: 'Alimentation', amount: 300, actuelAmount: 150),
    _BudgetCategory(title: 'Habitation', amount: 800, actuelAmount: 200),
    _BudgetCategory(title: 'Sante', amount: 200, actuelAmount: 30),
    _BudgetCategory(title: 'Loisirs', amount: 400, actuelAmount: 340),
    _BudgetCategory(title: 'Education', amount: 200, actuelAmount: 100),
  ];

  List<_BudgetCategory> get _savings => List.generate(
        8,
        (index) => _BudgetCategory(
          title: 'Epargne ${index + 1}',
          amount: 1000,
          actuelAmount: (index + 1) * 110,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 700;
    final horizontalPadding = isWide ? 24.0 : 16.0;
    final int crossCount = size.width >= 1100
        ? 4
        : size.width >= 780
            ? 3
            : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/creatProjet');
        },
        backgroundColor: kPrimaryColor1,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                22,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor1, kPrimaryColor2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(26),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Portefeuilles',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Suivez vos categories et vos objectifs d\'epargne.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SummaryCard(categories: _categories),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 102,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final item = _categories[index];
                          return _CategoryPill(item: item);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 16, horizontalPadding, 90),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Mes portefeuilles',
                    subtitle: 'Vue detaillee de vos enveloppes',
                    actionLabel: 'Creer',
                    onTap: () => context.push('/creatProjet'),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    itemCount: _savings.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 1.75 : 1.48,
                    ),
                    itemBuilder: (context, index) {
                      final item = _savings[index];
                      return PortefeuilleWidget(
                        title: item.title,
                        amount: item.amount,
                        actuelAmount: item.actuelAmount,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.add_circle_outline),
          label: Text(actionLabel),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<_BudgetCategory> categories;

  const _SummaryCard({required this.categories});

  @override
  Widget build(BuildContext context) {
    final totalBudget =
        categories.fold<int>(0, (sum, item) => sum + item.amount);
    final totalSpent =
        categories.fold<int>(0, (sum, item) => sum + item.actuelAmount);
    final progress =
        totalBudget == 0 ? 0.0 : (totalSpent / totalBudget).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Depenses globales',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$totalSpent € / $totalBudget €',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final _BudgetCategory item;

  const _CategoryPill({required this.item});

  @override
  Widget build(BuildContext context) {
    final progress = item.amount == 0
        ? 0.0
        : (item.actuelAmount / item.amount).clamp(0.0, 1.0);

    return Container(
      width: 156,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            '${item.actuelAmount}€ / ${item.amount}€',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1
                    ? Colors.red
                    : progress >= 0.7
                        ? Colors.orange
                        : kPrimaryColor1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetCategory {
  final String title;
  final int amount;
  final int actuelAmount;

  const _BudgetCategory({
    required this.title,
    required this.amount,
    required this.actuelAmount,
  });
}
