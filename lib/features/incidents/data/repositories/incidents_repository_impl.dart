import '../../domain/entities/incident_entity.dart';
import '../../domain/repositories/incidents_repository.dart';
import '../datasources/incidents_remote_datasource.dart';

class IncidentsRepositoryImpl implements IncidentsRepository {
  final IncidentsRemoteDataSource remoteDataSource;

  IncidentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<IncidentEntity>> getIncidents() async {
    return await remoteDataSource.getIncidents();
  }

  @override
  Future<IncidentEntity> getIncidentDetail(int id) async {
    return await remoteDataSource.getIncidentDetail(id);
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    await remoteDataSource.updateStatus(id, status);
  }

  @override
  Future<void> addTechnicianNote(int id, String note) async {
    // Save locally or post note
  }
}
