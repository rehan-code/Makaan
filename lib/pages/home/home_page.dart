import 'package:flutter/material.dart';
import 'package:makaan/pages/home/tabs/offers_page.dart';
import 'package:makaan/pages/home/tabs/directory_page.dart';
import 'package:makaan/pages/home/tabs/account_page.dart';
import 'package:makaan/pages/business/business_dashboard_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isBusinessAccount = false;

  @override
  void initState() {
    super.initState();
    _checkBusinessAccount();
  }

  Future<void> _checkBusinessAccount() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final response = await Supabase.instance.client
          .from('profiles')
          .select('is_business')
          .eq('id', userId)
          .single();

      if (mounted) {
        setState(() {
          _isBusinessAccount = response['is_business'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Error checking business account: $e');
    }
  }

  List<Widget> get _pages => [
    const OffersPage(),
    const DirectoryPage(),
    if (_isBusinessAccount) const BusinessDashboardPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedIndex: _currentIndex,
        destinations: <NavigationDestination>[
          const NavigationDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          const NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Directory',
          ),
          if (_isBusinessAccount)
            const NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
