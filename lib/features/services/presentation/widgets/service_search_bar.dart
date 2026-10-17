import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ServiceSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String? hintText;

  const ServiceSearchBar({
    super.key,
    required this.onChanged,
    this.controller,
    this.hintText,
  });

  @override
  State<ServiceSearchBar> createState() => _ServiceSearchBarState();
}

class _ServiceSearchBarState extends State<ServiceSearchBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: AppTypography.bodyMd.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText ?? 'Cari situs atau endpoint...',
          hintStyle: AppTypography.bodyMd.copyWith(
            color: const Color(0xFF94A3B8),
            fontSize: 13.5,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 14, right: 10),
            child: Icon(
              Icons.search_rounded,
              size: 21,
              color: Color(0xFF64748B),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_hasText)
                  IconButton(
                    icon: const Icon(Icons.cancel_rounded, size: 18, color: Color(0xFF94A3B8)),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                    splashRadius: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                  ),
                  child: Text(
                    '⌘K',
                    style: AppTypography.labelXs.copyWith(
                      color: const Color(0xFF64748B),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: 40,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
