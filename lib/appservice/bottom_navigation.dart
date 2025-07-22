import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../categories_page.dart';
import '../home/presentation/screens/home.dart';
import '../injection/injection.dart';
import '../profile.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [

    BlocProvider(
      create: (context) => getIt<ProductBloc>()..add(FetchProducts()),
      child: const Home(),
    ),
    BlocProvider(
      create: (context) => getIt<ProductBloc>()..add(FetchProducts()),
      child: const Center(child: Text('Search Screen')),
    ),

    //const Center(child: Text('Search Screen')),
    BlocProvider(
      create: (context) => getIt<ProductBloc>()..add(FetchProducts()),
      child: const CategoriesPage(),
    ),
    //const Center(child: Text('Categories Screen')),
    BlocProvider(
      create: (context) => getIt<ProductBloc>()..add(FetchProducts()),
      child: const ProfilePage(),
    ),
    //const ProfilePage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0019FF),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.explore, size: 20),
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.search, size: 20),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.grid_view_rounded, size: 20),
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.person, size: 20),
            ),
            label: 'Profile',
          ),
        ],
      ),

    );
  }
}
