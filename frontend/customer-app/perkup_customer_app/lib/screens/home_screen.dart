import 'package:flutter/material.dart';
import 'package:perkup_customer_app/models/login/login_response.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String?> _getDisplayName() async {
    try {
      final LoginResponse? loginResponse =
          await LoginResponse.loadFromPreferences();
      return loginResponse?.displayName;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      drawer: FutureBuilder<String?>(
        future: _getDisplayName(),
        builder: (context, snapshot) {
          String displayName = snapshot.data ?? 'User';

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Welcome, $displayName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.settings),
                //   title: const Text('Settings'),
                //   onTap: () {
                //     Navigator.pushNamed(context, '/settings');
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.help),
                //   title: const Text('Help & Support'),
                //   onTap: () {
                //     Navigator.pushNamed(context, '/help');
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildCard(
              context,
              icon: Icons.local_offer,
              title: 'Offers',
              onTap: () {
                Navigator.pushNamed(context, '/offers');
              },
            ),
            _buildCard(
              context,
              icon: Icons.card_giftcard,
              title: 'Discounts',
              onTap: () {
                Navigator.pushNamed(context, '/discounts');
              },
            ),
            _buildCard(
              context,
              icon: Icons.card_giftcard,
              title: 'Vouchers',
              onTap: () {
                Navigator.pushNamed(context, '/vouchers');
              },
            ),
            _buildCard(
              context,
              icon: Icons.restaurant_menu,
              title: 'Restaurants',
              onTap: () {
                Navigator.pushNamed(context, '/restaurants');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50.0,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 10.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
