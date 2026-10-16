import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/service_site_entity.dart';
import '../../domain/repositories/services_repository.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository repository;

  ServicesCubit({required this.repository}) : super(ServicesInitial());

  Future<void> loadServices({String? initialFilter}) async {
    emit(ServicesLoading());
    try {
      final services = await repository.getServices();
      final filter = initialFilter ?? 'all';
      final filtered = _applyFilterAndSearch(services, filter, '');
      emit(ServicesLoaded(
        allServices: services,
        filteredServices: filtered,
        activeFilter: filter,
      ));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  void filterBy(String filter) {
    if (state is ServicesLoaded) {
      final current = state as ServicesLoaded;
      final filtered = _applyFilterAndSearch(current.allServices, filter, current.searchQuery);
      emit(current.copyWith(activeFilter: filter, filteredServices: filtered));
    }
  }

  void search(String query) {
    if (state is ServicesLoaded) {
      final current = state as ServicesLoaded;
      final filtered = _applyFilterAndSearch(current.allServices, current.activeFilter, query);
      emit(current.copyWith(searchQuery: query, filteredServices: filtered));
    }
  }

  Future<void> quickPing(int serviceId) async {
    await repository.triggerManualCheck(serviceId);
  }

  List<ServiceSiteEntity> _applyFilterAndSearch(
    List<ServiceSiteEntity> list,
    String filter,
    String query,
  ) {
    var result = list;

    // Apply Filter
    if (filter == 'operational') {
      result = result.where((s) => !s.isOutage).toList();
    } else if (filter == 'outage') {
      result = result.where((s) => s.isOutage).toList();
    } else if (filter == 'ssl') {
      result = result.where((s) => s.isSslWarning).toList();
    }

    // Apply Search
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result.where((s) => s.name.toLowerCase().contains(q) || s.domain.toLowerCase().contains(q)).toList();
    }

    return result;
  }
}
