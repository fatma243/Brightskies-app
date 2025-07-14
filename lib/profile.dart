import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.black,
                  child: Text(
                    'FA',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fatma Galal',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '01xxxxxxx',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: ListView(
              children: const [
                ProfileMenuItem(icon: Icons.shopping_bag, title: 'My orders'),
                ProfileMenuItem(icon: Icons.location_on, title: 'Saved Addresses'),
                ProfileMenuItem(icon: Icons.favorite, title: 'Favorites'),
                ProfileMenuItem(icon: Icons.feedback, title: 'Feedback'),
                ProfileMenuItem(icon: Icons.call, title: 'Call support', trailingText: '1234'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: trailingText != null
          ? Text(
        trailingText!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      )
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {

      },
    );
  }
}
