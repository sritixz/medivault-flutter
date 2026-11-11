import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import 'home/home_screen.dart';
import 'records/records_screen.dart';
import 'nearby/nearby_screen.dart';
import 'account/account_screen.dart';
import 'upload/upload_record_screen.dart';
import 'family/family_screen.dart';
import 'medicines/medicines_screen.dart';
import 'emergency/emergency_screen.dart';
import 'insurance/insurance_screen.dart';
import 'timeline/timeline_screen.dart';
import 'sharing/sharing_screen.dart';
import 'dental/dental_screen.dart';
import 'preventive/preventive_screen.dart';
import 'appointments/appointments_screen.dart';
import 'search/search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final AppState state;

  const MainNavigationScreen({super.key, required this.state});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToRoute(String route) {
    Widget screen;
    switch (route) {
      case 'upload':
        screen = UploadRecordScreen(
          state: widget.state,
          onCompleted: () {
            Navigator.pop(context);
            setState(() => _currentIndex = 1); // Go to Records tab
          },
        );
        break;
      case 'family':
        screen = FamilyScreen(state: widget.state);
        break;
      case 'medicines':
        screen = MedicinesScreen(state: widget.state);
        break;
      case 'emergency':
        screen = EmergencyScreen(state: widget.state);
        break;
      case 'insurance':
        screen = InsuranceScreen(state: widget.state);
        break;
      case 'timeline':
        screen = TimelineScreen(state: widget.state);
        break;
      case 'sharing':
        screen = SharingScreen(state: widget.state);
        break;
      case 'dental':
        screen = DentalScreen(state: widget.state);
        break;
      case 'preventive':
        screen = PreventiveScreen(state: widget.state);
        break;
      case 'appointments':
        screen = AppointmentsScreen(state: widget.state);
        break;
      case 'search':
        screen = SearchScreen(state: widget.state);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    final screens = [
      HomeScreen(
        state: state,
        onNavigateTab: (idx) => setState(() => _currentIndex = idx),
        onNavigateRoute: _navigateToRoute,
      ),
      RecordsScreen(
        state: state,
        onAddRecord: () => _navigateToRoute('upload'),
      ),
      NearbyScreen(state: state),
      AccountScreen(
        state: state,
        onNavigateRoute: _navigateToRoute,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.outline,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on),
            label: 'Nearby',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
