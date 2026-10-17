import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

/// Modern & Interactive Curved Navigation Bar for SIGAP SRE Suite
class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int activeIncidentsCount;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.activeIncidentsCount = 0,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavKey = GlobalKey();

  @override
  void didUpdateWidget(covariant CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _bottomNavKey.currentState?.setPage(widget.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: CurvedNavigationBar(
        key: _bottomNavKey,
        index: widget.currentIndex.clamp(0, 3),
        height: 62.0,
        items: <Widget>[
          _buildBarIcon(
            index: 0,
            icon: Icons.speed_rounded,
            tooltip: 'Dashboard',
          ),
          _buildBarIcon(
            index: 1,
            icon: Icons.dns_rounded,
            tooltip: 'Services',
          ),
          _buildBarIcon(
            index: 2,
            icon: Icons.warning_amber_rounded,
            tooltip: 'Incidents',
            badgeCount: widget.activeIncidentsCount,
          ),
          _buildBarIcon(
            index: 3,
            icon: Icons.verified_user_rounded,
            tooltip: 'Inspect',
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: AppColors.primary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 380),
        onTap: (index) {
          HapticFeedback.lightImpact();
          widget.onTap(index);
        },
      ),
    );
  }

  Widget _buildBarIcon({
    required int index,
    required IconData icon,
    required String tooltip,
    int? badgeCount,
  }) {
    final isSelected = widget.currentIndex == index;

    return Tooltip(
      message: tooltip,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 250),
            scale: isSelected ? 1.08 : 1.0,
            child: Icon(
              icon,
              size: isSelected ? 26 : 24,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEF4444) : AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.white,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 14),
                child: Text(
                  badgeCount > 9 ? '9+' : '$badgeCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
