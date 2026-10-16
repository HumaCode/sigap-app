import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardStatsEntity stats;
  final String activeRange; // '24h', '7d', '30d'

  const DashboardLoaded({
    required this.stats,
    this.activeRange = '24h',
  });

  DashboardLoaded copyWith({
    DashboardStatsEntity? stats,
    String? activeRange,
  }) {
    return DashboardLoaded(
      stats: stats ?? this.stats,
      activeRange: activeRange ?? this.activeRange,
    );
  }

  @override
  List<Object?> get props => [stats, activeRange];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
