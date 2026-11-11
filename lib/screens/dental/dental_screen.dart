import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class DentalScreen extends StatelessWidget {
  final AppState state;

  const DentalScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final dentalRecords = state.records.where((r) => r.category == 'Dental').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dental Care'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusBadge(text: 'DEDICATED DENTAL LOCKER', tone: 'aqua'),
            const SizedBox(height: 8),
            const Text(
              'Dental Care & Procedures',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'A dedicated place for dental visits, X-rays and treatment history.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            if (dentalRecords.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No dental records yet.'),
                ),
              )
            else
              ...dentalRecords.map((r) {
                final member = state.members.firstWhere(
                  (m) => m.id == r.memberId,
                  orElse: () => state.members.first,
                );

                return RecordCardItem(
                  record: r,
                  member: member,
                  onBookmarkToggle: () => state.toggleBookmark(r.id),
                  onArchiveToggle: () => state.toggleArchive(r.id),
                );
              }),
          ],
        ),
      ),
    );
  }
}
