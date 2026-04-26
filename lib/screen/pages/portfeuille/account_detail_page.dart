import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/account_model.dart';
import 'package:smarth_save/providers/account_provider.dart';

class AccountDetailPage extends StatefulWidget {
  final int accountId;
  final String bankName;

  const AccountDetailPage({
    super.key,
    required this.accountId,
    required this.bankName,
  });

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, _) {
        final account = accountProvider.getAccountById(widget.accountId);

        if (account == null) {
          return Scaffold(
            backgroundColor: kBgPage,
            appBar: AppBar(
              backgroundColor: kNavyDark,
              title: const Text('Compte non trouvé'),
            ),
            body: const Center(
              child: Text('Ce compte n\'existe pas'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: kBgPage,
          body: CustomScrollView(
            slivers: [
              _buildHeader(account),
              SliverToBoxAdapter(child: _buildBalanceCard(account)),
              SliverToBoxAdapter(child: _buildAccountInfo(account)),
              SliverToBoxAdapter(child: _buildHistoryPlaceholder()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  SliverAppBar _buildHeader(Account account) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: kNavyDark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: kHeaderGradient),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      account.estEpargne ? Icons.savings : Icons.payment,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.bankName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (account.estEpargne)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kSuccess.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kSuccess.withValues(alpha: 0.5)),
                      ),
                      child: const Text(
                        'Épargne',
                        style: TextStyle(
                          color: kSuccess,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Balance Card ─────────────────────────────────────────────────────────────

  Widget _buildBalanceCard(Account account) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kNavyDark.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solde actuel',
              style: TextStyle(
                fontSize: 12,
                color: kTextSecondary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${account.solde?.toStringAsFixed(2) ?? '0.00'} €',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: kTeal,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Type de compte',
                    value: account.getAccountTypeLabel(),
                    icon: Icons.category_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatItem(
                    label: 'Devise',
                    value: 'EUR',
                    icon: Icons.euro_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Account Info ─────────────────────────────────────────────────────────────

  Widget _buildAccountInfo(Account account) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _InfoRow(
                  label: 'Nom du compte',
                  value: account.name,
                ),
                const Divider(height: 16, color: kBgPage),
                _InfoRow(
                  label: 'Type',
                  value: account.type,
                ),
                const Divider(height: 16, color: kBgPage),
                _InfoRow(
                  label: 'Sous-type',
                  value: account.subtype ?? 'N/A',
                ),
                const Divider(height: 16, color: kBgPage),
                _InfoRow(
                  label: 'Solde initial',
                  value: '${account.solde?.toStringAsFixed(2) ?? '0.00'} €',
                  isHighlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── History Placeholder ──────────────────────────────────────────────────────

  Widget _buildHistoryPlaceholder() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historique des soldes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBgPage),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.show_chart_outlined,
                  size: 40,
                  color: kTextSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'Données en cours de chargement',
                  style: TextStyle(
                    fontSize: 13,
                    color: kTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Les historiques de solde seront bientôt disponibles',
                  style: TextStyle(
                    fontSize: 12,
                    color: kTextSecondary.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Item ────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: kTextSecondary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: kTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: kTextPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── Info Row ──────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: kTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            color: isHighlight ? kTeal : kTextPrimary,
          ),
        ),
      ],
    );
  }
}
