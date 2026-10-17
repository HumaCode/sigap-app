import '../../domain/entities/service_site_entity.dart';

Map<String, dynamic> _toMap(dynamic val) {
  if (val is Map) {
    return Map<String, dynamic>.from(val);
  }
  return <String, dynamic>{};
}

class SitesModel {
  final bool success;
  final String message;
  final Data data;

  SitesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  SitesModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      SitesModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory SitesModel.fromJson(Map<String, dynamic> json) => SitesModel(
        success: json['success'] as bool? ?? true,
        message: json['message'] as String? ?? '',
        data: Data.fromJson(_toMap(json['data'])),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };
}

class Data {
  final Counts counts;
  final List<Item> items;
  final Meta meta;

  Data({
    required this.counts,
    required this.items,
    required this.meta,
  });

  Data copyWith({
    Counts? counts,
    List<Item>? items,
    Meta? meta,
  }) =>
      Data(
        counts: counts ?? this.counts,
        items: items ?? this.items,
        meta: meta ?? this.meta,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        counts: Counts.fromJson(_toMap(json['counts'])),
        items: (json['items'] as List<dynamic>?)
                ?.map((x) => Item.fromJson(_toMap(x)))
                .toList() ??
            [],
        meta: Meta.fromJson(_toMap(json['meta'])),
      );

  Map<String, dynamic> toJson() => {
        'counts': counts.toJson(),
        'items': items.map((x) => x.toJson()).toList(),
        'meta': meta.toJson(),
      };
}

class Counts {
  final int all;
  final int operational;
  final int outage;
  final int warn;
  final int ssl;

  Counts({
    required this.all,
    required this.operational,
    required this.outage,
    required this.warn,
    required this.ssl,
  });

  Counts copyWith({
    int? all,
    int? operational,
    int? outage,
    int? warn,
    int? ssl,
  }) =>
      Counts(
        all: all ?? this.all,
        operational: operational ?? this.operational,
        outage: outage ?? this.outage,
        warn: warn ?? this.warn,
        ssl: ssl ?? this.ssl,
      );

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        all: json['all'] as int? ?? 0,
        operational: json['operational'] as int? ?? 0,
        outage: json['outage'] as int? ?? 0,
        warn: json['warn'] as int? ?? 0,
        ssl: json['ssl'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'all': all,
        'operational': operational,
        'outage': outage,
        'warn': warn,
        'ssl': ssl,
      };
}

class Item {
  final String id;
  final String name;
  final String url;
  final String category;
  final String status;
  final int statusCode;
  final String statusLabel;
  final Latency latency;
  final Ssl ssl;
  final String summaryBadge;
  final double uptimePercentage;
  final DateTime lastCheckedAt;
  final String lastCheckedAgo;

  Item({
    required this.id,
    required this.name,
    required this.url,
    required this.category,
    required this.status,
    required this.statusCode,
    required this.statusLabel,
    required this.latency,
    required this.ssl,
    required this.summaryBadge,
    required this.uptimePercentage,
    required this.lastCheckedAt,
    required this.lastCheckedAgo,
  });

  Item copyWith({
    String? id,
    String? name,
    String? url,
    String? category,
    String? status,
    int? statusCode,
    String? statusLabel,
    Latency? latency,
    Ssl? ssl,
    String? summaryBadge,
    double? uptimePercentage,
    DateTime? lastCheckedAt,
    String? lastCheckedAgo,
  }) =>
      Item(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        category: category ?? this.category,
        status: status ?? this.status,
        statusCode: statusCode ?? this.statusCode,
        statusLabel: statusLabel ?? this.statusLabel,
        latency: latency ?? this.latency,
        ssl: ssl ?? this.ssl,
        summaryBadge: summaryBadge ?? this.summaryBadge,
        uptimePercentage: uptimePercentage ?? this.uptimePercentage,
        lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
        lastCheckedAgo: lastCheckedAgo ?? this.lastCheckedAgo,
      );

  factory Item.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    final rawDate = json['last_checked_at'] ?? json['lastCheckedAt'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Item(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      category: json['category'] as String? ?? '',
      status: json['status'] as String? ?? 'operational',
      statusCode: json['status_code'] as int? ?? (json['statusCode'] as int? ?? 200),
      statusLabel: json['status_label'] as String? ?? (json['statusLabel'] as String? ?? ''),
      latency: Latency.fromJson(_toMap(json['latency'])),
      ssl: Ssl.fromJson(_toMap(json['ssl'])),
      summaryBadge: json['summary_badge'] as String? ?? (json['summaryBadge'] as String? ?? ''),
      uptimePercentage: (json['uptime_percentage'] as num?)?.toDouble() ??
          ((json['uptimePercentage'] as num?)?.toDouble() ?? 0.0),
      lastCheckedAt: parsedDate,
      lastCheckedAgo: json['last_checked_ago'] as String? ?? (json['lastCheckedAgo'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'category': category,
        'status': status,
        'status_code': statusCode,
        'status_label': statusLabel,
        'latency': latency.toJson(),
        'ssl': ssl.toJson(),
        'summary_badge': summaryBadge,
        'uptime_percentage': uptimePercentage,
        'last_checked_at': lastCheckedAt.toIso8601String(),
        'last_checked_ago': lastCheckedAgo,
      };

  /// Convert to domain entity [ServiceSiteEntity]
  ServiceSiteEntity toEntity() {
    final parsedId = int.tryParse(id) ?? 0;
    return ServiceSiteEntity(
      id: parsedId,
      name: name,
      domain: url,
      category: category,
      status: status,
      statusCode: statusCode,
      statusText: statusLabel.isNotEmpty ? statusLabel : '$statusCode',
      latencyMs: latency.valueMs,
      sslDaysLeft: ssl.daysLeft,
      regionStatus: summaryBadge.isNotEmpty ? summaryBadge : 'Edge Checked',
      uptime30d: uptimePercentage,
      lastAuditDate: lastCheckedAgo.isNotEmpty ? lastCheckedAgo : 'Just now',
      hasDefacement: false,
      heatmapDailyUptime: List.generate(30, (_) => uptimePercentage),
      latencyBreakdown: LatencyBreakdownEntity(
        dnsMs: (latency.valueMs * 0.15).round(),
        tlsMs: (latency.valueMs * 0.25).round(),
        ttfbMs: (latency.valueMs * 0.40).round(),
        transferMs: (latency.valueMs * 0.20).round(),
      ),
    );
  }
}

class Latency {
  final int valueMs;
  final String formatted;
  final bool isTimeout;

  Latency({
    required this.valueMs,
    required this.formatted,
    required this.isTimeout,
  });

  Latency copyWith({
    int? valueMs,
    String? formatted,
    bool? isTimeout,
  }) =>
      Latency(
        valueMs: valueMs ?? this.valueMs,
        formatted: formatted ?? this.formatted,
        isTimeout: isTimeout ?? this.isTimeout,
      );

  factory Latency.fromJson(Map<String, dynamic> json) => Latency(
        valueMs: json['value_ms'] as int? ?? (json['valueMs'] as int? ?? 0),
        formatted: json['formatted'] as String? ?? '0ms',
        isTimeout: json['is_timeout'] as bool? ?? (json['isTimeout'] as bool? ?? false),
      );

  Map<String, dynamic> toJson() => {
        'value_ms': valueMs,
        'formatted': formatted,
        'is_timeout': isTimeout,
      };
}

class Ssl {
  final int daysLeft;
  final String status;
  final String statusLabel;
  final bool isWarning;

  Ssl({
    required this.daysLeft,
    required this.status,
    required this.statusLabel,
    required this.isWarning,
  });

  Ssl copyWith({
    int? daysLeft,
    String? status,
    String? statusLabel,
    bool? isWarning,
  }) =>
      Ssl(
        daysLeft: daysLeft ?? this.daysLeft,
        status: status ?? this.status,
        statusLabel: statusLabel ?? this.statusLabel,
        isWarning: isWarning ?? this.isWarning,
      );

  factory Ssl.fromJson(Map<String, dynamic> json) => Ssl(
        daysLeft: json['days_left'] as int? ?? (json['daysLeft'] as int? ?? 0),
        status: json['status'] as String? ?? '',
        statusLabel: json['status_label'] as String? ?? (json['statusLabel'] as String? ?? ''),
        isWarning: json['is_warning'] as bool? ?? (json['isWarning'] as bool? ?? false),
      );

  Map<String, dynamic> toJson() => {
        'days_left': daysLeft,
        'status': status,
        'status_label': statusLabel,
        'is_warning': isWarning,
      };
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMore;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMore,
  });

  Meta copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
    bool? hasMore,
  }) =>
      Meta(
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        perPage: perPage ?? this.perPage,
        total: total ?? this.total,
        hasMore: hasMore ?? this.hasMore,
      );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json['current_page'] as int? ?? (json['currentPage'] as int? ?? 1),
        lastPage: json['last_page'] as int? ?? (json['lastPage'] as int? ?? 1),
        perPage: json['per_page'] as int? ?? (json['perPage'] as int? ?? 15),
        total: json['total'] as int? ?? 0,
        hasMore: json['has_more'] as bool? ?? (json['hasMore'] as bool? ?? false),
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
        'has_more': hasMore,
      };
}
