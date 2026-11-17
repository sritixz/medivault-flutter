import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/common_widgets.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  bool _medicineAlerts = true;
  bool _appointmentAlerts = true;
  bool _vaccineAlerts = true;
  bool _shareExpiryAlerts = true;
  bool _quietHours = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusBadge(text: 'STAY GENTLY REMINDED', tone: 'blue'),
            const SizedBox(height: 8),
            const Text(
              'Health Reminders & Updates',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Customize how and when you receive reminders for medicines and visits.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: _medicineAlerts,
                    onChanged: (v) => setState(() => _medicineAlerts = v),
                    title: const Text('Daily Medicine Reminders', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Alerts at scheduled medicine times with dose taken logging.'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _appointmentAlerts,
                    onChanged: (v) => setState(() => _appointmentAlerts = v),
                    title: const Text('Upcoming Appointments', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Reminders 24 hours and 2 hours prior to scheduled visits.'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _vaccineAlerts,
                    onChanged: (v) => setState(() => _vaccineAlerts = v),
                    title: const Text('Vaccination & Booster Alerts', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Notifications for pediatric vaccines and annual influenza boosters.'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _shareExpiryAlerts,
                    onChanged: (v) => setState(() => _shareExpiryAlerts = v),
                    title: const Text('Share Link Expiry Notices', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Alert when practitioner access is expiring or renewed.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Delivery & Timing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: _quietHours,
                    onChanged: (v) => setState(() => _quietHours = v),
                    title: const Text('Quiet Hours (10:00 PM – 07:00 AM)', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Suppress non-urgent notifications during sleep hours.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
