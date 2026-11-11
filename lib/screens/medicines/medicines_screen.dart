import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/other_models.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class MedicinesScreen extends StatelessWidget {
  final AppState state;

  const MedicinesScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final medicines = state.homeMedicines;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medicines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddMedicineDialog(context),
            tooltip: 'Add Medicine',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemberPills(
              members: state.members,
              selectedMemberId: state.selectedMemberId,
              onSelect: state.setMember,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: AppColors.toneCreamBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.toneCreamBorder),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.toneCreamText),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Daily medicine schedule & tracking. Mark doses taken to keep your daily rhythm.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.toneCreamText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Today’s Schedule (${medicines.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 12),
            if (medicines.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No scheduled medicines for this member.',
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final med = medicines[index];
                  final isTaken = state.takenMedicines.contains(med.id);
                  final member = state.members.firstWhere(
                    (m) => m.id == med.memberId,
                    orElse: () => state.members.first,
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                                  med.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${med.dose} · ${med.time}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                                ),
                                const SizedBox(height: 4),
                                StatusBadge(text: member.shortName, tone: member.color),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => state.toggleMedicineTaken(med.id),
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                isTaken ? Icons.check_circle : Icons.circle_outlined,
                                color: isTaken ? AppColors.secondary : AppColors.outline,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMedicineDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add medicine'),
      ),
    );
  }

  void _showAddMedicineDialog(BuildContext context) {
    final nameController = TextEditingController();
    final doseController = TextEditingController(text: '1 tablet · After lunch');
    final timeController = TextEditingController(text: '14:00');
    String memberId = state.activeMember?.id ?? state.members.first.id;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add regular medicine'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Medicine name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: doseController,
                  decoration: const InputDecoration(labelText: 'Dose instructions'),
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
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Reminder time (HH:MM)'),
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
                if (nameController.text.trim().isNotEmpty) {
                  final newMed = MedicineItem(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: nameController.text.trim(),
                    dose: doseController.text.trim(),
                    time: timeController.text.trim(),
                    memberId: memberId,
                  );
                  state.addMedicine(newMed);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add medicine'),
            ),
          ],
        );
      },
    );
  }
}
