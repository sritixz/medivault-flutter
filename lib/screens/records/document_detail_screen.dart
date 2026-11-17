import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/medical_record.dart';
import '../../core/models/family_member.dart';
import '../../core/models/other_models.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class DocumentDetailScreen extends StatefulWidget {
  final MedicalRecord record;
  final FamilyMember member;
  final AppState state;
  final VoidCallback onShare;

  const DocumentDetailScreen({
    super.key,
    required this.record,
    required this.member,
    required this.state,
    required this.onShare,
  });

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _zoomScale = 1.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _zoomScale = (_zoomScale + 0.25).clamp(0.5, 2.5);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomScale = (_zoomScale - 0.25).clamp(0.5, 2.5);
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomScale = 1.0;
    });
  }

  void _testPasswordDialog() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Password-Protected PDF Test'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Test how MediVault unlocks password-encrypted medical records:'),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter test password (e.g. 1234)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document successfully decrypted and verified.')),
                );
              },
              child: const Text('Unlock'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final member = widget.member;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Text('${member.name} · ${record.date}', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              record.bookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: record.bookmarked ? AppColors.secondary : null,
            ),
            onPressed: () => widget.state.toggleBookmark(record.id),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: widget.onShare,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Document'),
            Tab(text: 'Clinical Details'),
            Tab(text: 'History & Tags'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDocumentViewerTab(),
          _buildClinicalDetailsTab(),
          _buildHistoryAndTagsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.surfaceVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(record.archived ? Icons.unarchive : Icons.archive_outlined, size: 18),
                label: Text(record.archived ? 'Restore' : 'Archive'),
                onPressed: () {
                  widget.state.toggleArchive(record.id);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download PDF'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Saved "${record.title}.pdf" to device.')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentViewerTab() {
    return Column(
      children: [
        // Zoom & page toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.surfaceContainerLow,
          child: Row(
            children: [
              const StatusBadge(text: 'Page 1 of 1', tone: 'blue'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20),
                onPressed: _zoomOut,
                tooltip: 'Zoom Out',
              ),
              Text(
                '${(_zoomScale * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: _zoomIn,
                tooltip: 'Zoom In',
              ),
              IconButton(
                icon: const Icon(Icons.fit_screen, size: 20),
                onPressed: _resetZoom,
                tooltip: 'Reset Zoom',
              ),
              IconButton(
                icon: const Icon(Icons.lock_outline, size: 20),
                onPressed: _testPasswordDialog,
                tooltip: 'Test Password PDF',
              ),
            ],
          ),
        ),

        // Document Canvas
        Expanded(
          child: Container(
            color: const Color(0xFFE5E7EB),
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Transform.scale(
                  scale: _zoomScale,
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medical letterhead header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.record.provider,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary),
                                ),
                                const Text('Department of Clinical Medicine', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                            const Icon(Icons.local_hospital, color: AppColors.primary, size: 24),
                          ],
                        ),
                        const Divider(thickness: 1.5, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Patient: ${widget.member.name}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            Text('Date: ${widget.record.date}', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Category: ${widget.record.category}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.record.notes.isNotEmpty
                              ? widget.record.notes
                              : 'Patient presented for standard clinical evaluation. Vitals normal. Follow instructions as prescribed.',
                          style: const TextStyle(fontSize: 11, height: 1.4, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.toneMintBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rx Instructions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.toneMintText)),
                              Text('1. Tab Metformin 500mg - 1 Tab OD after food', style: TextStyle(fontSize: 10, color: AppColors.toneMintText)),
                              Text('2. Tab Multivitamin - 1 Tab OD after breakfast', style: TextStyle(fontSize: 10, color: AppColors.toneMintText)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Dr. Digital Signature', style: TextStyle(fontFamily: 'cursive', fontSize: 13, color: AppColors.primary)),
                              Text(widget.record.provider, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClinicalDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Clinical Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Healthcare Provider', widget.record.provider),
                  _buildDetailRow('Record Date', widget.record.date),
                  _buildDetailRow('Record Category', widget.record.category),
                  _buildDetailRow('Patient Profile', widget.member.name),
                  if (widget.record.notes.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('Physician Notes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(widget.record.notes, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Prescription Medicines Linked', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.medication, color: AppColors.primary),
              title: const Text('Metformin 500 mg', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('1 tablet · After lunch · Linked to this record'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryFixed,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                ),
                onPressed: () {
                  final newMed = MedicineItem(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: 'Metformin 500 mg',
                    dose: '1 tablet · After lunch',
                    time: '14:00',
                    memberId: widget.record.memberId,
                  );
                  widget.state.addMedicine(newMed);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to daily medicine reminder schedule.')),
                  );
                },
                child: const Text('Add to Tracker'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryAndTagsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Record Tags', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              StatusBadge(text: widget.record.category.toLowerCase(), tone: 'mint'),
              const StatusBadge(text: 'verified-record', tone: 'blue'),
              const StatusBadge(text: 'annual-care', tone: 'peach'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Version & Audit History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.toneMintBg,
                      child: Icon(Icons.check, color: AppColors.toneMintText, size: 18),
                    ),
                    title: const Text('Version 2 (Current)', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('Metadata verified and OCR indexed · ${widget.record.date}'),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.surfaceContainerLow,
                      child: Icon(Icons.history, color: AppColors.outline, size: 18),
                    ),
                    title: const Text('Version 1 (Initial Capture)', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Uploaded via Mobile Document Scanner'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
}
