import 'package:flutter_test/flutter_test.dart';
import 'package:sigap_app/features/incidents/data/models/insiden_model.dart';

void main() {
  group('InsidenModel Unit Tests', () {
    test('should parse valid Laravel incidents API response JSON', () {
      final json = {
        'success': true,
        'message': 'Incidents retrieved successfully',
        'data': {
          'war_room': {
            'active_p1': 1,
            'active_p1_label': '1 Insiden Kritis Aktif',
            'resolved_today': 4,
            'resolved_today_label': '4 Selesai Hari Ini',
            'mttr_minutes': 14,
            'mttr_label': '14 Menit MTTR',
          },
          'counts': {
            'all': 5,
            'critical': 1,
            'high': 2,
            'investigating': 1,
            'resolved': 4,
          },
          'items': [
            {
              'id': '4082',
              'incident_code': 'INC-4082',
              'title': 'Payment Gateway API Down (HTTP 502)',
              'endpoint': '/v1/checkout/charge',
              'site_id': '1',
              'site_name': 'api.payments.io',
              'site_url': 'https://api.payments.io',
              'type': 'HTTP_ERROR',
              'severity': 'critical',
              'severity_badge': 'P1 Critical',
              'status': 'investigating',
              'status_label': 'Sedang Diinvestigasi',
              'metrics': {
                'error_rate': '98.4%',
                'affected_users': '1,420',
                'blast_radius': 'Global Edge',
                'subtext': 'Downstream timeout',
                'peak_rps': '1,250 rps',
              },
              'ai_diagnostic': {
                'provider': 'Google Gemini SRE',
                'model': 'gemini-1.5-flash',
                'confidence': '96%',
                'root_cause': 'Upstream Envoy ingress pool exhaustion',
                'recommended_steps': [
                  'Trigger pod rolling restart',
                  'Increase max_connections on edge proxy',
                ],
              },
              'detected_at': '2026-10-17T14:40:00.000Z',
              'detected_ago': '14m yang lalu',
              'resolved_at': null,
            }
          ],
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': 15,
            'total': 1,
            'has_more': false,
          }
        }
      };

      final model = InsidenModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.message, 'Incidents retrieved successfully');
      expect(model.data.warRoom.activeP1, 1);
      expect(model.data.warRoom.mttrMinutes, 14);
      expect(model.data.counts.critical, 1);
      expect(model.data.counts.resolved, 4);
      expect(model.data.items.length, 1);

      final item = model.data.items.first;
      expect(item.id, '4082');
      expect(item.incidentCode, 'INC-4082');
      expect(item.metrics.errorRate, '98.4%');
      expect(item.aiDiagnostic.confidence, '96%');
      expect(item.aiDiagnostic.recommendedSteps.length, 2);

      final entity = item.toEntity();
      expect(entity.id, 4082);
      expect(entity.incidentCode, 'INC-4082');
      expect(entity.isCritical, isTrue);
      expect(entity.aiConfidence, 96);
      expect(entity.errorRate, 98.4);
      expect(entity.affectedUsers, 1420);
    });

    test('should handle empty data without throwing exceptions', () {
      final json = {
        'success': true,
        'message': 'No incidents found',
        'data': {
          'war_room': {},
          'counts': {},
          'items': [],
          'meta': {},
        }
      };

      final model = InsidenModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data.warRoom.activeP1, 0);
      expect(model.data.counts.all, 0);
      expect(model.data.items, isEmpty);
      expect(model.data.meta.total, 0);
    });
  });
}
