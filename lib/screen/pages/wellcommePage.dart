import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/providers/account_provider.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/providers/transactionProvider.dart';
import 'package:smarth_save/providers/categorie_provider.dart';
import 'package:smarth_save/providers/money_visibility_provider.dart';
import 'package:smarth_save/models/transation_model.dart';

class Wellcommepage extends StatelessWidget {
  const Wellcommepage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load data once on first build
    Future.microtask(() {
      context.read<AccountProvider>().loadAccountsGroupedByBank();
      context.read<Transactionprovider>().getTransactions();
      context.read<CategorieProvider>().loadUserCategories();
    });

    return Scaffold(
      backgroundColor: kBgPage,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final firstName = userProvider.user?.prenom ?? 'vous';
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _HeaderSection(firstName: firstName)),
              const SliverToBoxAdapter(child: _BankCardsSection()),
              const SliverToBoxAdapter(child: _QuickActionsSection()),
              const SliverToBoxAdapter(child: _BudgetSection()),
              const SliverToBoxAdapter(child: _RecentTransactionsSection()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}

// ─── Header Section ──────────────────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  final String firstName;

  const _HeaderSection({required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    onTap: () => context.push('/notification'),
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
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  final totalBalance =
                      userProvider.user?.patrimoineEpargne ?? 0.0;
                  return _BalanceCard(totalBalance: totalBalance);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Balance Card ────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final double totalBalance;

  const _BalanceCard({required this.totalBalance});

  double _calculateMonthlyIncome(List<TransactionModel?> transactions) {
    return transactions.where((t) => t?.type == 'credit').fold(
        0.0, (sum, t) => sum + (double.tryParse(t?.montant ?? '0') ?? 0.0));
  }

  double _calculateMonthlyExpenses(List<TransactionModel?> transactions) {
    return transactions.where((t) => t?.type == 'debit').fold(
        0.0, (sum, t) => sum + (double.tryParse(t?.montant ?? '0') ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Total balance card
        Consumer2<MoneyVisibilityProvider, UserProvider>(
          builder: (context, moneyVisibilityProvider, userProvider, _) {
            final isVisible = moneyVisibilityProvider.isBalanceVisible;
            final userPatrimoine = userProvider.user?.patrimoineTotal ?? 0.0;

            return Container(
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
                        onTap: () => moneyVisibilityProvider.toggleBalance(),
                        child: Icon(
                          isVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isVisible
                        ? Text(
                            '${userPatrimoine.toStringAsFixed(2)} €',
                            key: const ValueKey('visible'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          )
                        : const Text(
                            '••••••',
                            key: const ValueKey('hidden'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Income and Expenses row
        Consumer2<Transactionprovider, MoneyVisibilityProvider>(
          builder: (context, transactionProvider, moneyVisibilityProvider, _) {
            final isVisible = moneyVisibilityProvider.isBalanceVisible;
            final income =
                _calculateMonthlyIncome(transactionProvider.transactions);
            final expenses =
                _calculateMonthlyExpenses(transactionProvider.transactions);

            return Row(
              children: [
                Expanded(
                  child: _MonthlyCard(
                    title: 'Entrées du mois',
                    amount: income,
                    icon: Icons.arrow_downward_rounded,
                    color: kSuccess,
                    isVisible: isVisible,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MonthlyCard(
                    title: 'Dépenses du mois',
                    amount: expenses,
                    icon: Icons.arrow_upward_rounded,
                    color: kDanger,
                    isVisible: isVisible,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ─── Bank Cards Section ──────────────────────────────────────────────────────

class _BankCardsSection extends StatelessWidget {
  const _BankCardsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: _SectionHeader(
              title: 'Mes banques',
              onMore: () {},
            ),
          ),
          const SizedBox(height: 12),
          Consumer<AccountProvider>(
            builder: (context, accountProvider, _) {
              if (accountProvider.isLoading) {
                return SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 24),
                    children: const [
                      _SkeletonCard(),
                      SizedBox(width: 12),
                      _SkeletonCard(),
                    ],
                  ),
                );
              }

              if (accountProvider.errorMessage != null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Erreur de chargement',
                        style: TextStyle(
                          color: kDanger,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () =>
                            accountProvider.loadAccountsGroupedByBank(),
                        icon: const Icon(Icons.refresh, size: 14),
                        label: const Text('Réessayer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDanger,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final banks = accountProvider.banks;
              final gradients = const [
                [Color(0xFF1A5F7A), Color(0xFF0F3D52)], // Patrimoine gradient
                [Color(0xFF006E4E), Color(0xFF00A36C)], // BNP
                [Color(0xFF8B0000), Color(0xFFCC2200)], // SG
                [Color(0xFF0066CC), Color(0xFF0099FF)], // CA
                [Color(0xFF667BC6), Color(0xFF7B68EE)], // Revolut
              ];

              return SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 24),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: banks.length + 1,
                  itemBuilder: (_, index) {
                    // First card: Patrimoine épargne
                    if (index == 0) {
                      return _PatrimoineCard(
                        patrimoine: accountProvider.patrimoine,
                        bankCount: banks.length,
                        accountCount: banks.fold<int>(
                          0,
                          (sum, bank) => sum + bank.accounts.length,
                        ),
                      );
                    }

                    // Bank cards
                    final bank = banks[index - 1];
                    final gradientIndex = (index % (gradients.length - 1)) + 1;
                    return _BankCard(
                      name: bank.institutionName,
                      balance: bank.getTotalBalance().toStringAsFixed(2),
                      gradient: gradients[gradientIndex],
                      logo: bank.institutionLogo,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions Section ───────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
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
            onTap: () => context.go('/projet'),
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
}

// ─── Budget Section ──────────────────────────────────────────────────────────

class _BudgetSection extends StatelessWidget {
  const _BudgetSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Budget du mois', onMore: null),
          const SizedBox(height: 12),
          Consumer<CategorieProvider>(
            builder: (context, categorieProvider, _) {
              final categories = categorieProvider.userCategories;

              if (categories.isEmpty) {
                return Padding(
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
                );
              }

              return Container(
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
                      final isLast = i ==
                          (categories.length > 3 ? 2 : categories.length - 1);
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
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Recent Transactions Section ──────────────────────────────────────────────

class _RecentTransactionsSection extends StatelessWidget {
  const _RecentTransactionsSection();

  @override
  Widget build(BuildContext context) {
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
          Consumer<Transactionprovider>(
            builder: (context, transactionProvider, _) {
              final transactions = transactionProvider.transactions;

              if (transactions.isEmpty) {
                return Padding(
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
                );
              }

              return Container(
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
                      final isLast = i ==
                          (transactions.length > 5
                              ? 4
                              : transactions.length - 1);
                      final isCredit = t.type == 'credit';
                      final icon = isCredit
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded;
                      final accountName = t.account?.name ??
                          t.categorie?.libelle ??
                          'Sans compte';

                      final activity = _Activity(
                        t.destinataire ?? 'Transaction',
                        accountName,
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
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;

  const _SectionHeader({required this.title, this.onMore});

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
        if (onMore != null)
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

// ─── Monthly Card (Income/Expenses) ──────────────────────────────────────────

class _MonthlyCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isVisible;

  const _MonthlyCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: kTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isVisible
                ? Text(
                    '${amount.toStringAsFixed(2)} €',
                    key: const ValueKey('visible'),
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : const Text(
                    '••••••',
                    key: ValueKey('hidden'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PatrimoineCard extends StatefulWidget {
  final double patrimoine;
  final int bankCount;
  final int accountCount;

  const _PatrimoineCard({
    required this.patrimoine,
    required this.bankCount,
    required this.accountCount,
  });

  @override
  State<_PatrimoineCard> createState() => _PatrimoineCardState();
}

class _PatrimoineCardState extends State<_PatrimoineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: GestureDetector(
          onTap: () => context.push('/accounts'),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 220,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A5F7A), Color(0xFF0F3D52)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A5F7A).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patrimoine épargne',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.trending_up_rounded,
                        size: width * 0.035,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.patrimoine.toStringAsFixed(2)} €',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        '${widget.bankCount} banque${widget.bankCount != 1 ? 's' : ''} • ${widget.accountCount} comptes',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: width * 0.025,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BankCard extends StatefulWidget {
  final String name;
  final String balance;
  final List<Color> gradient;
  final logo;

  const _BankCard({
    required this.name,
    required this.balance,
    required this.gradient,
    required this.logo,
  });

  @override
  State<_BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<_BankCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () => context.push('/accounts'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.first.withValues(
                      alpha: _isHovered ? 0.5 : 0.3,
                    ),
                    blurRadius: _isHovered ? 16 : 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (widget.logo != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(widget.logo!, width: 50, height: 50),
                    )
                  else
                    const Icon(Icons.account_balance, color: Colors.white, size: 24),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        '${widget.balance} €',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(18),
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

// ─── Helper function ─────────────────────────────────────────────────────────

Color budgetBarColor(double progress) {
  if (progress >= 0.9) return kDanger;
  if (progress >= 0.7) return kOrange;
  return kSuccess;
}
