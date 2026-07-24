import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/auth_notifier.dart';
import '../../profile/presentation/user_provider.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF9142)),
        ),
      ),
      error: (e, _) => Scaffold(
        // ← FIX: nicht mehr const
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFFF453A),
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Etwas ist schiefgelaufen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: const TextStyle(
                    color: Color(0x66FFFFFF),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => ref.invalidate(userProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9142),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Erneut versuchen',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ref.read(authProvider.notifier).signOut(),
                  child: const Text(
                    'Abmelden',
                    style: TextStyle(color: Color(0x99FFFFFF), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (user) {
        if (user == null) return const SizedBox();
        final isProvider = user.role == 'provider';
        final tabs = isProvider ? _providerTabs : _artistTabs;
        final currentIndex = _currentIndex(context, isProvider);

        return Scaffold(
          backgroundColor: Colors.black,
          body: child,
          bottomNavigationBar: _BottomNav(
            tabs: tabs,
            currentIndex: currentIndex,
            onTap: (index) => context.go(tabs[index].path),
          ),
        );
      },
    );
  }

  int _currentIndex(BuildContext context, bool isProvider) {
    final location = GoRouterState.of(context).matchedLocation;
    final tabs = isProvider ? _providerTabs : _artistTabs;
    final index = tabs.indexWhere((t) => location.startsWith(t.path));
    return index < 0 ? 0 : index;
  }
}

class _TabItem {
  final String path;
  final String label;
  final IconData icon;

  const _TabItem({required this.path, required this.label, required this.icon});
}

const _artistTabs = [
  _TabItem(path: '/home', label: 'Suche', icon: Icons.search_rounded),
  _TabItem(
    path: '/bookings',
    label: 'Bookings',
    icon: Icons.calendar_month_rounded,
  ),
  _TabItem(path: '/chat', label: 'Chat', icon: Icons.message_rounded),
  _TabItem(path: '/profile', label: 'Profil', icon: Icons.person_rounded),
];

const _providerTabs = [
  _TabItem(
    path: '/dashboard',
    label: 'Dashboard',
    icon: Icons.trending_up_rounded,
  ),
  _TabItem(
    path: '/bookings',
    label: 'Bookings',
    icon: Icons.calendar_month_rounded,
  ),
  _TabItem(path: '/chat', label: 'Chat', icon: Icons.message),
  _TabItem(path: '/profile', label: 'Profil', icon: Icons.person_rounded),
];

class _BottomNav extends StatelessWidget {
  final List<_TabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        border: Border(top: BorderSide(color: Color(0x0FFFFFFF), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (i) {
          final tab = tabs[i];
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFFF9142).withValues(
                              alpha: 0.15,
                            ) // ← FIX: withOpacity → withValues
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Icon(
                      tab.icon,
                      color: isActive
                          ? const Color(0xFFFF9142)
                          : const Color(0x66FFFFFF),
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive
                          ? const Color(0xFFFF9142)
                          : const Color(0x66FFFFFF),
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
