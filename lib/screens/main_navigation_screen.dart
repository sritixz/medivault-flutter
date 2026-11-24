import 'package:flutter/material.dart';
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
import 'plans/membership_screen.dart';
import 'privacy/privacy_screen.dart';
import 'notifications/notification_preferences_screen.dart';
import 'auth/auth_flow_screen.dart';

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
      case 'plans':
        screen = MembershipScreen(state: widget.state);
        break;
      case 'privacy':
        screen = PrivacyScreen(
          state: widget.state,
          onOpenSharing: () => _navigateToRoute('sharing'),
        );
        break;
      case 'notifications':
        screen = const NotificationPreferencesScreen();
        break;
      case 'session-expired':
        screen = AuthFlowScreen(
          state: widget.state,
          isSessionExpiredPreview: true,
          onCompleted: () => Navigator.pop(context),
        );
        break;
      case 'login':
        screen = AuthFlowScreen(
          state: widget.state,
          onCompleted: () => Navigator.pop(context),
        );
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: const Color(0xFF0F766E),
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: [
            _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
            _buildNavItem(1, Icons.folder_outlined, Icons.folder, 'Records'),
            _buildNavItem(2, Icons.location_on_outlined, Icons.location_on, 'Nearby'),
            _buildNavItem(3, Icons.person_outline, Icons.person, 'Account'),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(activeIcon, color: const Color(0xFF0F766E), size: 22),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Icon(icon, color: const Color(0xFF64748B), size: 24),
            ),
      label: label,
    );
  }
}
