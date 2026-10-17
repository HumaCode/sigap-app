import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/incidents_repository.dart';
import 'incidents_state.dart';

class IncidentsCubit extends Cubit<IncidentsState> {
  final IncidentsRepository repository;
  Timer? _pollingTimer;

  IncidentsCubit({required this.repository}) : super(IncidentsInitial());

  Future<void> loadIncidents() async {
    emit(IncidentsLoading());
    try {
      final incidents = await repository.getIncidents();
      emit(IncidentsLoaded(
        allIncidents: incidents,
        filteredIncidents: incidents,
        activeSeverityFilter: 'all',
      ));
    } catch (e) {
      emit(IncidentsError(e.toString()));
    }
  }

  void startPolling({Duration interval = const Duration(seconds: 10)}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) => silentRefresh());
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> silentRefresh() async {
    try {
      final incidents = await repository.getIncidents();
      if (state is IncidentsLoaded) {
        final current = state as IncidentsLoaded;
        var filtered = incidents;

        if (current.activeSeverityFilter == 'critical') {
          filtered = filtered.where((i) => i.isCritical && !i.isResolved).toList();
        } else if (current.activeSeverityFilter == 'high') {
          filtered = filtered.where((i) => i.severity.contains('P2') && !i.isResolved).toList();
        } else if (current.activeSeverityFilter == 'resolved') {
          filtered = filtered.where((i) => i.isResolved).toList();
        }

        emit(current.copyWith(
          allIncidents: incidents,
          filteredIncidents: filtered,
        ));
      } else {
        emit(IncidentsLoaded(
          allIncidents: incidents,
          filteredIncidents: incidents,
          activeSeverityFilter: 'all',
        ));
      }
    } catch (_) {}
  }

  void filterBySeverity(String severity) {
    if (state is IncidentsLoaded) {
      final current = state as IncidentsLoaded;
      var filtered = current.allIncidents;

      if (severity == 'critical') {
        filtered = filtered.where((i) => i.isCritical && !i.isResolved).toList();
      } else if (severity == 'high') {
        filtered = filtered.where((i) => i.severity.contains('P2') && !i.isResolved).toList();
      } else if (severity == 'resolved') {
        filtered = filtered.where((i) => i.isResolved).toList();
      }

      emit(current.copyWith(
        activeSeverityFilter: severity,
        filteredIncidents: filtered,
      ));
    }
  }

  Future<void> updateIncidentStatus(int id, String newStatus) async {
    if (state is IncidentsLoaded) {
      final current = state as IncidentsLoaded;
      final updatedList = current.allIncidents.map((i) {
        if (i.id == id) {
          return i.copyWith(status: newStatus);
        }
        return i;
      }).toList();

      emit(current.copyWith(
        allIncidents: updatedList,
        filteredIncidents: updatedList,
      ));

      await repository.updateStatus(id, newStatus);
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
