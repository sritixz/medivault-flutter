import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/medical_record.dart';
import '../../core/models/family_member.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';
import 'document_detail_screen.dart';
import '../sharing/sharing_screen.dart';

class RecordsScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onAddRecord;

  const RecordsScreen({
    super.key,
    required this.state,
    required this.onAddRecord,
  });

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  String _listMode = 'Active'; // 'Active' | 'Saved' | 'Archived'
  bool _showAllCategories = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.state.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final allRecords = state.visibleRecords;

    final records = allRecords.where((r) {
      if (_listMode == 'Archived') return r.archived;
      if (_listMode == 'Saved') return !r.archived && r.bookmarked;
      return !r.archived;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Locker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: widget.onAddRecord,
            tooltip: 'Add Record',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Family Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.primaryFixed, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'YOUR FAMILY HEALTH LOCKER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryFixed,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.activeMember?.name ?? 'The Sharma Family',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MediVault · ${records.length} records organised',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Member filter pills
            MemberPills(
              members: state.members,
              selectedMemberId: state.selectedMemberId,
              onSelect: state.setMember,
            ),
            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: state.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search doctor, hospital or record…',
                  prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            state.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Chips Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Vault Categories',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllCategories = !_showAllCategories;
                      });
                    },
                    child: Text(_showAllCategories ? 'Show less' : 'All categories'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Horizontal Category Chips
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: MockData.categories.map((cat) {
                  final isSelected = state.selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => state.setCategory(cat),
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.onSurface,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Status Tabs: Active | Saved | Archived
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['Active', 'Saved', 'Archived'].map((mode) {
                  final isSelected = _listMode == mode;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(mode),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _listMode = mode),
                      backgroundColor: AppColors.surfaceContainerLow,
                      selectedColor: AppColors.secondaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.secondary : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? AppColors.secondary : AppColors.surfaceVariant,
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Footnote
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${records.length} matching records',
                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 12),

            // Records List
            if (records.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const Icon(Icons.folder_open, size: 56, color: AppColors.outline),
                      const SizedBox(height: 12),
                      const Text(
                        'No records found',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Try clearing your search or category filter',
                        style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset filters'),
                        onPressed: () {
                          state.setCategory('All records');
                          state.setSearchQuery('');
                          _searchController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  final member = state.members.firstWhere(
                    (m) => m.id == record.memberId,
                    orElse: () => state.members.first,
                  );

                  return RecordCardItem(
                    record: record,
                    member: member,
                    onTap: () => _showRecordDetail(context, record, member),
                    onBookmarkToggle: () => state.toggleBookmark(record.id),
                    onArchiveToggle: () => state.toggleArchive(record.id),
                  );
                },
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddRecord,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add record'),
      ),
    );
  }

  void _showRecordDetail(BuildContext context, MedicalRecord record, FamilyMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentDetailScreen(
          record: record,
          member: member,
          state: widget.state,
          onShare: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SharingScreen(state: widget.state)),
            );
          },
        ),
      ),
    );
  }
}
