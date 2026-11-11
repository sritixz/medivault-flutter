import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/other_models.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class EmergencyScreen extends StatefulWidget {
  final AppState state;

  const EmergencyScreen({super.key, required this.state});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  late TextEditingController _allergyController;
  late TextEditingController _conditionsController;
  late TextEditingController _medicinesController;
  late TextEditingController _contactController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final memberId = widget.state.activeMember?.id ?? 'vikram';
    final profile = widget.state.getEmergencyProfile(memberId);

    _allergyController = TextEditingController(text: profile.allergy);
    _conditionsController = TextEditingController(text: profile.conditions);
    _medicinesController = TextEditingController(text: profile.medicines);
    _contactController = TextEditingController(text: profile.emergencyContact);
    _phoneController = TextEditingController(text: profile.contactPhone);
  }

  @override
  void dispose() {
    _allergyController.dispose();
    _conditionsController.dispose();
    _medicinesController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final memberId = widget.state.activeMember?.id ?? 'vikram';
    final updated = EmergencyProfile(
      allergy: _allergyController.text.trim(),
      conditions: _conditionsController.text.trim(),
      medicines: _medicinesController.text.trim(),
      emergencyContact: _contactController.text.trim(),
      contactPhone: _phoneController.text.trim(),
    );

    widget.state.updateEmergencyProfile(memberId, updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Emergency profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeMember = widget.state.activeMember ?? widget.state.members.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Health Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemberPills(
              members: widget.state.members,
              selectedMemberId: widget.state.selectedMemberId,
              onSelect: (id) {
                widget.state.setMember(id);
                setState(() {
                  _loadProfile();
                });
              },
            ),
            const SizedBox(height: 16),

            // Emergency Notice Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tonePeachBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.tonePeachBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emergency, color: AppColors.tonePeachText, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Essential Details. Within Reach.',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.tonePeachText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'For first responders and emergency care for ${activeMember.shortName}. Blood Group: ${activeMember.bloodGroup}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.tonePeachText.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Editable Emergency Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Critical Health Information',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      const Text('Known Allergies', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _allergyController,
                        decoration: const InputDecoration(hintText: 'e.g. Penicillin, Peanuts'),
                      ),
                      const SizedBox(height: 14),
                      const Text('Chronic Conditions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _conditionsController,
                        decoration: const InputDecoration(hintText: 'e.g. Type 2 Diabetes, Hypertension'),
                      ),
                      const SizedBox(height: 14),
                      const Text('Current Critical Medicines', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _medicinesController,
                        decoration: const InputDecoration(hintText: 'e.g. Metformin, Insulin'),
                      ),
                      const SizedBox(height: 14),
                      const Text('Emergency Contact Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _contactController,
                        decoration: const InputDecoration(hintText: 'e.g. Contact Person Name'),
                      ),
                      const SizedBox(height: 14),
                      const Text('Emergency Contact Phone', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(hintText: 'e.g. +91 98765 43210'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.save),
                          label: const Text('Save Emergency Details'),
                          onPressed: _saveProfile,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
