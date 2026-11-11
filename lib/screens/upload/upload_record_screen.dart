import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/medical_record.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class UploadRecordScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onCompleted;

  const UploadRecordScreen({
    super.key,
    required this.state,
    required this.onCompleted,
  });

  @override
  State<UploadRecordScreen> createState() => _UploadRecordScreenState();
}

class _UploadRecordScreenState extends State<UploadRecordScreen> {
  int _currentStep = 1;
  String _selectedFileName = '';
  String _selectedFileType = 'PDF';

  final _titleController = TextEditingController();
  final _providerController = TextEditingController();
  final _dateController = TextEditingController(text: '2026-11-03');
  String _selectedCategory = 'Prescriptions';
  late String _selectedMemberId;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = widget.state.activeMember?.id ?? widget.state.members.first.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _providerController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _simulateFilePick(String name, String type) {
    setState(() {
      _selectedFileName = name;
      _selectedFileType = type;
      _titleController.text = name.replaceAll(RegExp(r'\.[^.]+$'), '');
      _currentStep = 2;
    });
  }

  void _saveRecord() {
    if (_titleController.text.trim().isEmpty || _providerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final newRecord = MedicalRecord(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      category: _selectedCategory,
      memberId: _selectedMemberId,
      provider: _providerController.text.trim(),
      date: _dateController.text.trim(),
      type: _selectedFileType,
      notes: 'Added from mobile upload flow.',
    );

    widget.state.addRecord(newRecord);

    setState(() {
      _currentStep = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Health Record'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3-Step Indicator
            Row(
              children: [
                _buildStepItem(1, 'Choose document'),
                _buildStepDivider(1),
                _buildStepItem(2, 'Review & classify'),
                _buildStepDivider(2),
                _buildStepItem(3, 'Saved'),
              ],
            ),
            const SizedBox(height: 24),

            if (_currentStep == 1) _buildStep1()
            else if (_currentStep == 2) _buildStep2()
            else _buildStep3(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(int step, String label) {
    final isActive = _currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isActive ? AppColors.primary : AppColors.surfaceVariant,
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.outline,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(int step) {
    final isActive = _currentStep > step;
    return Container(
      width: 24,
      height: 2,
      color: isActive ? AppColors.primary : AppColors.surfaceVariant,
      margin: const EdgeInsets.only(bottom: 14),
    );
  }

  Widget _buildStep1() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.toneBlueBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.toneBlueBorder),
              ),
              child: const Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose a report or prescription',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'PDF, JPG or PNG · up to 10 MB',
              style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Scan document'),
                    onPressed: () => _simulateFilePick('Scanned_Prescription_${DateTime.now().day}Nov.pdf', 'PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Browse files'),
                    onPressed: () => _simulateFilePick('Blood_Test_Report.jpg', 'Image'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.document_scanner_outlined, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedFileName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const StatusBadge(text: 'OCR Review', tone: 'cream'),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Record title *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'e.g. Dr. Roy Prescription'),
            ),
            const SizedBox(height: 16),
            const Text('Record category *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(),
              items: MockData.categories.skip(1).map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 16),
            const Text('Family member *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedMemberId,
              decoration: const InputDecoration(),
              items: widget.state.members.map((m) {
                return DropdownMenuItem(value: m.id, child: Text(m.name));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedMemberId = val);
              },
            ),
            const SizedBox(height: 16),
            const Text('Doctor / Hospital *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _providerController,
              decoration: const InputDecoration(hintText: 'e.g. Apollo Clinic'),
            ),
            const SizedBox(height: 16),
            const Text('Record date *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(hintText: 'YYYY-MM-DD'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep = 1),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveRecord,
                    child: const Text('Save to Locker'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.toneMintBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.toneMintBorder),
              ),
              child: const Icon(Icons.check, size: 40, color: AppColors.toneMintText),
            ),
            const SizedBox(height: 16),
            Text(
              _titleController.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Organised and securely saved to your health locker.',
              style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.folder_open),
              label: const Text('View Health Locker'),
              onPressed: widget.onCompleted,
            ),
          ],
        ),
      ),
    );
  }
}
