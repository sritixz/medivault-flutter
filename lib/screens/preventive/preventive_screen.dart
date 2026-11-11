import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class PreventiveScreen extends StatelessWidget {
  final AppState state;

  const PreventiveScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final vaccines = state.records.where((r) => r.category == 'Vaccinations').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preventive Care & Vaccines'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusBadge(text: 'PREVENTION AHEAD OF TIME', tone: 'mint'),
            const SizedBox(height: 8),
            const Text(
              'Vaccines & Preventive Care',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Immunization records, booster reminders and periodic health checkups.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Card(
              color: AppColors.toneBlueBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.toneBlueBorder),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.vaccines, color: AppColors.toneBlueText),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Upcoming: Annual Influenza booster recommended for Senior members (Nov 2026).',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.toneBlueText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Vaccination Records',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            ...vaccines.map((r) {
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
