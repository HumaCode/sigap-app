import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/incident_entity.dart';

class AiDiagnosticCard extends StatelessWidget {
  final IncidentEntity incident;
  final ValueChanged<String> onStatusChange;

  const AiDiagnosticCard({
    super.key,
    required this.incident,
    required this.onStatusChange,
  });

  void _shareToTeam() {
    final text = '''
🚨 *[SIGAP SRE INCIDENT REPORT]* 🚨
• Incident: ${incident.title} (${incident.severity})
• Code: ${incident.incidentCode}
• Affected: ${incident.endpoint}
• Blast Radius: ${incident.blastRadius} (~${incident.affectedUsers} users)
• Status: ${incident.status}

🤖 *9Router AI Root Cause Analysis:*
"${incident.aiRootCause}"

💡 *Rekomendasi Mitigasi:*
${incident.aiMitigations.map((m) => "- $m").join("\n")}

Diperbarui secara realtime via SIGAP Mobile Android App.
''';

    SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: 'SIGAP Incident Alert - ${incident.incidentCode}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.canvasBg,
        borderRadius: AppSpacing.roundedXl,
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Sparkle Badge & Confidence
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.mintBadgeTint,
                      borderRadius: AppSpacing.roundedMd,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: AppColors.accentTealDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '9Router AI Diagnostic',
                        style: AppTypography.titleSm.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Model v4.3-SRE',
                        style: AppTypography.codeSm.copyWith(
                          color: AppColors.accentTealDark,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.mintBadgeTint,
                  borderRadius: AppSpacing.roundedFull,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, size: 13, color: AppColors.primary),
                    const SizedBox(width: 3),
                    Text(
                      '${incident.aiConfidence}% Conf.',
                      style: AppTypography.codeSm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Root Cause Detected Statement Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: AppSpacing.roundedLg,
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology_outlined, size: 15, color: AppColors.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      'ROOT CAUSE DETECTED',
                      style: AppTypography.labelXs.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  incident.aiRootCause,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Mitigations List
          Text(
            'Recommended Remediation Steps:',
            style: AppTypography.codeSm.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...incident.aiMitigations.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.mintBadgeTint,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: AppTypography.labelXs.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // Rapid Status Actions & WhatsApp Share
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: incident.status,
                  decoration: InputDecoration(
                    labelText: 'Status Insiden',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: AppSpacing.roundedMd),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Investigating', child: Text('Investigating')),
                    DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                    DropdownMenuItem(value: 'Resolved', child: Text('Resolved')),
                  ],
                  onChanged: (val) {
                    if (val != null) onStatusChange(val);
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _shareToTeam,
                icon: const Icon(Icons.share, size: 16),
                label: Text(
                  'Share Tim',
                  style: AppTypography.codeSm.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentTealDark,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
