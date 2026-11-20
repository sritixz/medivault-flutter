import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/other_models.dart';
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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 44,
              height: 44,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.family_restroom, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.activeMember?.name ?? 'Vikram Sharma',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Your family’s health companion',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurface, size: 24),
            onPressed: () => onNavigateRoute('search'),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.onSurface, size: 26),
                onPressed: () => onNavigateRoute('notifications'),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
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
            const SizedBox(height: 12),

            // Status Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  StatusBadge(
                    icon: Icons.people_outline,
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
            const SizedBox(height: 14),

            // Hero Promo Banner (Offers & Discounts / Image 1 Match)
            _buildHeroBanner(),
            const SizedBox(height: 16),

            // Section Header matching Image 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.activePillTeal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.monitor_heart, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Essential Healthcare',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const Spacer(),
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
            const SizedBox(height: 10),

            // 6 Service Cards Grid (Matching Image 1 Visuals)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.45,
                children: [
                  _buildServiceCard(
                    title: 'Find care',
                    subtitle: 'Doctors & healthcare near you',
                    badge: 'NEARBY',
                    tone: 'mint',
                    icon: Icons.location_on,
                    imageAsset: 'assets/images/art_find_care.png',
                    fallbackAsset: 'assets/photos/doctor.jpg',
                    onTap: () => onNavigateTab(2), // Nearby tab
                  ),
                  _buildServiceCard(
                    title: 'Emergency',
                    subtitle: 'Important details, within reach',
                    badge: 'HEALTH ID',
                    tone: 'peach',
                    icon: Icons.health_and_safety_outlined,
                    imageAsset: 'assets/images/art_emergency.png',
                    fallbackAsset: 'assets/stitch/emergency.png',
                    onTap: () => onNavigateRoute('emergency'),
                  ),
                  _buildServiceCard(
                    title: 'Family care',
                    subtitle: 'Your family’s health, together',
                    badge: null,
                    tone: 'blue',
                    icon: Icons.people_outline,
                    imageAsset: 'assets/images/art_family.png',
                    fallbackAsset: 'assets/stitch/family.png',
                    onTap: () => onNavigateRoute('family'),
                  ),
                  _buildServiceCard(
                    title: 'Medicines',
                    subtitle: 'Your regular medicines & reminders',
                    badge: 'DAILY CARE',
                    tone: 'cream',
                    icon: Icons.medical_services_outlined,
                    imageAsset: 'assets/images/art_medicines.png',
                    fallbackAsset: 'assets/stitch/medicines.png',
                    onTap: () => onNavigateRoute('medicines'),
                  ),
                  _buildServiceCard(
                    title: 'Easier',
                    subtitle: 'Upload your prescription or report',
                    badge: 'QUICK UPLOAD',
                    tone: 'rose',
                    icon: Icons.cloud_upload_outlined,
                    imageAsset: 'assets/images/art_easier.png',
                    fallbackAsset: 'assets/stitch/upload.png',
                    onTap: () => onNavigateRoute('upload'),
                  ),
                  _buildServiceCard(
                    title: 'Lab reports',
                    subtitle: 'Your health test records',
                    badge: 'HEALTH LOCKER',
                    tone: 'aqua',
                    icon: Icons.science_outlined,
                    imageAsset: 'assets/images/art_lab.png',
                    fallbackAsset: 'assets/stitch/labs.png',
                    onTap: () {
                      state.setCategory('Lab reports');
                      onNavigateTab(1); // Records tab
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Block 1: 1-Tap Emergency SOS Bar
            _buildEmergencySosBar(context),
            const SizedBox(height: 16),

            // Block 1: Longitudinal Health Record (BP & Sugar Consolidation)
            _buildLongitudinalHealthRecord(context),
            const SizedBox(height: 20),

            // Block 2 & 3: Health Records & Locker (My, Family, Dental & Lab Records)
            _buildHealthRecordsLockerSection(context),
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

            // Block 4 & 5: Book Appointment & Find Doctors / Hospitals Near Me
            _buildBookAppointmentAndNearbySection(context),
            const SizedBox(height: 20),

            // Block 7: Regular Medicines & Order Medicine Online
            _buildRegularMedicinesSection(context),
            const SizedBox(height: 20),

            // Block 6: Healthcare Offers & Preventive Discounts
            _buildHealthOffersSection(context),
            const SizedBox(height: 20),

            // Block 8: Mediclaim Policy Details
            _buildMediclaimPolicySection(context),
            const SizedBox(height: 20),

            // Blocks 9 & 10: Health Fund & Emergency Health Loan (Coming Soon)
            _buildHealthFundAndLoanSection(context),
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
    required String imageAsset,
    String? fallbackAsset,
    required VoidCallback onTap,
  }) {
    final style = ToneStyle.getTone(tone);

    LinearGradient cardGradient;
    switch (tone.toLowerCase()) {
      case 'mint':
        cardGradient = const LinearGradient(
          colors: [Color(0xFFEEFFF2), Color(0xFFD7F4DE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'peach':
        cardGradient = const LinearGradient(
          colors: [Color(0xFFFFF1EA), Color(0xFFFCE1D0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'blue':
        cardGradient = const LinearGradient(
          colors: [Color(0xFFEAF6FF), Color(0xFFD6EDFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'cream':
        cardGradient = const LinearGradient(
          colors: [Color(0xFFFBF8E6), Color(0xFFF6E8BF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'rose':
        cardGradient = const LinearGradient(
          colors: [Color(0xFFFFF0F4), Color(0xFFFCE0E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'aqua':
      default:
        cardGradient = const LinearGradient(
          colors: [Color(0xFFF0FAFE), Color(0xFFD5F2F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: style.borderColor.withValues(alpha: 0.6), width: 1),
          boxShadow: [
            BoxShadow(
              color: style.borderColor.withValues(alpha: 0.22),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Negative top/bottom trims the neighboring-card bleed baked into the PNGs
              Positioned(
                top: -12,
                bottom: -12,
                right: 0,
                width: 90,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  errorBuilder: (_, _, _) => fallbackAsset != null
                      ? Image.asset(
                          fallbackAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const SizedBox(),
                        )
                      : const SizedBox(),
                ),
              ),

              // Foreground card copy on the left
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: style.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
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
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: style.textColor,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 76),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: style.textColor.withValues(alpha: 0.85),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 116,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F7657), Color(0xFF0B5D45), Color(0xFF074533)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B6D55).withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 150,
              child: Image.asset(
                'assets/images/hero_stethoscope_feathered.png',
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
                errorBuilder: (_, _, _) => const SizedBox(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 14, 140, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Health.\nOur Priority.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Stay Healthy • Live Better',
                    style: TextStyle(
                      color: Color(0xFFC7F3DB),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySosBar(BuildContext context) {
    final emergency = state.emergencies[state.selectedMemberId] ??
        state.emergencies['vikram'];
    final contactName = emergency?.emergencyContact ?? 'Pooja Sharma';
    final contactPhone = emergency?.contactPhone ?? '+91 98765 43210';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFEF2F2), Color(0xFFFEE2E2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFECACA)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.emergency, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '1-Tap Emergency SOS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '24x7',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Ambulance 108 · ICE: $contactName ($contactPhone)',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7F1D1D),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _showEmergencyDialog(context, contactName, contactPhone),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'SOS',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context, String contactName, String contactPhone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emergency, color: Color(0xFFDC2626), size: 24),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency SOS Assistance',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Direct line to emergency responders and family',
                      style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFEF4444),
                child: Icon(Icons.local_hospital, color: Colors.white),
              ),
              title: const Text('Call Ambulance (108)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('National Medical Emergency Response'),
              trailing: const Icon(Icons.call, color: Color(0xFFDC2626)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling National Ambulance Service (108)...')),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF0284C7),
                child: Icon(Icons.phone_in_talk, color: Colors.white),
              ),
              title: Text('Call ICE: $contactName', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(contactPhone),
              trailing: const Icon(Icons.call, color: Color(0xFF0284C7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling Emergency Contact $contactName...')),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF059669),
                child: Icon(Icons.medical_information, color: Colors.white),
              ),
              title: const Text('Open Emergency Medical ID', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Allergies: Penicillin · Blood: B+ · Type 2 Diabetes'),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              onTap: () {
                Navigator.pop(ctx);
                onNavigateRoute('emergency');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLongitudinalHealthRecord(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.insights, color: Color(0xFF0B6D55), size: 18),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Longitudinal Health Record',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        'Consolidated vitals & clinical trends',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigateRoute('timeline'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'History',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                // Blood Pressure card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Blood Pressure',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Normal',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF166534),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '120/80',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'mmHg',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 11, color: Color(0xFF16A34A)),
                            SizedBox(width: 4),
                            Text(
                              'Target: <120/80',
                              style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Blood Sugar card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Fasting Sugar',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Optimal',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF075985),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '95',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'mg/dL',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 11, color: Color(0xFF0284C7)),
                            SizedBox(width: 4),
                            Text(
                              'Target: 70-100',
                              style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Pulse & quick log
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, size: 14, color: Color(0xFFEF4444)),
                  const SizedBox(width: 6),
                  const Text(
                    'Resting Pulse: 72 bpm',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                  const Spacer(),
                  const Text(
                    'Updated Today',
                    style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthRecordsLockerSection(BuildContext context) {
    final myRecords = state.records.where((r) => r.memberId == 'vikram' && !r.archived).length;
    final familyRecords = state.records.where((r) => !r.archived).length;
    final dentalRecords = state.records.where((r) => r.category.toLowerCase().contains('dental') && !r.archived).length;
    final labRecords = state.records.where((r) => r.category.toLowerCase().contains('lab') && !r.archived).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder_shared, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Health Records & Locker',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => onNavigateTab(1),
                icon: const Text('View locker'),
                label: const Icon(Icons.chevron_right, size: 16),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildLockerQuickCard(
                title: 'My Records',
                count: '$myRecords records',
                icon: Icons.person_pin,
                color: const Color(0xFF0D9488),
                bgTone: const Color(0xFFF0FDFA),
                onTap: () {
                  state.setMember('vikram');
                  state.setCategory('All records');
                  onNavigateTab(1);
                },
              ),
              _buildLockerQuickCard(
                title: 'Family Records',
                count: '$familyRecords records',
                icon: Icons.family_restroom,
                color: const Color(0xFF2563EB),
                bgTone: const Color(0xFFEFF6FF),
                onTap: () {
                  state.setMember('all');
                  state.setCategory('All records');
                  onNavigateTab(1);
                },
              ),
              _buildLockerQuickCard(
                title: 'Dental Records',
                count: '$dentalRecords checkups',
                icon: Icons.health_and_safety,
                color: const Color(0xFF059669),
                bgTone: const Color(0xFFECFDF5),
                onTap: () {
                  state.setCategory('Dental');
                  onNavigateTab(1);
                },
              ),
              _buildLockerQuickCard(
                title: 'Lab Reports',
                count: '$labRecords test files',
                icon: Icons.science,
                color: const Color(0xFF7C3AED),
                bgTone: const Color(0xFFF5F3FF),
                onTap: () {
                  state.setCategory('Lab reports');
                  onNavigateTab(1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLockerQuickCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required Color bgTone,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgTone,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 12, color: color.withValues(alpha: 0.6)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color.withValues(alpha: 0.95),
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookAppointmentAndNearbySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header for Book Appointment
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF0284C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_month, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Book Appointment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => onNavigateRoute('appointments'),
                icon: const Text('All slots'),
                label: const Icon(Icons.chevron_right, size: 16),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0284C7),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Doctor specialties list
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildDoctorQuickBook(
                  context,
                  name: 'Dr. Ananya Roy',
                  specialty: 'General Physician',
                  rating: '4.9 ★',
                  nextSlot: 'Today 4:00 PM',
                  color: const Color(0xFF0D9488),
                  avatarInitial: 'AR',
                ),
                _buildDoctorQuickBook(
                  context,
                  name: 'Dr. Rajesh Verma',
                  specialty: 'Cardiologist',
                  rating: '4.8 ★',
                  nextSlot: 'Tomorrow 11 AM',
                  color: const Color(0xFF2563EB),
                  avatarInitial: 'RV',
                ),
                _buildDoctorQuickBook(
                  context,
                  name: 'Dr. Sneha Patil',
                  specialty: 'Pediatrician',
                  rating: '4.9 ★',
                  nextSlot: 'Today 5:30 PM',
                  color: const Color(0xFFDB2777),
                  avatarInitial: 'SP',
                ),
                _buildDoctorQuickBook(
                  context,
                  name: 'Dr. Meera Shah',
                  specialty: 'Dentist',
                  rating: '4.9 ★',
                  nextSlot: 'Tomorrow 3 PM',
                  color: const Color(0xFF7C3AED),
                  avatarInitial: 'MS',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Block 5: Find Doctors & Hospitals Near Me
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF059669),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.near_me, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Hospitals & Care Near Me',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => onNavigateTab(2), // Nearby tab
                icon: const Text('Map view'),
                label: const Icon(Icons.chevron_right, size: 16),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF059669),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildNearbyHospitalItem(
                  name: 'Apollo Clinic',
                  type: 'Multispecialty & Diagnostics',
                  distance: '0.8 km',
                  rating: '4.9',
                  openStatus: 'Open till 9 PM',
                  isEmergency: false,
                  onTap: () => onNavigateTab(2),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildNearbyHospitalItem(
                  name: 'Fortis Hospital',
                  type: 'Super Specialty Hospital',
                  distance: '2.4 km',
                  rating: '4.8',
                  openStatus: '24x7 Emergency',
                  isEmergency: true,
                  onTap: () => onNavigateTab(2),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildNearbyHospitalItem(
                  name: 'Max Healthcare Centre',
                  type: 'Advanced Care Hospital',
                  distance: '3.1 km',
                  rating: '4.7',
                  openStatus: '24x7 Open',
                  isEmergency: false,
                  onTap: () => onNavigateTab(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorQuickBook(
    BuildContext context, {
    required String name,
    required String specialty,
    required String rating,
    required String nextSlot,
    required Color color,
    required String avatarInitial,
  }) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showQuickBookingModal(context, name, specialty),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Text(
                    avatarInitial,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                const Spacer(),
                Text(
                  rating,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  specialty,
                  style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.schedule, size: 11, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    nextSlot,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyHospitalItem({
    required String name,
    required String type,
    required String distance,
    required String rating,
    required String openStatus,
    required bool isEmergency,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isEmergency ? const Color(0xFFFEE2E2) : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isEmergency ? Icons.local_hospital : Icons.local_pharmacy_outlined,
                color: isEmergency ? const Color(0xFFDC2626) : const Color(0xFF059669),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '★ $rating',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFD97706)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$type · $openStatus',
                    style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    distance,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Directions',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickBookingModal(BuildContext context, String doctor, String specialty) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Book Consultation with $doctor',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            Text(
              '$specialty · In-person / Video Consult',
              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                  SizedBox(width: 10),
                  Text('Earliest Slot: Today at 4:30 PM', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final newApt = AppointmentItem(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: 'Consultation with $doctor',
                    provider: doctor,
                    date: '2026-11-21',
                    time: '16:30',
                    memberId: state.selectedMemberId == 'all' ? 'vikram' : state.selectedMemberId,
                  );
                  state.addAppointment(newApt);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Appointment confirmed with $doctor!')),
                  );
                },
                child: const Text('Confirm Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularMedicinesSection(BuildContext context) {
    final medicines = state.homeMedicines;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD97706),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medication, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Regular Medicines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => onNavigateRoute('medicines'),
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (medicines.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No medicines scheduled for this profile.',
                  style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
              )
            else
              ...medicines.map((med) {
                final isTaken = state.takenMedicines.contains(med.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.medication, color: Color(0xFFB45309), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med.name,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            Text(
                              '${med.dose} · ${med.time}',
                              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isTaken ? Icons.check_circle : Icons.circle_outlined,
                          color: isTaken ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
                          size: 26,
                        ),
                        onPressed: () => state.toggleMedicineTaken(med.id),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 8),

            // Order Medicine Online Action Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_shipping, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Order Medicine Online',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF065F46),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '20% OFF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          '2-Hour doorstep delivery from MediVault Pharmacy',
                          style: TextStyle(fontSize: 11, color: Color(0xFF047857)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showOrderMedicinesModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Order Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthOffersSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFE11D48),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_offer, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Offers & Preventive Care',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'LIMITED TIME',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFBE123C)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Offers Scroll
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildOfferCard(
                  title: 'Full Body Health Checkup',
                  subtitle: '60+ tests including Lipid, Liver, Kidney & Sugar',
                  discount: '40% OFF',
                  price: '₹1,499',
                  originalPrice: '₹2,500',
                  color: const Color(0xFF0284C7),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Full Body Health Checkup offer coupon "SAVE40" applied!')),
                    );
                  },
                ),
                _buildOfferCard(
                  title: 'Dental Scaling & Polish',
                  subtitle: 'Complete ultrasonic plaque removal & consultation',
                  discount: '50% OFF',
                  price: '₹499',
                  originalPrice: '₹1,000',
                  color: const Color(0xFF059669),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dental Care offer coupon "SMILE499" applied!')),
                    );
                  },
                ),
                _buildOfferCard(
                  title: 'Annual Eye Screening',
                  subtitle: 'Computer vision, refraction & glaucoma check',
                  discount: '100% FREE',
                  price: 'FREE',
                  originalPrice: '₹600',
                  color: const Color(0xFF7C3AED),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Free Eye Screening slot unlocked for your family!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String subtitle,
    required String discount,
    required String price,
    required String originalPrice,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 270,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    discount,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    price,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color),
                  ),
                  if (originalPrice.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  'Claim Offer',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderMedicinesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.local_shipping, color: Color(0xFF059669)),
                SizedBox(width: 10),
                Text(
                  'Order Prescribed Medicines',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Express 2-hour doorstep delivery from certified pharmacy',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('• Metformin 500 mg (30 Tabs)', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('₹180'),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('• Vitamin D 60K (4 Caps)', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('₹140'),
                    ],
                  ),
                  Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total with 20% MediVault Discount', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('₹256', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed! Express delivery arriving in 2 hours.')),
                  );
                },
                child: const Text('Place Order (Cash on Delivery / UPI)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediclaimPolicySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Mediclaim Policy Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showMediclaimCardModal(context),
                child: const Text('View E-Card'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Insurance Card
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.health_and_safety, color: Color(0xFF38BDF8), size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Star Health & Allied',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Family Optima Health Plan',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF10B981)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF34D399), size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Active Cashless',
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SUM INSURED',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '₹ 5,00,000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'POLICY NUMBER',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'SH-829104-MV',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'VALID TILL',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '31 Mar 2027',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF334155), height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.people_alt_outlined, color: Color(0xFF94A3B8), size: 14),
                    const SizedBox(width: 6),
                    const Text(
                      '4 Family Members Covered · TPA Cashless',
                      style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => _showMediclaimCardModal(context),
                      child: const Row(
                        children: [
                          Text(
                            'Digital Card',
                            style: TextStyle(
                              color: Color(0xFF38BDF8),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 14, color: Color(0xFF38BDF8)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMediclaimCardModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.badge, color: Color(0xFF0284C7)),
                const SizedBox(width: 8),
                const Text(
                  'Digital Mediclaim E-Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STAR HEALTH INSURANCE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                      Text('TPA CASHLESS', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text('Primary Insured: Vikram Sharma', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  Text('Dependents: Pooja Sharma, Aarav Sharma, Deepak Sharma', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Policy # SH-829104-MV', style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace')),
                      Text('Sum: ₹ 5,00,000', style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone_in_talk, color: Color(0xFF059669)),
              title: const Text('24x7 Cashless Helpline: 1800 425 2255'),
              subtitle: const Text('Quote Policy SH-829104-MV at hospital desk'),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  onNavigateTab(2); // Go to nearby hospitals
                },
                icon: const Icon(Icons.local_hospital),
                label: const Text('Find Cashless Network Hospitals Nearby'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthFundAndLoanSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Financial Wellness',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'NEW BENEFITS',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Two Financial Cards: Block 9 & Block 10
          Row(
            children: [
              // Block 9: Health Fund
              Expanded(
                child: _buildFinancialBenefitCard(
                  context,
                  title: 'MediVault Health Fund',
                  description: 'Emergency medical savings reserve with 0% risk and instant withdrawal.',
                  tag: 'COMING SOON',
                  tagBg: const Color(0xFFFEF3C7),
                  tagColor: const Color(0xFFB45309),
                  icon: Icons.savings_outlined,
                  color: const Color(0xFF059669),
                  bgTone: const Color(0xFFF0FDF4),
                  onTap: () => _showComingSoonModal(
                    context,
                    title: 'MediVault Health Fund',
                    subtitle: 'Dedicated Medical Emergency Savings',
                    details: 'Build a family medical cushion with automated recurring savings. Enjoy 0% penalties on early medical withdrawals and exclusive hospital partner discounts.',
                    actionLabel: 'Join Early Access Waitlist',
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Block 10: Emergency Health Loan
              Expanded(
                child: _buildFinancialBenefitCard(
                  context,
                  title: 'Emergency Health Loan',
                  description: 'Instant medical credit up to ₹ 2,00,000 for unexpected hospitalizations.',
                  tag: 'COMING SOON',
                  tagBg: const Color(0xFFEDE9FE),
                  tagColor: const Color(0xFF6D28D9),
                  icon: Icons.credit_score_outlined,
                  color: const Color(0xFF7C3AED),
                  bgTone: const Color(0xFFF5F3FF),
                  onTap: () => _showComingSoonModal(
                    context,
                    title: 'Emergency Health Loan',
                    subtitle: 'Instant Cashless Medical Credit',
                    details: 'Pre-approved collateral-free medical credit up to ₹ 2,00,000 directly disbursed to partner hospitals within 15 minutes. 100% digital KYC with zero paperwork.',
                    actionLabel: 'Pre-Register for Credit Line',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBenefitCard(
    BuildContext context, {
    required String title,
    required String description,
    required String tag,
    required Color tagBg,
    required Color tagColor,
    required IconData icon,
    required Color color,
    required Color bgTone,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 190,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgTone,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: tagColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: color.withValues(alpha: 0.95),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Learn more',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 10, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonModal(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String details,
    required String actionLabel,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'FEATURE IN EARLY PREVIEW',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Text(
              details,
              style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You are on the priority waitlist for $title!')),
                  );
                },
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
