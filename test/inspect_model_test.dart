import 'package:flutter_test/flutter_test.dart';
import 'package:sigap_app/features/services/data/models/inspect_model.dart';

void main() {
  group('InspectModel Unit Tests', () {
    test('should parse valid Laravel Inspect API response JSON', () {
      final json = {
        'success': true,
        'message': 'Inspect data retrieved successfully',
        'data': {
          'service': {
            'id': '1',
            'short_id': 'SVC-01',
            'name': 'api.payments.io',
            'url': 'https://api.payments.io',
            'subtitle': 'REST API · Global Payment Gateway',
            'status': 'operational',
            'status_code': 200,
            'status_label': '200 OK',
            'metrics': {
              'uptime_30d': 99.98,
              'uptime_30d_formatted': '99.98%',
              'avg_latency_ms': 24,
              'avg_latency_formatted': '24ms',
              'poll_cycle': '30s',
            },
            'alert': {
              'is_alert': false,
              'message': 'No active alerts detected',
            }
          },
          'heatmap': {
            'title': '30-Day Uptime Heatmap',
            'range_label': 'Past 30 Days Telemetry',
            'summary': {
              'operational': 29,
              'degraded': 1,
              'downtime': 0,
            },
            'cells': [
              {
                'day': 1,
                'date': '2026-10-17T00:00:00.000Z',
                'label': 'Day 1',
                'uptime_percentage': 100.0,
                'status': 'operational',
                'is_today': true,
              }
            ]
          },
          'latency_breakdown': {
            'total_latency_ms': 24,
            'total_latency_formatted': '24ms',
            'is_failed': false,
            'stages': [
              {
                'name': 'DNS Lookup',
                'latency_ms': 4,
                'percentage': 16,
                'status': 'healthy',
              },
              {
                'name': 'TLS Handshake',
                'latency_ms': 11,
                'percentage': 45,
                'status': 'healthy',
              },
              {
                'name': 'TTFB',
                'latency_ms': 6,
                'percentage': 25,
                'status': 'healthy',
              },
              {
                'name': 'Transfer',
                'latency_ms': 3,
                'percentage': 14,
                'status': 'healthy',
              }
            ]
          },
          'available_services': [
            {
              'id': '1',
              'name': 'api.payments.io',
              'url': 'https://api.payments.io',
              'status': 'operational',
              'category': 'Payments',
            }
          ]
        }
      };

      final model = InspectModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.message, 'Inspect data retrieved successfully');
      expect(model.data.service.id, '1');
      expect(model.data.service.name, 'api.payments.io');
      expect(model.data.service.metrics.avgLatencyMs, 24);
      expect(model.data.service.metrics.uptime30D, 99.98);
      expect(model.data.heatmap.summary.operational, 29);
      expect(model.data.heatmap.cells.length, 1);
      expect(model.data.heatmap.cells.first.isToday, isTrue);
      expect(model.data.latencyBreakdown.stages.length, 4);
      expect(model.data.availableServices.length, 1);

      final entity = model.data.toEntity();
      expect(entity.id, 1);
      expect(entity.name, 'api.payments.io');
      expect(entity.latencyMs, 24);
      expect(entity.uptime30d, 99.98);
    });

    test('should handle empty objects gracefully', () {
      final json = {
        'success': true,
        'message': 'No data',
        'data': {
          'service': {},
          'heatmap': {},
          'latency_breakdown': {},
          'available_services': [],
        }
      };

      final model = InspectModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data.service.name, '');
      expect(model.data.heatmap.cells, isEmpty);
      expect(model.data.availableServices, isEmpty);
    });
  });
}
