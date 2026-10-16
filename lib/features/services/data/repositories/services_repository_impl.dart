import '../../domain/entities/service_site_entity.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_remote_datasource.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remoteDataSource;

  ServicesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ServiceSiteEntity>> getServices() async {
    return await remoteDataSource.getServices();
  }

  @override
  Future<ServiceSiteEntity> getServiceDetail(int id) async {
    return await remoteDataSource.getServiceDetail(id);
  }

  @override
  Future<void> triggerManualCheck(int id) async {
    await remoteDataSource.triggerCheck(id);
  }
}
