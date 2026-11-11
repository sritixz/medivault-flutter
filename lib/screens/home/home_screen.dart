import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  final Function(int) onNavigateTab;
  final Function(String route) onNavigateRoute;

  const HomeScreen({
    super.key,
    required this.state,
    required this.onNavigateTab,
    required this.onNavigateRoute,
  });

  @override
  Widget build(BuildContext context) {
    final homeRecords = state.homeRecords;
    final homeMedicines = state.homeMedicines;
    final firstMedicine = homeMedicines.isNotEmpty ? homeMedicines.first : null;
    final isTaken = firstMedicine != null && state.takenMedicines.contains(firstMedicine.id);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.activeMember?.name ?? 'Vikram Sharma',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const Text(
              'Your family’s health companion',
              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => onNavigateRoute('search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => onNavigateRoute('notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Member Selector Pills
            MemberPills(
              members: state.members,
              selectedMemberId: state.selectedMemberId,
              onSelect: state.setMember,
            ),
            const SizedBox(height: 16),

            // Status Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  StatusBadge(
                    icon: Icons.family_restroom,
                    text: '${state.members.length} family profiles',
                    tone: 'mint',
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(
                    icon: Icons.folder_outlined,
                    text: 'Health locker · ${homeRecords.length} records',
                    tone: 'blue',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Essential Healthcare',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => onNavigateTab(3), // Account
                    icon: const Text('All features'),
                    label: const Icon(Icons.chevron_right, size: 16),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 6 Service Cards Grid (Matching React layout)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  _buildServiceCard(
                    title: 'Find care',
                    subtitle: 'Doctors & healthcare near you',
                    badge: 'NEARBY',
                    tone: 'mint',
                    icon: Icons.location_on_outlined,
                    onTap: () => onNavigateTab(2), // Nearby tab
                  ),
                  _buildServiceCard(
                    title: 'Emergency profile',
                    subtitle: 'Important details, within reach',
                    badge: 'HEALTH ID',
                    tone: 'peach',
                    icon: Icons.health_and_safety_outlined,
                    onTap: () => onNavigateRoute('emergency'),
                  ),
                  _buildServiceCard(
                    title: 'Family care',
                    subtitle: 'Your family’s health, together',
                    badge: null,
                    tone: 'blue',
                    icon: Icons.people_outline,
                    onTap: () => onNavigateRoute('family'),
                  ),
                  _buildServiceCard(
                    title: 'Medicines',
                    subtitle: 'Your regular medicines & reminders',
                    badge: 'DAILY CARE',
                    tone: 'cream',
                    icon: Icons.medication_outlined,
                    onTap: () => onNavigateRoute('medicines'),
                  ),
                  _buildServiceCard(
                    title: 'Easier',
                    subtitle: 'Upload your prescription or report',
                    badge: 'QUICK UPLOAD',
                    tone: 'rose',
                    icon: Icons.cloud_upload_outlined,
                    onTap: () => onNavigateRoute('upload'),
                  ),
                  _buildServiceCard(
                    title: 'Lab reports',
                    subtitle: 'Your health test records',
                    badge: 'HEALTH LOCKER',
                    tone: 'aqua',
                    icon: Icons.science_outlined,
                    onTap: () {
                      state.setCategory('Lab reports');
                      onNavigateTab(1); // Records tab
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Utility Cards: Timeline & Appointments
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildUtilityCard(
                      label: 'Health history',
                      title: 'Your health,\nover time.',
                      subtitle: '${homeRecords.length} records in timeline',
                      buttonText: 'View timeline',
                      tone: 'peach',
                      icon: Icons.timeline,
                      onTap: () => onNavigateRoute('timeline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildUtilityCard(
                      label: 'UPCOMING CARE',
                      title: 'Appointments\n& health events',
                      subtitle: '${state.appointments.length} upcoming',
                      buttonText: 'View calendar',
                      tone: 'blue',
                      icon: Icons.calendar_month_outlined,
                      onTap: () => onNavigateRoute('appointments'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily Medicine Reminder Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: firstMedicine != null
                  ? Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceVariant),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.toneCreamBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.toneCreamBorder),
                            ),
                            child: const Icon(Icons.medication, color: AppColors.toneCreamText),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  firstMedicine.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${firstMedicine.dose} · ${firstMedicine.time}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isTaken ? Icons.check_circle : Icons.circle_outlined,
                              color: isTaken ? AppColors.secondary : AppColors.outline,
                              size: 28,
                            ),
                            onPressed: () => state.toggleMedicineTaken(firstMedicine.id),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () => onNavigateRoute('medicines'),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surfaceVariant),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.medication_outlined, color: AppColors.outline),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No medicine schedule yet',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Add medicines to receive reminders',
                                    style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: AppColors.outline),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // Family Members Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your family',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          TextButton(
                            onPressed: () => onNavigateRoute('family'),
                            child: const Text('Manage'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: state.members.map((m) {
                          return GestureDetector(
                            onTap: () {
                              state.setMember(m.id);
                              onNavigateRoute('family');
                            },
                            child: Column(
                              children: [
                                MemberAvatar(member: m, radius: 24),
                                const SizedBox(height: 6),
                                Text(
                                  m.shortName,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                Text(
                                  m.relation,
                                  style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required String? badge,
    required String tone,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final style = ToneStyle.getTone(tone);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: style.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: style.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, color: style.textColor, size: 22),
              ],
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: style.textColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: style.textColor,
                  ),
                ),
              ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: style.textColor.withValues(alpha: 0.85),
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityCard({
    required String label,
    required String title,
    required String subtitle,
    required String buttonText,
    required String tone,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final style = ToneStyle.getTone(tone);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: style.textColor),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: style.textColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 12, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
