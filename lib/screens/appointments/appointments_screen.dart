import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/other_models.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class AppointmentsScreen extends StatelessWidget {
  final AppState state;

  const AppointmentsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final appointments = state.appointments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments & Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAppointmentDialog(context),
            tooltip: 'Add Appointment',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusBadge(text: 'CALENDAR & CONSULTATIONS', tone: 'blue'),
            const SizedBox(height: 8),
            const Text(
              'Upcoming Health Events',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Keep track of consultations, lab visits and checkups.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            if (appointments.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No upcoming appointments.'),
                ),
              )
            else
              ...appointments.map((apt) {
                final member = state.members.firstWhere(
                  (m) => m.id == apt.memberId,
                  orElse: () => state.members.first,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.toneBlueBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.event, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                apt.title,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${apt.provider} · ${apt.date} at ${apt.time}',
                                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                              ),
                              const SizedBox(height: 6),
                              StatusBadge(text: member.shortName, tone: member.color),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAppointmentDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add appointment'),
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context) {
    final titleController = TextEditingController(text: 'Health consultation');
    final providerController = TextEditingController(text: 'Dr. Ananya Roy');
    final dateController = TextEditingController(text: '2026-11-15');
    final timeController = TextEditingController(text: '11:00');
    String memberId = state.activeMember?.id ?? state.members.first.id;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title / Event'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: providerController,
                  decoration: const InputDecoration(labelText: 'Doctor / Provider'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: memberId,
                  decoration: const InputDecoration(labelText: 'Family member'),
                  items: state.members.map((m) {
                    return DropdownMenuItem(value: m.id, child: Text(m.name));
                  }).toList(),
                  onChanged: (v) => memberId = v ?? memberId,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time (HH:MM)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  final newApt = AppointmentItem(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: titleController.text.trim(),
                    provider: providerController.text.trim(),
                    date: dateController.text.trim(),
                    time: timeController.text.trim(),
                    memberId: memberId,
                  );
                  state.addAppointment(newApt);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save appointment'),
            ),
          ],
        );
      },
    );
  }
}
