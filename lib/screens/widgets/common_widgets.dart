import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/family_member.dart';
import '../../core/models/medical_record.dart';

class ToneStyle {
  final Color background;
  final Color textColor;
  final Color borderColor;

  const ToneStyle({
    required this.background,
    required this.textColor,
    required this.borderColor,
  });

  static ToneStyle getTone(String tone) {
    switch (tone.toLowerCase()) {
      case 'mint':
        return const ToneStyle(
          background: AppColors.toneMintBg,
          textColor: AppColors.toneMintText,
          borderColor: AppColors.toneMintBorder,
        );
      case 'peach':
        return const ToneStyle(
          background: AppColors.tonePeachBg,
          textColor: AppColors.tonePeachText,
          borderColor: AppColors.tonePeachBorder,
        );
      case 'blue':
        return const ToneStyle(
          background: AppColors.toneBlueBg,
          textColor: AppColors.toneBlueText,
          borderColor: AppColors.toneBlueBorder,
        );
      case 'cream':
        return const ToneStyle(
          background: AppColors.toneCreamBg,
          textColor: AppColors.toneCreamText,
          borderColor: AppColors.toneCreamBorder,
        );
      case 'rose':
        return const ToneStyle(
          background: AppColors.toneRoseBg,
          textColor: AppColors.toneRoseText,
          borderColor: AppColors.toneRoseBorder,
        );
      case 'aqua':
        return const ToneStyle(
          background: AppColors.toneAquaBg,
          textColor: AppColors.toneAquaText,
          borderColor: AppColors.toneAquaBorder,
        );
      case 'lilac':
        return const ToneStyle(
          background: AppColors.toneLilacBg,
          textColor: AppColors.toneLilacText,
          borderColor: AppColors.toneLilacBorder,
        );
      default:
        return const ToneStyle(
          background: AppColors.surfaceContainerLow,
          textColor: AppColors.onSurfaceVariant,
          borderColor: AppColors.surfaceVariant,
        );
    }
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final String tone;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    this.tone = 'neutral',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = ToneStyle.getTone(tone);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: style.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: style.textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: style.textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class MemberPills extends StatelessWidget {
  final List<FamilyMember> members;
  final String selectedMemberId;
  final ValueChanged<String> onSelect;

  const MemberPills({
    super.key,
    required this.members,
    required this.selectedMemberId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildPill('Everyone', 'all', selectedMemberId == 'all'),
          ...members.map(
            (m) => _buildPill(m.shortName, m.id, selectedMemberId == m.id),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String label, String id, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelect(id),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.onSurface,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}

class MemberAvatar extends StatelessWidget {
  final FamilyMember member;
  final double radius;

  const MemberAvatar({
    super.key,
    required this.member,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final style = ToneStyle.getTone(member.color);
    return CircleAvatar(
      radius: radius,
      backgroundColor: style.background,
      child: Text(
        member.initials,
        style: TextStyle(
          color: style.textColor,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.75,
        ),
      ),
    );
  }
}

class RecordCardItem extends StatelessWidget {
  final MedicalRecord record;
  final FamilyMember? member;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onArchiveToggle;

  const RecordCardItem({
    super.key,
    required this.record,
    this.member,
    this.onTap,
    this.onBookmarkToggle,
    this.onArchiveToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${record.provider} · ${record.date}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      record.bookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: record.bookmarked ? AppColors.secondary : AppColors.outline,
                    ),
                    onPressed: onBookmarkToggle,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  StatusBadge(text: record.category, tone: 'blue'),
                  const SizedBox(width: 8),
                  if (member != null)
                    StatusBadge(text: member!.shortName, tone: member!.color),
                  const Spacer(),
                  Text(
                    record.type,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
