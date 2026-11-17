import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class PrivacyScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onOpenSharing;

  const PrivacyScreen({
    super.key,
    required this.state,
    required this.onOpenSharing,
  });

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _exportConsent = false;

  void _generateExportData() {
    final data = {
      'account': {
        'name': widget.state.userName,
        'email': widget.state.userEmail,
      },
      'members': widget.state.members.map((m) => {
        'id': m.id,
        'name': m.name,
        'relation': m.relation,
        'bloodGroup': m.bloodGroup,
        'age': m.age,
      }).toList(),
      'records': widget.state.records.map((r) => {
        'id': r.id,
        'title': r.title,
        'category': r.category,
        'provider': r.provider,
        'date': r.date,
      }).toList(),
    };

    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('MediVault Preview Export'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('JSON Export Preview Generated:'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    jsonStr.length > 300 ? '${jsonStr.substring(0, 300)}...\n}' : jsonStr,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Save Export'),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('medivault-preview-export.json ready for download.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Access Control'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusBadge(text: 'DATA SOVEREIGNTY', tone: 'mint'),
            const SizedBox(height: 8),
            const Text(
              'Your Health. Your Choices.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Review who can access your records and control how your data is used.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.share_outlined, color: AppColors.primary),
                    title: const Text('Record Sharing Permissions', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('1 active practitioner link'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: widget.onOpenSharing,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.people_outline, color: AppColors.primary),
                    title: const Text('Family Profile Access', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('All profiles managed by Vikram Sharma'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Access for all 4 profiles is managed by family admin.')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                    title: const Text('Export My Health Data', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Download your preview metadata JSON copy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showExportBottomSheet(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Consent & In-App Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                value: widget.state.remindersEnabled,
                onChanged: (_) => widget.state.toggleReminders(),
                title: const Text('Optional Health Reminders', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Show scheduled medicine alerts and appointment reminders.'),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              color: AppColors.toneRoseBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.toneRoseBorder),
              ),
              child: ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.toneRoseText),
                title: const Text('Delete Account Data', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.toneRoseText)),
                subtitle: const Text('Erase all cached preview records and family profiles.', style: TextStyle(color: AppColors.toneRoseText, fontSize: 12)),
                trailing: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Erase Preview Workspace?'),
                        content: const Text('This will reset all family profiles and records back to initial sample state.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Workspace reset to defaults.')),
                              );
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Reset', style: TextStyle(color: AppColors.toneRoseText, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('A Copy of Your Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text('Your export includes:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Row(children: [Icon(Icons.check, size: 16, color: AppColors.secondary), SizedBox(width: 8), Text('Account & Profile details')]),
                  const SizedBox(height: 4),
                  const Row(children: [Icon(Icons.check, size: 16, color: AppColors.secondary), SizedBox(width: 8), Text('4 Family member health records')]),
                  const SizedBox(height: 4),
                  const Row(children: [Icon(Icons.check, size: 16, color: AppColors.secondary), SizedBox(width: 8), Text('Medicines, Policies & Emergency profiles')]),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: _exportConsent,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I understand this file contains personal medical metadata.', style: TextStyle(fontSize: 12)),
                    onChanged: (val) {
                      setModalState(() => _exportConsent = val ?? false);
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _exportConsent
                          ? () {
                              Navigator.pop(ctx);
                              _generateExportData();
                            }
                          : null,
                      child: const Text('Prepare & Download Export'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
