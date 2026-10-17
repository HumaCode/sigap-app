import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigap_app/core/widgets/custom_app_bar.dart';
import 'package:sigap_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sigap_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:sigap_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sigap_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sigap_app/features/services/presentation/cubit/services_cubit.dart';
import 'package:sigap_app/features/services/presentation/screens/services_screen.dart';
import 'package:sigap_app/features/services/presentation/screens/inspect_screen.dart';
import 'package:sigap_app/features/incidents/presentation/cubit/incidents_cubit.dart';
import 'package:sigap_app/features/incidents/presentation/cubit/incidents_state.dart';
import 'package:sigap_app/features/incidents/presentation/screens/incidents_screen.dart';
import 'package:sigap_app/features/navigation/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:sigap_app/features/auth/domain/entities/user_entity.dart';
import 'package:sigap_app/features/profile/presentation/widgets/profile_settings_bottom_sheet.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load initial data for all features
    context.read<DashboardCubit>().loadDashboard();
    context.read<ServicesCubit>().loadServices();
    context.read<IncidentsCubit>().loadIncidents();
    // Real-time background sync without manual reload
    context.read<IncidentsCubit>().startPolling();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showUserActionMenu() {
    final authState = context.read<AuthCubit>().state;
    final user = authState is Authenticated
        ? authState.user
        : const UserEntity(
            id: '1',
            name: 'DEV',
            username: 'dev',
            email: 'dev@sigap.id',
            roles: ['dev'],
            permissions: ['view_dashboard', 'manage_services', 'manage_incidents', 'inspect_telemetry'],
          );

    ProfileSettingsBottomSheet.show(context, user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(
        onProfileTap: _showUserActionMenu,
        onNotificationTap: () => _onTabSelected(2),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 0: Dashboard
          DashboardScreen(
            onNavigateToIncidents: () => _onTabSelected(2),
            onNavigateToServices: (filter) {
              _onTabSelected(1);
              context.read<ServicesCubit>().filterBy(filter);
            },
          ),

          // Tab 1: Services Explorer
          const ServicesScreen(),

          // Tab 2: Incidents War Room
          const IncidentsScreen(),

          // Tab 3: Deep Service Telemetry Inspection
          InspectScreen(
            onNavigateToServices: () => _onTabSelected(1),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<IncidentsCubit, IncidentsState>(
        builder: (context, incidentsState) {
          int activeCount = 0;
          if (incidentsState is IncidentsLoaded) {
            activeCount = incidentsState.allIncidents
                .where((i) => !i.isResolved)
                .length;
          }
          return CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabSelected,
            activeIncidentsCount: activeCount,
          );
        },
      ),
    );
  }
}
