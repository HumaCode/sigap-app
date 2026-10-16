import '../entities/incident_entity.dart';

abstract class IncidentsRepository {
  Future<List<IncidentEntity>> getIncidents();
  Future<IncidentEntity> getIncidentDetail(int id);
  Future<void> updateStatus(int id, String status);
  Future<void> addTechnicianNote(int id, String note);
}
