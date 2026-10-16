import 'package:equatable/equatable.dart';

class IncidentEntity extends Equatable {
  final int id;
  final String incidentCode; // e.g. 'INC-4082'
  final String title;
  final String endpoint;
  final String severity; // 'P1 Critical', 'P2 High', 'P3 Medium', 'P4 Low'
  final String status; // 'Investigating', 'In Progress', 'Resolved'
  final String timeAgo;
  final double errorRate;
  final int affectedUsers;
  final String blastRadius;
  final String aiRootCause;
  final int aiConfidence;
  final List<String> aiMitigations;
  final String technicianNotes;

  const IncidentEntity({
    required this.id,
    required this.incidentCode,
    required this.title,
    required this.endpoint,
    required this.severity,
    required this.status,
    required this.timeAgo,
    required this.errorRate,
    required this.affectedUsers,
    required this.blastRadius,
    required this.aiRootCause,
    required this.aiConfidence,
    required this.aiMitigations,
    this.technicianNotes = '',
  });

  bool get isCritical => severity.toLowerCase().contains('critical') || severity.contains('P1');
  bool get isResolved => status.toLowerCase() == 'resolved';

  IncidentEntity copyWith({
    String? status,
    String? technicianNotes,
  }) {
    return IncidentEntity(
      id: id,
      incidentCode: incidentCode,
      title: title,
      endpoint: endpoint,
      severity: severity,
      status: status ?? this.status,
      timeAgo: timeAgo,
      errorRate: errorRate,
      affectedUsers: affectedUsers,
      blastRadius: blastRadius,
      aiRootCause: aiRootCause,
      aiConfidence: aiConfidence,
      aiMitigations: aiMitigations,
      technicianNotes: technicianNotes ?? this.technicianNotes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        incidentCode,
        title,
        endpoint,
        severity,
        status,
        timeAgo,
        errorRate,
        affectedUsers,
        blastRadius,
        aiRootCause,
        aiConfidence,
        aiMitigations,
        technicianNotes,
      ];
}
