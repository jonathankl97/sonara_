import 'package:flutter/material.dart';
import 'package:sonara/features/profile/shared/section_title.dart';
import 'package:sonara/shared/enums/service_enums.dart';
import 'form_helpers.dart';

const _serviceTypeLabels = {
  ServiceType.recording: 'Recording',
  ServiceType.mixing: 'Mixing',
  ServiceType.mastering: 'Mastering',
  ServiceType.production: 'Produktion',
  ServiceType.songwriting: 'Songwriting',
  ServiceType.toplining: 'Toplining',
  ServiceType.vocals: 'Gesang / Vocals',
  ServiceType.instrumentalist: 'Instrumentalist',
  ServiceType.arrangement: 'Arrangement',
  ServiceType.soundDesign: 'Sound Design',
  ServiceType.other: 'Sonstiges',
};

const _locationLabels = {
  ServiceLocation.remote: 'Remote',
  ServiceLocation.onsite: 'Vor Ort',
  ServiceLocation.hybrid: 'Hybrid',
};

class ServiceDetailsSection extends StatelessWidget {
  final ServiceType selectedType;
  final ValueChanged<ServiceType?> onTypeChanged;
  final TextEditingController audioLengthController;
  final ServiceLocation selectedLocation;
  final ValueChanged<ServiceLocation?> onLocationChanged;

  const ServiceDetailsSection({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.audioLengthController,
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Service Details'),
        const SizedBox(height: 20),
        const FormLabel('Servicetyp*'),
        const SizedBox(height: 8),
        FormDropdown<ServiceType>(
          value: selectedType,
          items: ServiceType.values,
          labels: _serviceTypeLabels,
          onChanged: onTypeChanged,
        ),
        const SizedBox(height: 20),
        const FormLabel('Typische Audiolänge (Minuten)'),
        const SizedBox(height: 8),
        FormTextField(
          controller: audioLengthController,
          hint: 'z.B. 5',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        const FormLabel('Ort*'),
        const SizedBox(height: 8),
        FormDropdown<ServiceLocation>(
          value: selectedLocation,
          items: ServiceLocation.values,
          labels: _locationLabels,
          onChanged: onLocationChanged,
        ),
      ],
    );
  }
}
