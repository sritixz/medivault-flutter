import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/family_member.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class FamilyScreen extends StatelessWidget {
  final AppState state;

  const FamilyScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final activeMember = state.activeMember ?? state.members.first;
    final memberRecords = state.records.where((r) => r.memberId == activeMember.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () => _showAddMemberDialog(context),
            tooltip: 'Add Member',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal Member Selection Cards
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...state.members.map((m) {
                    final isSelected = activeMember.id == m.id;
                    final count = state.records.where((r) => r.memberId == m.id).length;

                    return GestureDetector(
                      onTap: () => state.setMember(m.id),
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MemberAvatar(member: m, radius: 22),
                            const SizedBox(height: 8),
                            Text(
                              m.shortName,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${m.relation} · ${m.age}y',
                              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4),
                            StatusBadge(
                              text: '$count records',
                              tone: isSelected ? 'mint' : 'neutral',
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () => _showAddMemberDialog(context),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceVariant, style: BorderStyle.solid),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 36, color: AppColors.primary),
                          SizedBox(height: 8),
                          Text(
                            'Add Member',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          Text(
                            'New profile',
                            style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Details Card
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
                          Text(
                            activeMember.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Edit profile'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Personal health profile · MV-${activeMember.id.toUpperCase()}',
                        style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildInfoRow('Relationship', activeMember.relation),
                      _buildInfoRow('Age', '${activeMember.age} years'),
                      _buildInfoRow('Blood group', activeMember.bloodGroup),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Member's Health Records
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${activeMember.shortName}’s health records (${memberRecords.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 12),

            if (memberRecords.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No records for this member yet.',
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: memberRecords.length,
                itemBuilder: (context, index) {
                  final record = memberRecords[index];
                  return RecordCardItem(
                    record: record,
                    member: activeMember,
                    onBookmarkToggle: () => state.toggleBookmark(record.id),
                    onArchiveToggle: () => state.toggleArchive(record.id),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    String relation = 'Spouse';
    String blood = 'B+';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add family member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: relation,
                  decoration: const InputDecoration(labelText: 'Relationship'),
                  items: ['Spouse', 'Son', 'Daughter', 'Father', 'Mother', 'Other'].map((r) {
                    return DropdownMenuItem(value: r, child: Text(r));
                  }).toList(),
                  onChanged: (v) => relation = v ?? relation,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: blood,
                  decoration: const InputDecoration(labelText: 'Blood group'),
                  items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((b) {
                    return DropdownMenuItem(value: b, child: Text(b));
                  }).toList(),
                  onChanged: (v) => blood = v ?? blood,
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
                  final name = nameController.text.trim();
                  final newMember = FamilyMember(
                    id: 'member-${DateTime.now().millisecondsSinceEpoch}',
                    name: name,
                    shortName: name.split(' ').first,
                    relation: relation,
                    age: int.tryParse(ageController.text) ?? 30,
                    initials: name.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join(),
                    color: 'blue',
                    bloodGroup: blood,
                  );
                  state.addMember(newMember);
                  state.setMember(newMember.id);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add member'),
            ),
          ],
        );
      },
    );
  }
}
