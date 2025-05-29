import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteWithNestedNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RouteWithNestedNavigation(this.navigationShell, {super.key});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(label: 'Blog', icon: Icon(Icons.book)),
          NavigationDestination(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
