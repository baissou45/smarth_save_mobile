import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/account_model.dart';
import 'package:smarth_save/providers/account_provider.dart';
import 'package:smarth_save/widgets/skeleton_loader.dart';
import 'package:smarth_save/widgets/plaid_link_button.dart';
import 'package:smarth_save/widgets/bank_logo_widget.dart';
import 'account_detail_page.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    super.initState();
    // Charge les comptes au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().loadAccountsGroupedByBank();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgPage,
      body: Consumer<AccountProvider>(
        builder: (context, accountProvider, _) {
          return LiquidPullToRefresh(
            onRefresh: () => accountProvider.loadAccountsGroupedByBank(),
            color: kNavyDark,
            backgroundColor: kBgPage,
            height: 80,
            animSpeedFactor: 2,
            showChildOpacityTransition: false,
            child: NestedScrollView(
              headerSliverBuilder: (_, __) => [_buildHeader(context, accountProvider)],
              body: accountProvider.isLoading
                  ? _buildLoadingList()
                  : accountProvider.errorMessage != null
                      ? _buildErrorWidget(accountProvider)
                      : accountProvider.banks.isEmpty
                          ? _buildEmptyState()
                          : _buildBanksList(accountProvider),
            ),
          );
        },
      ),
      floatingActionButton: PlaidLinkButton(
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Banque ajoutée avec succès!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onCancel: () {
          // Optional: handle cancel
        },
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────────

  SliverAppBar _buildHeader(BuildContext context, AccountProvider accountProvider) {
    return SliverAppBar(
      expandedHeight: 200,
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
                'Portefeuille',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              // Patrimoine card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Patrimoine total',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      accountProvider.patrimoine.toStringAsFixed(2) + ' €',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatPill(
                    label: 'Banques',
                    value: '${accountProvider.banks.length}',
                    icon: Icons.account_balance,
                    color: kTealLight,
                  ),
                  const SizedBox(width: 10),
                  _StatPill(
                    label: 'Comptes',
                    value: accountProvider.banks.fold<int>(
                      0,
                      (sum, bank) => sum + bank.accounts.length,
                    ).toString(),
                    icon: Icons.account_balance_wallet_outlined,
                    color: kOrange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Loading ───────────────────────────────────────────────────────────────────

  Widget _buildLoadingList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => SkeletonLoader(
        isLoading: true,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: kBgCard,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // ─── Error ────────────────────────────────────────────────────────────────────

  Widget _buildErrorWidget(AccountProvider accountProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: kDanger),
            const SizedBox(height: 16),
            const Text(
              'Erreur lors du chargement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              accountProvider.errorMessage ?? 'Une erreur est survenue',
              style: const TextStyle(
                fontSize: 12,
                color: kTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<AccountProvider>().loadAccountsGroupedByBank(),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty state ──────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 48, color: kTextSecondary),
            const SizedBox(height: 16),
            const Text(
              'Aucune banque connectée',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Commencez par lier votre première banque pour voir vos comptes et votre patrimoine',
              style: TextStyle(
                fontSize: 12,
                color: kTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Banks list ───────────────────────────────────────────────────────────────

  Widget _buildBanksList(AccountProvider accountProvider) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: accountProvider.banks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _BankCard(bank: accountProvider.banks[i]),
    );
  }
}

// ─── Bank Card (Expandable) ──────────────────────────────────────────────────

class _BankCard extends StatefulWidget {
  final Bank bank;
  const _BankCard({required this.bank});

  @override
  State<_BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<_BankCard> with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = true; // Starts expanded

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _expandController, curve: Curves.easeInOut),
    );
    // Démarre en position expanded
    _expandController.forward();
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
      child: Column(
        children: [
          // Bank header (clickable)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpand,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    BankLogoWidget(
                      bankName: widget.bank.institutionName,
                      logoUrl: widget.bank.institutionLogo,
                      brandColor: widget.bank.brandColor,
                      size: 48,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bank.institutionName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.bank.accounts.length} compte${widget.bank.accounts.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${widget.bank.getTotalBalance().toStringAsFixed(2)} €',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _parseBrandColor(widget.bank.brandColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    RotationTransition(
                      turns: _expandAnimation,
                      child: const Icon(Icons.expand_more, color: kTextSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Accounts list (animated)
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                const Divider(height: 1, color: kBgPage),
                ...widget.bank.accounts.map(
                  (account) => _AccountItem(
                    account: account,
                    bankName: widget.bank.institutionName,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _parseBrandColor(String? hexColor) {
    if (hexColor == null) return kTeal;
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    } catch (_) {
      return kTeal;
    }
  }
}

// ─── Account Item ─────────────────────────────────────────────────────────────

class _AccountItem extends StatelessWidget {
  final Account account;
  final String bankName;

  const _AccountItem({
    required this.account,
    required this.bankName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AccountDetailPage(
                accountId: account.id,
                bankName: bankName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: account.estEpargne ? kSuccess.withValues(alpha: 0.12) : kNavyMid.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  account.estEpargne ? Icons.savings : Icons.payment,
                  color: account.estEpargne ? kSuccess : kNavyMid,
                  size: 20,
                ),
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
                            account.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: kTextPrimary,
                            ),
                          ),
                        ),
                        if (account.estEpargne)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: kSuccess.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Épargne',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: kSuccess,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account.getAccountTypeLabel(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: kTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                account.formatBalance(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kTextPrimary,
                ),
              ),
            ],
          ),
        ),
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
