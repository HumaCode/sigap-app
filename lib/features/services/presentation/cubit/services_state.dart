import 'package:equatable/equatable.dart';
import '../../domain/entities/service_site_entity.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceSiteEntity> allServices;
  final List<ServiceSiteEntity> filteredServices;
  final String activeFilter; // 'all', 'operational', 'outage', 'ssl'
  final String searchQuery;

  const ServicesLoaded({
    required this.allServices,
    required this.filteredServices,
    this.activeFilter = 'all',
    this.searchQuery = '',
  });

  ServicesLoaded copyWith({
    List<ServiceSiteEntity>? allServices,
    List<ServiceSiteEntity>? filteredServices,
    String? activeFilter,
    String? searchQuery,
  }) {
    return ServicesLoaded(
      allServices: allServices ?? this.allServices,
      filteredServices: filteredServices ?? this.filteredServices,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allServices, filteredServices, activeFilter, searchQuery];
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
}
