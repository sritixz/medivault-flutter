import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class InsuranceScreen extends StatelessWidget {
  final AppState state;

  const InsuranceScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final policies = state.policies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance & Mediclaim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusBadge(text: 'PROTECTION & CLAIMS', tone: 'blue'),
            const SizedBox(height: 8),
            const Text(
              'Your Health Cover',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Policy details and documents, within reach when needed.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            ...policies.map((p) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.toneBlueBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.shield_outlined, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                ),
                                Text(
                                  p.provider,
                                  style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          const StatusBadge(text: 'ACTIVE', tone: 'mint'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildPolicyRow('Policy number', p.policyNumber),
                      _buildPolicyRow('Sum insured', '₹ ${p.coverAmount}'),
                      _buildPolicyRow('Valid through', p.expiryDate),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Download Policy Card'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Downloading policy card...')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
