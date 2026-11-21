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

  void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.headset_mic, color: Color(0xFF0284C7), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Help & Support',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '24/7 dedicated medical concierge',
                        style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone_in_talk, color: Color(0xFF0D9488)),
                title: const Text('Toll-Free Health Helpline', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('1800-889-VAULT (24/7 Support)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling MediVault 24/7 Helpline...')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF2563EB)),
                title: const Text('Chat with Support', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Average response time: 2 mins'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening live support chat...')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.help_outline, color: Color(0xFFD97706)),
                title: const Text('FAQs & Video Guides', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Learn how to use lockers, SOS and sharing'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  _navigateToRoute('privacy');
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showContactDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.mail_outline, color: Color(0xFF16A34A), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Us',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'We are here to assist your family',
                        style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email, color: Color(0xFF2563EB)),
                title: const Text('Email MediVault Care', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('support@mymedivault.com'),
                trailing: const Icon(Icons.copy, size: 18),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email copied to clipboard: support@mymedivault.com')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.emergency_outlined, color: Color(0xFFEF4444)),
                title: const Text('Hospital Coordination Desk', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('+91 98765 43210 (Urgent admissions)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  _navigateToRoute('emergency');
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
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
      NearbyScreen(state: state),
      RecordsScreen(
        state: state,
        onAddRecord: () => _navigateToRoute('upload'),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () => _navigateToRoute('emergency'),
        child: Container(
          width: 62,
          height: 62,
          margin: const EdgeInsets.only(top: 18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF5252), Color(0xFFE53935)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE53935).withValues(alpha: 0.45),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(Icons.phone, color: Colors.white, size: 15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Colors.white,
          elevation: 0,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMockupNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _buildMockupNavItem(
                  icon: Icons.medical_services_outlined,
                  label: 'Find A Doctor',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                const SizedBox(width: 56), // Center SOS space
                _buildMockupNavItem(
                  icon: Icons.headset_mic_outlined,
                  label: 'Help',
                  isSelected: false,
                  onTap: _showHelpDialog,
                ),
                _buildMockupNavItem(
                  icon: Icons.mail_outline,
                  label: 'Contact Us',
                  isSelected: false,
                  onTap: _showContactDialog,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMockupNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? const Color(0xFF0D9488) : const Color(0xFF64748B);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
