import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';

class DiscoveryTabBar extends StatelessWidget {
  final TabController controller;

  const DiscoveryTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isRoomsTab = controller.index == 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
      ),
      child: TabBar(
        dividerColor: kAccent,
        controller: controller,
        indicatorColor: kAccent,
        indicatorWeight: 2,
        labelColor: kAccent,
        unselectedLabelColor: const Color(0x99FFFFFF),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.house_outlined,
              size: 22,
              color: isRoomsTab ? kAccent : const Color(0x99FFFFFF),
            ),
            text: 'Räume / Spaces',
          ),
          Tab(
            icon: Icon(
              Icons.equalizer,
              size: 22,
              color: !isRoomsTab ? kAccent : const Color(0x99FFFFFF),
            ),
            text: 'Services',
          ),
        ],
      ),
    );
  }
}
