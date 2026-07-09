import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/profile/shared/section_title.dart';

class CreateServiceScreen extends ConsumerStatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  ConsumerState<CreateServiceScreen> createState() =>
      _CreateServiceScreenState();
}

class _CreateServiceScreenState extends ConsumerState<CreateServiceScreen> {
  late TextEditingController _serviceNameController;

  @override
  initState() {
    super.initState();
    _serviceNameController = TextEditingController();
  }

  @override
  dispose() {
    _serviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Neuen Service erstellen')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle('Basisinformationen'),
                SizedBox(height: 20),
                _buildLabel('Service-Titel*'),
                const SizedBox(height: 8),
                TextField(
                  controller: _serviceNameController,
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.styleFrom(elevation: 4, backgroundColor: Color.fromRGBO(255, 106, 0, 1), chi)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );
}
