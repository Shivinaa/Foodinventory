import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55ab55), // Changed to updated green
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            // decoration: const BoxDecoration(
            //   color: Color(0xFF55ab55), // Changed to updated green
            //   borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(30),
            //     bottomRight: Radius.circular(30),
            //   ),
            // ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "https://api.dicebear.com/9.x/adventurer/png?seed=${auth!.displayName.toString()}"), // Change as needed
                ),
                const SizedBox(height: 15),
                Text(
                  auth.displayName.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  auth.email.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                SectionTitle(title: "CONTENT"),
                ProfileMenuItem(title: "Phone Number", icon: Icons.phone),
                ProfileMenuItem(title: "Saved Recipes", icon: Icons.bookmark),
                ProfileMenuItem(title: "FAQ's", icon: Icons.help),
                ProfileMenuItem(
                    title: "Shopping List", icon: Icons.shopping_cart),
                ProfileMenuItem(title: "Logout", icon: Icons.exit_to_app),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const ProfileMenuItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF55ab55)
                .withOpacity(0.1), // Changed to updated green
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon,
              color: const Color(0xFF55ab55)), // Changed to updated green
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF55ab55), // Changed to updated green
        ),
        onTap: () {},
      ),
    );
  }
}
