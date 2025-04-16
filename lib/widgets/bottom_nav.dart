import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';

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
            onPressed: () {
              UserModel.sessionUser = null;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()),);
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
              // TODO: Implement chatbot action
            },
            icon: const Icon(CupertinoIcons.chat_bubble_2_fill,
                color: Colors.white,),
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
