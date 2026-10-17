import '../../data/models/inspect_model.dart';
import '../entities/service_site_entity.dart';

abstract class ServicesRepository {
  Future<List<ServiceSiteEntity>> getServices();
  Future<ServiceSiteEntity> getServiceDetail(int id);
  Future<void> triggerManualCheck(int id);
  Future<InspectModel?> getInspectData({dynamic id});
}
