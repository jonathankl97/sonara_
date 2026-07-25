import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/services/presentation/service_provider.dart';
import 'package:sonara/features/services/presentation/widgets/service_card.dart';
import 'package:sonara/shared/widgets/section_title.dart';

class ServiceList extends ConsumerWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(serviceNotifierProvider);

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return const Text('Du hast noch keine Services erstellt.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('Meine Services'),
            const SizedBox(height: 30),
            // ListView.builder rendert nur die sichtbaren Elemente
            ListView.separated(
              shrinkWrap:
                  true, // Nötig, wenn die Column in einer ScrollView liegt
              physics:
                  const NeverScrollableScrollPhysics(), // Scrollen dem Parent überlassen
              itemCount: services.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceCard(service: service);
              },
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }
}
