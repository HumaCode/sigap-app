import 'package:equatable/equatable.dart';
import '../../domain/entities/incident_entity.dart';

abstract class IncidentsState extends Equatable {
  const IncidentsState();

  @override
  List<Object?> get props => [];
}

class IncidentsInitial extends IncidentsState {}

class IncidentsLoading extends IncidentsState {}

class IncidentsLoaded extends IncidentsState {
  final List<IncidentEntity> allIncidents;
  final List<IncidentEntity> filteredIncidents;
  final String activeSeverityFilter; // 'all', 'critical', 'high', 'resolved'

  const IncidentsLoaded({
    required this.allIncidents,
    required this.filteredIncidents,
    this.activeSeverityFilter = 'all',
  });

  IncidentsLoaded copyWith({
    List<IncidentEntity>? allIncidents,
    List<IncidentEntity>? filteredIncidents,
    String? activeSeverityFilter,
  }) {
    return IncidentsLoaded(
      allIncidents: allIncidents ?? this.allIncidents,
      filteredIncidents: filteredIncidents ?? this.filteredIncidents,
      activeSeverityFilter: activeSeverityFilter ?? this.activeSeverityFilter,
    );
  }

  @override
  List<Object?> get props => [allIncidents, filteredIncidents, activeSeverityFilter];
}

class IncidentsError extends IncidentsState {
  final String message;

  const IncidentsError(this.message);

  @override
  List<Object?> get props => [message];
}
