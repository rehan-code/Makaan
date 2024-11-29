import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).primaryColor.withOpacity(0.8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.9),
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.8),
                              Theme.of(context).scaffoldBackgroundColor,
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, -0.2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person,
                                    size: 50, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'John Doe',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildProfileInfo(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(height: 40),
                    ),
                    _buildAccountSettings(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(height: 40),
                    ),
                    _buildPreferences(),
                    const SizedBox(height: 24),
                    _buildLogoutButton(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoTile(Icons.email_outlined, 'john.doe@example.com'),
          _buildInfoTile(Icons.phone_outlined, '+1 234 567 890'),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            Icons.security_outlined,
            'Security',
            'Password, 2FA',
            onTap: () {},
          ),
          _buildSettingsTile(
            Icons.notifications_outlined,
            'Notifications',
            'Customize alerts',
            onTap: () {},
          ),
          _buildSettingsTile(
            Icons.payment_outlined,
            'Payment Methods',
            'Cards, digital wallets',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            Icons.language_outlined,
            'Language',
            'English (US)',
            onTap: () {},
          ),
          _buildSettingsTile(
            Icons.dark_mode_outlined,
            'Theme',
            'Light mode',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right, size: 22),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: () => _handleLogout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error logging out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
