import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'pages/home_page.dart';
import 'pages/favorites_page.dart';
import 'pages/notifications_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Igreja',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: FTheme(
        data: FThemes.zinc.light,
        child: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    FavoritesPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colors.background,
        selectedItemColor: theme.colors.primary,
        unselectedItemColor: theme.colors.mutedForeground,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FIcons.star),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(FIcons.bell),
            label: 'Notificações',
          ),
          BottomNavigationBarItem(
            icon: Icon(FIcons.user),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
