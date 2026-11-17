import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class AccountScreen extends StatelessWidget {
  final AppState state;
  final Function(String route) onNavigateRoute;

  const AccountScreen({
    super.key,
    required this.state,
    required this.onNavigateRoute,
  });

  @override
  Widget build(BuildContext context) {
    final initials = state.userName.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.toneMintBg,
                      child: Text(
                        initials.isNotEmpty ? initials : 'VS',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.toneMintText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.userName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            state.userEmail,
                            style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const StatusBadge(text: 'Family Admin', tone: 'mint'),
                              const SizedBox(width: 6),
                              if (state.isMemberPlanActive)
                                const StatusBadge(text: 'Member Plan', tone: 'blue'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Health & Care Section
            const Text(
              'Health Services',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.health_and_safety_outlined,
              title: 'Emergency Health Profile',
              subtitle: 'Blood group, critical allergies & contacts',
              onTap: () => onNavigateRoute('emergency'),
            ),
            _buildActionTile(
              icon: Icons.medical_services_outlined,
              title: 'Dental Care Records',
              subtitle: 'Dental checkups, treatments & imaging',
              onTap: () => onNavigateRoute('dental'),
            ),
            _buildActionTile(
              icon: Icons.shield_outlined,
              title: 'Insurance & Mediclaim',
              subtitle: 'Active policies and claim documents',
              onTap: () => onNavigateRoute('insurance'),
            ),
            _buildActionTile(
              icon: Icons.vaccines_outlined,
              title: 'Preventive Care & Vaccines',
              subtitle: 'Immunization history & booster alerts',
              onTap: () => onNavigateRoute('preventive'),
            ),
            _buildActionTile(
              icon: Icons.share_outlined,
              title: 'Record Sharing & Access',
              subtitle: 'Grant time-limited access to doctors',
              onTap: () => onNavigateRoute('sharing'),
            ),
            _buildActionTile(
              icon: Icons.timeline,
              title: 'Health Timeline',
              subtitle: 'Chronological health story of your family',
              onTap: () => onNavigateRoute('timeline'),
            ),
            const SizedBox(height: 20),

            // Settings & Plans
            const Text(
              'Settings & Plans',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.card_membership_outlined,
              title: 'Membership Plans',
              subtitle: state.isMemberPlanActive
                  ? '${state.subscribedMembers.length} members · ₹${state.subscribedMembers.length * 499}/mo'
                  : 'Free & INR 499 / member / month',
              onTap: () => onNavigateRoute('plans'),
            ),
            _buildActionTile(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              subtitle: 'Audit trail and data controls',
              onTap: () => onNavigateRoute('privacy'),
            ),
            _buildActionTile(
              icon: Icons.notifications_outlined,
              title: 'Notification Preferences',
              subtitle: 'Medicine & appointment alerts',
              onTap: () => onNavigateRoute('notifications'),
            ),
            _buildActionTile(
              icon: Icons.lock_clock_outlined,
              title: 'Session Recovery Preview',
              subtitle: 'Simulate session expiration & re-login',
              onTap: () => onNavigateRoute('session-expired'),
            ),
            const SizedBox(height: 12),

            // Log out / Onboarding option
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout, color: AppColors.primary, size: 22),
                ),
                title: const Text(
                  'Switch Account / Replay Onboarding',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                subtitle: const Text(
                  'View the 3 onboarding slides & demo OTP flow',
                  style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.outline, size: 18),
                onTap: () => onNavigateRoute('login'),
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'MediVault v1.0.0 (Flutter Mobile Edition)\nDesign Preview · Sample Data',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.outline.withValues(alpha: 0.8)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.outline, size: 18),
        onTap: onTap,
      ),
    );
  }
}
