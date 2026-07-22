import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/services/presentation/service_provider.dart';
import 'package:sonara/shared/widgets/section_title.dart';

class ServiceList extends ConsumerWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(serviceNotifierProvider);

    return servicesAsync.when(
      data: (services) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Meine Services'),
          ...services.map((service) => ListTile(title: Text(service.title))),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }
}
