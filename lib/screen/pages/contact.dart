import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CONTACT',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF009688),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildContactCard(
              context,
              'Messagerie',
              Icons.chat_bubble_outline,
              () {
                // TODO: Implement messagerie action
              },
            ),
            _buildContactCard(
              context,
              'Téléphone',
              Icons.phone_outlined,
              () {
                // TODO: Implement téléphone action
              },
            ),
            _buildContactCard(
              context,
              'E-mail',
              Icons.email_outlined,
              () {
                // TODO: Implement email action
              },
            ),
            _buildContactCard(
              context,
              'Smartbot',
              Icons.smart_toy_outlined,
              () {
                // TODO: Implement smartbot action
              },
            ),
            _buildContactCard(
              context,
              'Urgence',
              Icons.warning_outlined,
              () {
                // TODO: Implement urgence action
              },
            ),
            _buildContactCard(
              context,
              'Nous rencontrer',
              Icons.calendar_today_outlined,
              () {
                // TODO: Implement rencontre action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF009688),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
