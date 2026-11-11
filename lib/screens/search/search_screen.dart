import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class SearchScreen extends StatefulWidget {
  final AppState state;

  const SearchScreen({super.key, required this.state});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final q = _query.toLowerCase().trim();

    final matchedRecords = q.isEmpty
        ? []
        : state.records.where((r) {
            return r.title.toLowerCase().contains(q) ||
                r.provider.toLowerCase().contains(q) ||
                r.category.toLowerCase().contains(q);
          }).toList();

    final matchedMedicines = q.isEmpty
        ? []
        : state.medicines.where((m) {
            return m.name.toLowerCase().contains(q) || m.dose.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Everything'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search records, medicines, doctors…',
                prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() => _query = val);
              },
            ),
            const SizedBox(height: 20),

            if (_query.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    'Type to search across records, medicines and providers.',
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else ...[
              if (matchedRecords.isNotEmpty) ...[
                Text(
                  'Records (${matchedRecords.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                ...matchedRecords.map((r) {
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
                const SizedBox(height: 16),
              ],

              if (matchedMedicines.isNotEmpty) ...[
                Text(
                  'Medicines (${matchedMedicines.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                ...matchedMedicines.map((m) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.medication, color: AppColors.primary),
                      title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${m.dose} · ${m.time}'),
                    ),
                  );
                }),
              ],

              if (matchedRecords.isEmpty && matchedMedicines.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'No matching results found.',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
