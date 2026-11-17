import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class MembershipScreen extends StatefulWidget {
  final AppState state;

  const MembershipScreen({super.key, required this.state});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  late List<String> _selectedMemberIds;
  int _stage = 0; // 0: plans overview, 1: select members, 2: review, 3: success

  @override
  void initState() {
    super.initState();
    _selectedMemberIds = List.from(widget.state.subscribedMembers);
  }

  int get _monthlyTotal => _selectedMemberIds.length * 499;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Plans'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildCurrentStage(),
      ),
    );
  }

  Widget _buildCurrentStage() {
    if (_stage == 1) return _buildSelectMembersStage();
    if (_stage == 2) return _buildReviewStage();
    if (_stage == 3) return _buildSuccessStage();
    return _buildOverviewStage();
  }

  Widget _buildOverviewStage() {
    final isActive = widget.state.isMemberPlanActive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusBadge(text: 'CARE THAT GROWS WITH YOU', tone: 'mint'),
        const SizedBox(height: 8),
        const Text(
          'One health space.\nRoom for your family.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.25),
        ),
        const SizedBox(height: 20),

        // Free Plan Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Free Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    StatusBadge(
                      text: isActive ? 'AVAILABLE' : 'CURRENT',
                      tone: isActive ? 'neutral' : 'mint',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '₹ 0',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                const Text('Start your family health record journey', style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                _buildFeatureCheck('Core health record storage'),
                _buildFeatureCheck('Family profiles for all members'),
                _buildFeatureCheck('Standard categorization & tags'),
                const SizedBox(height: 16),
                if (isActive)
                  OutlinedButton(
                    onPressed: () {
                      widget.state.setPlan(active: false, memberIds: []);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Switched to Free Plan.')),
                      );
                    },
                    child: const Text('Downgrade to Free'),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Premium Member Plan Card
        Container(
          decoration: BoxDecoration(
            color: AppColors.toneMintBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondary, width: 2),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Member Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.toneMintText)),
                  StatusBadge(
                    text: isActive ? 'ACTIVE PREVIEW' : 'RECOMMENDED',
                    tone: 'mint',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '₹ 499',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.toneMintText),
                  ),
                  SizedBox(width: 6),
                  Text('/ member / month', style: TextStyle(fontSize: 13, color: AppColors.toneMintText)),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Full premium features for chosen family members', style: TextStyle(fontSize: 13, color: AppColors.toneMintText)),
              const SizedBox(height: 16),
              const Divider(color: AppColors.toneMintBorder),
              const SizedBox(height: 8),
              _buildFeatureCheck('Automated OCR text extraction & indexing'),
              _buildFeatureCheck('Emergency Profile lock-screen card export'),
              _buildFeatureCheck('Secure doctor & practitioner sharing links'),
              _buildFeatureCheck('Priority support & storage backup'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => setState(() => _stage = 1),
                  child: Text(
                    isActive ? 'Change Covered Members' : 'Choose Members & Upgrade',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectMembersStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Who is this plan for?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Choose family members to calculate the monthly total.', style: TextStyle(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 20),
        ...widget.state.members.map((m) {
          final isChecked = _selectedMemberIds.contains(m.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: CheckboxListTile(
              value: isChecked,
              title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('${m.relation} · ₹499 / month'),
              secondary: MemberAvatar(member: m, radius: 20),
              activeColor: AppColors.primary,
              onChanged: (bool? val) {
                setState(() {
                  if (val == true) {
                    _selectedMemberIds.add(m.id);
                  } else {
                    _selectedMemberIds.remove(m.id);
                  }
                });
              },
            ),
          );
        }),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_selectedMemberIds.length} members covered', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '₹ $_monthlyTotal / month',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _stage = 0),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _selectedMemberIds.isNotEmpty ? () => setState(() => _stage = 2) : null,
                child: const Text('Review Plan'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review Membership', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusBadge(text: 'MEMBER PLAN PREVIEW', tone: 'mint'),
                const SizedBox(height: 12),
                Text(
                  '₹ $_monthlyTotal',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                Text('per month · ${_selectedMemberIds.length} family members', style: const TextStyle(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 16),
                const Divider(),
                ..._selectedMemberIds.map((id) {
                  final m = widget.state.members.firstWhere((x) => x.id == id);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(m.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const Text('₹ 499 / mo', style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  );
                }),
                const Divider(),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Billing Cycle', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    Text('Monthly', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    Text('Design Preview (No charge)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _stage = 1),
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
                onPressed: () {
                  widget.state.setPlan(active: true, memberIds: _selectedMemberIds);
                  setState(() => _stage = 3);
                },
                child: const Text('Confirm Plan Preview'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessStage() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.toneMintBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 48, color: AppColors.toneMintText),
          ),
          const SizedBox(height: 20),
          const StatusBadge(text: 'NO PAYMENT TAKEN', tone: 'mint'),
          const SizedBox(height: 12),
          const Text(
            'Your plan preview is ready',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '${_selectedMemberIds.length} members covered · ₹ $_monthlyTotal / month',
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => setState(() => _stage = 0),
              child: const Text('View Membership'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCheck(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.secondary, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
