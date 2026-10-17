import 'package:flutter_test/flutter_test.dart';
import 'package:sigap_app/features/services/data/models/sites_model.dart';

void main() {
  group('SitesModel Unit Tests', () {
    test('should parse valid Laravel sites API response JSON', () {
      final json = {
        'success': true,
        'message': 'Sites retrieved successfully',
        'data': {
          'counts': {
            'all': 1,
            'operational': 1,
            'outage': 0,
            'warn': 0,
            'ssl': 0,
          },
          'items': [
            {
              'id': '1',
              'name': 'Kemnaker Portal',
              'url': 'https://kemnaker.go.id',
              'category': 'Pemerintahan',
              'status': 'operational',
              'status_code': 200,
              'status_label': '200 OK',
              'latency': {
                'value_ms': 42,
                'formatted': '42ms',
                'is_timeout': false,
              },
              'ssl': {
                'days_left': 90,
                'status': 'valid',
                'status_label': 'Valid (90 hari)',
                'is_warning': false,
              },
              'summary_badge': 'Optimal',
              'uptime_percentage': 99.98,
              'last_checked_at': '2026-10-17T14:30:00.000Z',
              'last_checked_ago': '1m yang lalu',
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

      final model = SitesModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.message, 'Sites retrieved successfully');
      expect(model.data.counts.all, 1);
      expect(model.data.counts.operational, 1);
      expect(model.data.items.length, 1);

      final item = model.data.items.first;
      expect(item.id, '1');
      expect(item.name, 'Kemnaker Portal');
      expect(item.url, 'https://kemnaker.go.id');
      expect(item.latency.valueMs, 42);
      expect(item.ssl.daysLeft, 90);
      expect(item.uptimePercentage, 99.98);

      final entity = item.toEntity();
      expect(entity.id, 1);
      expect(entity.name, 'Kemnaker Portal');
      expect(entity.domain, 'https://kemnaker.go.id');
      expect(entity.latencyMs, 42);
    });

    test('should handle empty data gracefully without throwing exceptions', () {
      final json = {
        'success': true,
        'message': 'No sites available',
        'data': {
          'counts': {},
          'items': [],
          'meta': {},
        }
      };

      final model = SitesModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data.counts.all, 0);
      expect(model.data.items, isEmpty);
      expect(model.data.meta.total, 0);
    });
  });
}
