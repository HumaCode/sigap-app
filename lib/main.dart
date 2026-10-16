import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart';
import 'core/storage/cache_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'features/incidents/data/datasources/incidents_remote_datasource.dart';
import 'features/incidents/data/repositories/incidents_repository_impl.dart';
import 'features/incidents/presentation/cubit/incidents_cubit.dart';
import 'features/navigation/presentation/screens/main_navigation_shell.dart';
import 'features/services/data/datasources/services_remote_datasource.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/presentation/cubit/services_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive offline cache
  await CacheService.init();

  // Core Storage & Networking
  final secureStorage = SecureStorageService();
  final apiClient = ApiClient(secureStorage: secureStorage);

  // Repositories
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(apiClient: apiClient),
    secureStorage: secureStorage,
  );

  final dashboardRepository = DashboardRepositoryImpl(
    remoteDataSource: DashboardRemoteDataSourceImpl(apiClient: apiClient),
  );

  final servicesRepository = ServicesRepositoryImpl(
    remoteDataSource: ServicesRemoteDataSourceImpl(apiClient: apiClient),
  );

  final incidentsRepository = IncidentsRepositoryImpl(
    remoteDataSource: IncidentsRemoteDataSourceImpl(apiClient: apiClient),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            authRepository: authRepository,
            secureStorage: secureStorage,
          )..checkAuthStatus(),
        ),
        BlocProvider<DashboardCubit>(
          create: (_) => DashboardCubit(repository: dashboardRepository),
        ),
        BlocProvider<ServicesCubit>(
          create: (_) => ServicesCubit(repository: servicesRepository),
        ),
        BlocProvider<IncidentsCubit>(
          create: (_) => IncidentsCubit(repository: incidentsRepository),
        ),
      ],
      child: const SigapApp(),
    ),
  );
}

class SigapApp extends StatelessWidget {
  const SigapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGAP SRE Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return const MainNavigationShell();
          }
          if (state is AuthInitial) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
