import '../../domain/entities/incident_entity.dart';
import 'insiden_model.dart';

class IncidentModel extends IncidentEntity {
  const IncidentModel({
    required super.id,
    required super.incidentCode,
    required super.title,
    required super.endpoint,
    required super.severity,
    required super.status,
    required super.timeAgo,
    required super.errorRate,
    required super.affectedUsers,
    required super.blastRadius,
    required super.aiRootCause,
    required super.aiConfidence,
    required super.aiMitigations,
    super.technicianNotes,
  });

  factory IncidentModel.fromItem(Item item) {
    final entity = item.toEntity();
    return IncidentModel(
      id: entity.id,
      incidentCode: entity.incidentCode,
      title: entity.title,
      endpoint: entity.endpoint,
      severity: entity.severity,
      status: entity.status,
      timeAgo: entity.timeAgo,
      errorRate: entity.errorRate,
      affectedUsers: entity.affectedUsers,
      blastRadius: entity.blastRadius,
      aiRootCause: entity.aiRootCause,
      aiConfidence: entity.aiConfidence,
      aiMitigations: entity.aiMitigations,
      technicianNotes: entity.technicianNotes,
    );
  }

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    final mitigations = (json['ai_mitigations'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [
          'Restart unhealthy worker pods: kubectl rollout restart deployment/payment-workers',
          'Scale edge connection limit: increase max_connections to 2,000 on edge proxy.',
        ];

    return IncidentModel(
      id: json['id'] as int? ?? 4082,
      incidentCode: json['incident_code'] as String? ?? 'INC-4082',
      title: json['title'] as String? ?? 'Payment Gateway API Down (HTTP 502)',
      endpoint: json['endpoint'] as String? ?? 'api.payments.io - /v1/checkout/charge',
      severity: json['severity'] as String? ?? 'P1 Critical',
      status: json['status'] as String? ?? 'Investigating',
      timeAgo: json['time_ago'] as String? ?? '14m ago',
      errorRate: (json['error_rate'] as num?)?.toDouble() ?? 98.4,
      affectedUsers: json['affected_users'] as int? ?? 1420,
      blastRadius: json['blast_radius'] as String? ?? 'US-East, EU, AP',
      aiRootCause: json['ai_root_cause'] as String? ??
          'Upstream Envoy ingress pool exhaustion due to downstream database deadlocks in payment tokenization workers.',
      aiConfidence: json['ai_confidence'] as int? ?? 96,
      aiMitigations: mitigations,
      technicianNotes: json['technician_notes'] as String? ?? '',
    );
  }

  static List<IncidentModel> get sampleIncidents => [
        const IncidentModel(
          id: 4082,
          incidentCode: 'INC-4082',
          title: 'Payment Gateway API Down (HTTP 502)',
          endpoint: 'api.payments.io - /v1/checkout/charge',
          severity: 'P1 Critical',
          status: 'Investigating',
          timeAgo: '14 mins ago',
          errorRate: 98.4,
          affectedUsers: 1420,
          blastRadius: 'US-East, EU, AP',
          aiRootCause:
              'Upstream Envoy ingress pool exhaustion due to downstream database lock contention in payment worker pods.',
          aiConfidence: 96,
          aiMitigations: [
            'Trigger pod rolling restart: kubectl rollout restart deployment/payment-workers',
            'Scale connection pool limit: increase max_connections to 2,000.',
            'Drain failed transactions queue to avoid cascade timeouts.',
          ],
        ),
        const IncidentModel(
          id: 4079,
          incidentCode: 'INC-4079',
          title: 'Auth Service Latency Spike (p99 > 850ms)',
          endpoint: 'auth.cloudapp.net - /oauth/token',
          severity: 'P2 High',
          status: 'Resolved',
          timeAgo: '2 hours ago',
          errorRate: 12.1,
          affectedUsers: 340,
          blastRadius: 'EU-Central',
          aiRootCause: 'Redis cache node memory eviction saturation.',
          aiConfidence: 92,
          aiMitigations: ['Flushed stale session keys and scaled Redis replica nodes.'],
        ),
        const IncidentModel(
          id: 4075,
          incidentCode: 'INC-4075',
          title: 'Static Asset Edge 404 Cache Invalidation',
          endpoint: 'cdn-static.assets.sre - /bundles/*',
          severity: 'P3 Medium',
          status: 'Resolved',
          timeAgo: '5 hours ago',
          errorRate: 4.2,
          affectedUsers: 110,
          blastRadius: 'Global Edge',
          aiRootCause: 'Stale Cloudflare edge cache tag during automated deployment.',
          aiConfidence: 98,
          aiMitigations: ['Executed global cache purge via Cloudflare API.'],
        ),
      ];
}
