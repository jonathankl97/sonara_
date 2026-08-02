import 'package:flutter/material.dart';

class DiscoverySectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onShowAll;

  const DiscoverySectionHeader({
    super.key,
    required this.title,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          if (onShowAll != null)
            GestureDetector(
              onTap: onShowAll,
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}
