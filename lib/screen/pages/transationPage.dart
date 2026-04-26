import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
  final ScrollController _scrollController = ScrollController();

  List<TransactionModel> _all = [];
  List<TransactionModel> _filtered = [];
  String _selectedFilter = '';
  String _selectedType = 'Tout'; // 'Tout', 'Entrées', 'Sorties'
  String _searchQuery = '';

  static const int _pageSize = 50;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _currentPage = 1;
        _applyFilters();
      });
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore && _currentPage * _pageSize < _filtered.length) {
        setState(() {
          _isLoadingMore = true;
          _currentPage++;
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) setState(() => _isLoadingMore = false);
          });
        });
      }
    }
  }

  Future<void> _load() async {
    final provider = context.read<Transactionprovider>();
    provider.setLoading(true);
    final list = await _controllers.getTransaction(context);
    if (!mounted) return;
    setState(() {
      _all = list;
      _filtered = list;
      _currentPage = 1;
    });
    provider.setLoading(false);
  }

  void _setFilter(String f) {
    setState(() {
      _selectedFilter = _selectedFilter == f ? '' : f;
      _applyFilters();
    });
  }

  void _setType(String type) {
    setState(() {
      _selectedType = type;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final now = DateTime.now();
    _filtered = _all.where((t) {
      // 1. Filter by type (credit/debit)
      final json = t.toJson();
      if (_selectedType == 'Entrées') {
        if (json['type'] != 'credit') return false;
      } else if (_selectedType == 'Sorties') {
        if (json['type'] != 'debit') return false;
      }

      // 2. Search
      if (_searchQuery.isNotEmpty) {
        final label = (json['institution']?['libelle'] ?? '').toString().toLowerCase();
        final cat   = (json['categorie']?['libelle']  ?? '').toString().toLowerCase();
        if (!label.contains(_searchQuery) && !cat.contains(_searchQuery)) return false;
      }
      
      // 3. Date filter
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

  // Group transactions by date label with pagination
  Map<String, List<TransactionModel>> _grouped() {
    final endIndex = (_currentPage * _pageSize).clamp(0, _filtered.length);
    final paginated = _filtered.sublist(0, endIndex);

    final map = <String, List<TransactionModel>>{};
    for (final t in paginated) {
      final raw = t.toJson()['dateEmission'];
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
                ? _buildSkeletonLoader()
                : _filtered.isEmpty
                    ? RefreshIndicator(
                        onRefresh: _load,
                        color: kTeal,
                        backgroundColor: Colors.white,
                        child: _buildEmpty(),
                      )
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: kTeal,
                        backgroundColor: Colors.white,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: keys.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (ctx, i) {
                            if (i == keys.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator(color: kTeal),
                                ),
                              );
                            }
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
          ),
        ],
      ),
    );
  }

  // ─── Skeleton Loader ─────────────────────────────────────────────────────────

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: 6,
      itemBuilder: (ctx, i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Shimmer.fromColors(
                baseColor: kBgCard,
                highlightColor: Colors.white.withValues(alpha: 0.1),
                child: Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: kBgCard,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Container(
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
              child: Shimmer.fromColors(
                baseColor: kBgCard,
                highlightColor: Colors.white.withValues(alpha: 0.1),
                child: Column(
                  children: List.generate(2, (j) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: kBgPage,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: kBgPage,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 10,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: kBgPage,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 12,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: kBgPage,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 10,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: kBgPage,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (j == 0)
                          const Divider(
                            height: 1,
                            indent: 72,
                            endIndent: 16,
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  // ─── Top section ─────────────────────────────────────────────────────────────

  Widget _buildTopSection(BuildContext context) {
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
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mes activités',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Transactions',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _HeaderAction(
                        icon: Icons.add_rounded,
                        onTap: () => context.push('/creatTransaction'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Search Bar Modernisée
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.poppins(
                    color: kTextPrimary,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un marchand, catégorie...',
                    hintStyle: GoogleFonts.poppins(
                      color: kTextSecondary.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: kTeal,
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => _searchController.clear(),
                            color: kTextSecondary,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Type Selector (Entrées / Sorties)
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: ['Tout', 'Entrées', 'Sorties'].map((type) {
                    final active = _selectedType == type;
                    final isEntree = type == 'Entrées';
                    final isSortie = type == 'Sorties';
                    
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _setType(type),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: active ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: active ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ] : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isEntree) Icon(Icons.arrow_downward_rounded, size: 14, color: active ? kSuccess : Colors.white70),
                              if (isSortie) Icon(Icons.arrow_upward_rounded, size: 14, color: active ? kDanger : Colors.white70),
                              if (isEntree || isSortie) const SizedBox(width: 4),
                              Text(
                                type,
                                style: GoogleFonts.poppins(
                                  color: active 
                                      ? (isEntree ? kSuccess : (isSortie ? kDanger : kNavyDark))
                                      : Colors.white70,
                                  fontSize: 13,
                                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Filter Label
              Row(
                children: [
                  const Icon(Icons.tune_rounded, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Filtrer par période',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Filter Chips Modernisées
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: ['Tout', 'Jour', 'Semaine', 'Mois', 'Année'].map((f) {
                    final filterValue = f == 'Tout' ? '' : f;
                    final active = _selectedFilter == filterValue;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => _setFilter(filterValue),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: active
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            f,
                            style: GoogleFonts.poppins(
                              color: active ? kNavyDark : Colors.white,
                              fontSize: 13,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
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
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 100),
        Center(
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
        ),
      ],
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
