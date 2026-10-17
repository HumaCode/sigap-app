import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigap_app/core/widgets/custom_app_bar.dart';
import 'package:sigap_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sigap_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:sigap_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sigap_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sigap_app/features/services/data/models/service_site_model.dart';
import 'package:sigap_app/features/services/presentation/cubit/services_cubit.dart';
import 'package:sigap_app/features/services/presentation/screens/services_screen.dart';
import 'package:sigap_app/features/services/presentation/screens/service_detail_screen.dart';
import 'package:sigap_app/features/incidents/presentation/cubit/incidents_cubit.dart';
import 'package:sigap_app/features/incidents/presentation/screens/incidents_screen.dart';
import 'package:sigap_app/features/navigation/presentation/widgets/custom_bottom_nav_bar.dart';

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
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showClusterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Cluster SRE',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.cloud_done, color: Colors.teal),
                title: const Text('prod-cluster-01 (Primary Production)'),
                subtitle: const Text('27 Services · Anycast Edge Active'),
                trailing: const Icon(Icons.check, color: Colors.teal),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.cloud_queue),
                title: const Text('staging-cluster-02 (Staging)'),
                subtitle: const Text('12 Services · Internal QA'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserActionMenu() {
    final authState = context.read<AuthCubit>().state;
    final userName = authState is Authenticated ? authState.user.name : 'SRE Operations Lead';
    final userEmail = authState is Authenticated ? authState.user.email : 'admin@sigap.id';
    final userRoles = authState is Authenticated ? authState.user.roles.join(', ') : 'admin';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(userName),
                subtitle: Text('$userEmail · Roles: $userRoles'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout dari Akun'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<AuthCubit>().logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onClusterTap: _showClusterBottomSheet,
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

          // Tab 3: Deep Inspection of Key Outage Service
          ServiceDetailScreen(service: ServiceSiteModel.sampleServices.first),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        activeIncidentsCount: 1,
      ),
    );
  }
}
