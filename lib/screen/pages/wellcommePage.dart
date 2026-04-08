import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/main.dart' show transactionProvider, categorieProvider;

class Wellcommepage extends StatefulWidget {
  const Wellcommepage({super.key});

  @override
  State<Wellcommepage> createState() => _WellcommepageState();
}

class _WellcommepageState extends State<Wellcommepage> {
  bool _balanceVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = UserModel.sessionUser?.prenom ?? 'vous';
    return Scaffold(
      backgroundColor: kBgPage,
      body: CustomScrollView(
        slivers: [
          _buildHeader(firstName),
          SliverToBoxAdapter(child: _buildBankCards()),
          SliverToBoxAdapter(child: _buildQuickActions(context)),
          SliverToBoxAdapter(child: _buildBudgetSection(context)),
          SliverToBoxAdapter(child: _buildRecentTransactions(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  SliverToBoxAdapter _buildHeader(String firstName) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: kHeaderGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour, $firstName 👋',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Votre tableau de bord',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => GoRouter.of(context).push('/notification'),
                      child: Stack(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: kOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Balance card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Solde total',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                            child: Icon(
                              _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _balanceVisible
                            ? const Text(
                                '3 395,02 €',
                                key: ValueKey('visible'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              )
                            : const Text(
                                '••••••',
                                key: ValueKey('hidden'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      // KPI row
                      Row(
                        children: [
                          _KpiChip(
                            label: 'Revenus',
                            value: '+2 800 €',
                            icon: Icons.arrow_downward_rounded,
                            color: kSuccess,
                          ),
                          const SizedBox(width: 12),
                          _KpiChip(
                            label: 'Dépenses',
                            value: '-1 240 €',
                            icon: Icons.arrow_upward_rounded,
                            color: kDanger,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Bank cards ───────────────────────────────────────────────────────────────

  Widget _buildBankCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Mes banques',
            onMore: () {},
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 24),
              children: const [
                _BankCard(
                  name: 'BNP Paribas',
                  logo: 'assets/images/bnp.jpg',
                  balance: '1 095,02 €',
                  gradient: [Color(0xFF006E4E), Color(0xFF00A36C)],
                ),
                SizedBox(width: 12),
                _BankCard(
                  name: 'Société Générale',
                  logo: 'assets/images/sg.png',
                  balance: '2 300,00 €',
                  gradient: [Color(0xFF8B0000), Color(0xFFCC2200)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick actions ────────────────────────────────────────────────────────

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _QuickAction(
            icon: Icons.add_rounded,
            label: 'Ajouter',
            color: kTeal,
            onTap: () => context.push('/creatTransaction'),
          ),
          _QuickAction(
            icon: Icons.receipt_long_rounded,
            label: 'Transactions',
            color: kOrange,
            onTap: () => context.go('/transactions'),
          ),
          _QuickAction(
            icon: Icons.savings_rounded,
            label: 'Projets',
            color: const Color(0xFF7C3AED),
            onTap: () => context.go('/projets'),
          ),
          _QuickAction(
            icon: Icons.smart_toy_outlined,
            label: 'SmartBot',
            color: kNavyMid,
            onTap: () => context.push('/chatbot'),
          ),
        ],
      ),
    );
  }

  // ─── Budget section ───────────────────────────────────────────────────────

  Widget _buildBudgetSection(BuildContext context) {
    final categories = categorieProvider.userCategories;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Budget du mois', onMore: () {}),
          const SizedBox(height: 12),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Aucune catégorie ajoutée',
                  style: TextStyle(
                    color: kTextSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: kBgCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kNavyDark.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(
                  categories.length > 3 ? 3 : categories.length,
                  (i) {
                    final cat = categories[i];
                    final isLast = i == (categories.length > 3 ? 2 : categories.length - 1);
                    final spent = cat.spent ?? 0.0;
                    final total = cat.total ?? 1.0;
                    final progress = spent / total;

                    final budget = _Budget(
                      cat.label ?? 'Sans titre',
                      progress,
                      spent.toInt(),
                      total.toInt(),
                    );

                    return Column(
                      children: [
                        _BudgetRow(budget: budget),
                        if (!isLast)
                          Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: kBgPage,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Recent transactions ──────────────────────────────────────────────────

  Widget _buildRecentTransactions(BuildContext context) {
    final transactions = transactionProvider.transactions;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Activité récente',
            onMore: () => context.go('/transactions'),
          ),
          const SizedBox(height: 12),
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Aucune transaction',
                  style: TextStyle(
                    color: kTextSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: kBgCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kNavyDark.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(
                  transactions.length > 5 ? 5 : transactions.length,
                  (i) {
                    final t = transactions[i];
                    final isLast = i == (transactions.length > 5 ? 4 : transactions.length - 1);
                    final isCredit = t.type == 'credit';
                    final icon = isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;

                    final activity = _Activity(
                      t.destinataire ?? 'Transaction',
                      t.categorie?.libelle ?? 'Sans catégorie',
                      t.montant ?? '0.00',
                      isCredit,
                      t.dateEmission?.toString().split(' ')[0] ?? '',
                      icon,
                    );

                    return Column(
                      children: [
                        _ActivityRow(activity: activity),
                        if (!isLast)
                          Divider(
                            height: 1,
                            indent: 72,
                            endIndent: 16,
                            color: kBgPage,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMore;

  const _SectionHeader({required this.title, required this.onMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onMore,
          child: const Text(
            'Voir tout',
            style: TextStyle(
              color: kTeal,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _KpiChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BankCard extends StatelessWidget {
  final String name;
  final String logo;
  final String balance;
  final List<Color> gradient;

  const _BankCard({
    required this.name,
    required this.logo,
    required this.balance,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(logo),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                balance,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: kTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final _Budget budget;
  const _BudgetRow({required this.budget});

  @override
  Widget build(BuildContext context) {
    final color = budgetBarColor(budget.progress);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  budget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary,
                  ),
                ),
              ),
              Text(
                '${budget.spent} €',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                ' / ${budget.total} €',
                style: const TextStyle(
                  fontSize: 12,
                  color: kTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: budget.progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: kBgPage,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final _Activity activity;
  const _ActivityRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isCredit = activity.isCredit;
    final amountColor = isCredit ? kSuccess : kDanger;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(activity.icon, color: amountColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${activity.amount} €',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                activity.date,
                style: const TextStyle(
                  fontSize: 11,
                  color: kTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Data models (local) ──────────────────────────────────────────────────────

class _Activity {
  final String title;
  final String category;
  final String amount;
  final bool isCredit;
  final String date;
  final IconData icon;

  const _Activity(
    this.title,
    this.category,
    this.amount,
    this.isCredit,
    this.date,
    this.icon,
  );
}

class _Budget {
  final String label;
  final double progress;
  final int spent;
  final int total;

  const _Budget(this.label, this.progress, this.spent, this.total);
}
