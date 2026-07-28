import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/profile/presentation/widgets/quick_action_button.dart';
import 'package:sonara/features/rooms/presentation/rooms_list.dart';
import 'package:sonara/features/services/presentation/service_list.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'package:sonara/features/profile/presentation/user_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Kein Benutzer gefunden'));
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Willkommen, ${user.displayName}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const SectionTitle('Schnelle Aktionen'),
                    const SizedBox(height: 10),
                    // Add your quick action buttons here
                    QuickActionButton(
                      buttonText: 'Neue Dienstleistung hinzufügen',
                      route: '/services/create',
                      icon: Icons.add,
                    ),
                    const SizedBox(height: 10),
                    QuickActionButton(
                      buttonText: 'Vermietung einrichten',
                      route: '/rooms/create',
                      icon: Icons.house,
                    ),
                    const SizedBox(height: 30),
                    ServiceList(),
                    const SizedBox(height: 30),
                    RoomsList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
