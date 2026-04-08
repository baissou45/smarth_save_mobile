import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/controllers/transation_controllers.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/transation_model.dart';
import 'package:smarth_save/providers/transactionProvider.dart';

class TransationPage extends StatefulWidget {
  const TransationPage({super.key});

  @override
  State<TransationPage> createState() => _TransationPageState();
}

class _TransationPageState extends State<TransationPage> {
  final TransationControllers _controllers = TransationControllers();
  final TextEditingController _searchController = TextEditingController();

  List<TransactionModel> _all = [];
  List<TransactionModel> _filtered = [];
  String _selectedFilter = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _applyFilters();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final provider = context.read<Transactionprovider>();
    provider.setLoading(true);
    final list = await _controllers.getTransaction(context);
    if (!mounted) return;
    setState(() {
      _all = list;
      _filtered = list;
    });
    provider.setLoading(false);
  }

  void _setFilter(String f) {
    setState(() {
      _selectedFilter = _selectedFilter == f ? '' : f;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final now = DateTime.now();
    _filtered = _all.where((t) {
      // search
      if (_searchQuery.isNotEmpty) {
        final json = t.toJson();
        final label = (json['institution']?['libelle'] ?? '').toString().toLowerCase();
        final cat   = (json['categorie']?['libelle']  ?? '').toString().toLowerCase();
        if (!label.contains(_searchQuery) && !cat.contains(_searchQuery)) return false;
      }
      // date filter
      if (_selectedFilter.isEmpty) return true;
      final raw = t.toJson()['dateValidation'];
      if (raw == null) return false;
      final date = raw is String ? DateTime.tryParse(raw) : raw as DateTime?;
      if (date == null) return false;
      switch (_selectedFilter) {
        case 'Jour':
          return date.year == now.year && date.month == now.month && date.day == now.day;
        case 'Semaine':
          return date.isAfter(now.subtract(const Duration(days: 7)));
        case 'Mois':
          return date.year == now.year && date.month == now.month;
        case 'Année':
          return date.year == now.year;
      }
      return true;
    }).toList();
  }

  // Group transactions by date label
  Map<String, List<TransactionModel>> _grouped() {
    final map = <String, List<TransactionModel>>{};
    for (final t in _filtered) {
      final raw = t.toJson()['dateValidation'];
      String key = 'Date inconnue';
      if (raw != null) {
        final date = raw is String ? DateTime.tryParse(raw) : raw as DateTime?;
        if (date != null) {
          final now = DateTime.now();
          if (date.year == now.year && date.month == now.month && date.day == now.day) {
            key = "Aujourd'hui";
          } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
            key = 'Hier';
          } else {
            key = DateFormat('d MMMM yyyy', 'fr_FR').format(date);
          }
        }
      }
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Transactionprovider>();
    final grouped = _grouped();
    final keys    = grouped.keys.toList();

    return Scaffold(
      backgroundColor: kBgPage,
      body: Column(
        children: [
          _buildTopSection(context),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator(color: kTeal))
                : _filtered.isEmpty
                    ? _buildEmpty()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: keys.length,
                        itemBuilder: (ctx, i) {
                          final group = grouped[keys[i]]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DateHeader(label: keys[i]),
                              _TransactionGroup(transactions: group),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ─── Top section ─────────────────────────────────────────────────────────────

  Widget _buildTopSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: kHeaderGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Transactions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _HeaderAction(
                    icon: Icons.add_rounded,
                    onTap: () => context.push('/creatTransaction'),
                  ),
                  const SizedBox(width: 8),
                  _HeaderAction(
                    icon: Icons.filter_alt_outlined,
                    onTap: () => context.push('/transaction/debit'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Search
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Rechercher une transaction...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Jour', 'Semaine', 'Mois', 'Année'].map((f) {
                    final active = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _setFilter(f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              color: active ? kNavyDark : Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: kTextHint),
          SizedBox(height: 16),
          Text(
            'Aucune transaction',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: kTextSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _TransactionGroup extends StatelessWidget {
  final List<TransactionModel> transactions;
  const _TransactionGroup({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kNavyDark.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(transactions.length, (i) {
          final t    = transactions[i];
          final json = t.toJson();
          final isLast = i == transactions.length - 1;
          return Column(
            children: [
              _TxRow(json: json),
              if (!isLast)
                Divider(height: 1, indent: 72, endIndent: 16, color: kBgPage),
            ],
          );
        }),
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  final Map<String, dynamic> json;
  const _TxRow({required this.json});

  @override
  Widget build(BuildContext context) {
    final isCredit = json['type'] == 'credit';
    final color    = isCredit ? kSuccess : kDanger;
    final amount   = json['montant'] ?? 0;
    final label    = json['institution']?['libelle'] ?? 'Transaction';
    final cat      = json['categorie']?['libelle']   ?? '';
    final rawDate  = json['dateValidation'];
    String dateStr = '';
    if (rawDate != null) {
      final d = rawDate is String ? DateTime.tryParse(rawDate) : rawDate as DateTime?;
      if (d != null) dateStr = DateFormat('HH:mm').format(d);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary,
                  ),
                ),
                if (cat.isNotEmpty)
                  Text(
                    cat,
                    style: const TextStyle(fontSize: 12, color: kTextSecondary),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}$amount €',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (dateStr.isNotEmpty)
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 11, color: kTextSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
