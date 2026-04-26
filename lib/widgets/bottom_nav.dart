import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/providers/userProvider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      color: const Color(0xFF009688),
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () async {
              await context.read<UserProvider>().logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            width: 1,
            color: Colors.white.withOpacity(0.5),
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          TextButton.icon(
            onPressed: () {
              GoRouter.of(context).go('/chatbot');
            },
            icon: const Icon(CupertinoIcons.chat_bubble_2_fill,
                color: Colors.white),
            label: const Text(
              'ChatBot',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
