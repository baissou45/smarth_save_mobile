import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF009688),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings action
            },
          ),
        ],
      ),
      
      
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationCard(
            'Projets',
            'Nouveau projet ajouté avec succès !!',
            'Maintenant',
            Icons.folder,
          ),
          _buildNotificationCard(
            'Projets',
            'Votre rapport mensuel est disponible',
            'il y a 10 minutes',
            Icons.description,
          ),
          _buildNotificationCard(
            'Projets',
            'Mettez à jour vos projets pour les mois à venir',
            'il y a 2 heures',
            Icons.update,
          ),
          _buildAlertNotificationCard(
            'Alerte',
            'Attention vos dépenses alimentaires ont atteint le seuil fixé pour ce mois',
            'il y a 3 jours',
          ),
          _buildNotificationCard(
            'Service',
            'Félicitations ! ! votre nouvelle banque a été ajouté avec succès',
            '19/11/2024',
            Icons.account_balance,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    String category,
    String message,
    String time,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(message),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            time,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertNotificationCard(
    String category,
    String message,
    String time,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(
          Icons.warning,
          color: Colors.red,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(message),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            time,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
