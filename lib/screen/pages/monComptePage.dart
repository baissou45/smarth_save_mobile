import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';

class MonComptePage extends StatelessWidget {
  const MonComptePage({super.key});

  static const _menuItems = [
    _MenuItem(Icons.person_outline_rounded, 'Modifier le profil', '/modifProfile', kTeal),
    _MenuItem(Icons.lock_outline_rounded, 'Mot de passe', '/modifMotPass', Color(0xFF7C3AED)),
    _MenuItem(Icons.notifications_outlined, 'Notifications', '/notification', kOrange),
    _MenuItem(Icons.smart_toy_outlined, 'SmartBot', '/chatbot', kNavyMid),
    _MenuItem(Icons.help_outline_rounded, 'Aide & support', '/contact', Color(0xFF0EA5E9)),
  ];

  @override
  Widget build(BuildContext context) {
    final user = UserModel.sessionUser;
    final name  = '${user?.prenom ?? ''} ${user?.nom ?? ''}'.trim();
    final email = user?.email ?? '';
    final initials = _initials(name);

    return Scaffold(
      backgroundColor: kBgPage,
      body: CustomScrollView(
        slivers: [
          _buildHeader(initials, name, email),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  const Text(
                    'Compte',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kTextSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuCard(context),
                  const SizedBox(height: 24),
                  _buildLogout(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  SliverToBoxAdapter _buildHeader(String initials, String name, String email) {
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
              children: [
                const Text(
                  'Mon profil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
                Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kTeal, kTealLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: kOrange,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  name.isEmpty ? 'Mon compte' : name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Stats ────────────────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    return const Row(
      children: [
        _StatCard(value: '6', label: 'Projets', color: kTeal),
        SizedBox(width: 10),
        _StatCard(value: '147', label: 'Transactions', color: kOrange),
        SizedBox(width: 10),
        _StatCard(value: '3', label: 'Banques', color: Color(0xFF7C3AED)),
      ],
    );
  }

  // ─── Menu ─────────────────────────────────────────────────────────────────────

  Widget _buildMenuCard(BuildContext context) {
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
        children: List.generate(_menuItems.length, (i) {
          final item   = _menuItems[i];
          final isLast = i == _menuItems.length - 1;
          return Column(
            children: [
              _MenuRow(item: item, onTap: () => context.go(item.route)),
              if (!isLast)
                const Divider(height: 1, indent: 60, endIndent: 16, color: kBgPage),
            ],
          );
        }),
      ),
    );
  }

  // ─── Logout ───────────────────────────────────────────────────────────────────

  Widget _buildLogout(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserModel.sessionUser?.logout();
        context.go('/login');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: kDanger.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDanger.withValues(alpha: 0.2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: kDanger, size: 20),
            SizedBox(width: 10),
            Text(
              'Se déconnecter',
              style: TextStyle(
                color: kDanger,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
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
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: kTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _MenuRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: kTextHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _initials(String name) {
  final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const _MenuItem(this.icon, this.label, this.route, this.color);
}
