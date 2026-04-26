import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/theme/colors.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  static const _items = [
    _NavItemData(icon: Icons.home_rounded, label: 'Accueil'),
    _NavItemData(icon: Icons.account_balance_wallet_rounded, label: 'Budget'),
    _NavItemData(icon: Icons.savings_rounded, label: 'Projets'),
    _NavItemData(icon: Icons.receipt_long_rounded, label: 'Transactions'),
    _NavItemData(icon: Icons.person_rounded, label: 'Profil'),
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: kNavyDark,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kNavyDark.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(_items.length, (i) {
                final isActive = i == navigationShell.currentIndex;
                return _NavItem(
                  data: _items[i],
                  isActive: isActive,
                  onTap: () => navigationShell.goBranch(
                    i,
                    initialLocation: i == navigationShell.currentIndex,
                  ),
                );
              }),
              // Chatbot button - special styling
              GestureDetector(
                onTap: () => context.go('/chatbot'),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BCD4).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00BCD4),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Color(0xFF00BCD4),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData({required this.icon, required this.label});
}

class _NavItem extends StatelessWidget {
  final _NavItemData data;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? kTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: isActive
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(data.icon, color: Colors.white, size: 19),
                  const SizedBox(width: 6),
                  Text(
                    data.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              )
            : Icon(
                data.icon,
                color: Colors.white.withValues(alpha: 0.45),
                size: 22,
              ),
      ),
    );
  }
}
