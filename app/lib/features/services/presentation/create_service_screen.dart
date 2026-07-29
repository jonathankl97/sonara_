import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/features/services/data/models/service_model.dart';
import 'package:sonara/features/services/presentation/service_provider.dart';
import 'package:sonara/features/services/data/enums/service_enums.dart';
import 'package:sonara/shared/enums/booking_mode.dart';
import 'widgets/add_ons_section.dart';
import 'widgets/booking_mode_section.dart';
import 'widgets/core_services_section.dart';
import 'widgets/pricing_section.dart';
import 'widgets/revision_section.dart';
import 'widgets/service_basic_info_section.dart';
import 'widgets/service_details_section.dart';
import 'widgets/service_genre_section.dart';

class CreateServiceScreen extends ConsumerStatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  ConsumerState<CreateServiceScreen> createState() =>
      _CreateServiceScreenState();
}

class _CreateServiceScreenState extends ConsumerState<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text-Controller
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _audioLengthController = TextEditingController();
  final _revisionCountController = TextEditingController();
  final _priceController = TextEditingController();

  // Dropdown-/Auswahl-State
  ServiceType _selectedServiceType = ServiceType.mixing;
  ServiceLocation _selectedLocation = ServiceLocation.remote;
  PriceModel _selectedPriceModel = PriceModel.fixed;
  BookingMode _selectedBookingMode = BookingMode.onRequest;

  // Listen
  List<String> _selectedGenres = [];
  final List<TextEditingController> _coreServiceControllers = [];
  final List<AddOnEntry> _addOnEntries = [];

  // Checkboxen
  bool _offersRevisions = false;
  bool _allowCustomRequests = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _audioLengthController.dispose();
    _revisionCountController.dispose();
    _priceController.dispose();
    for (final c in _coreServiceControllers) {
      c.dispose();
    }
    for (final e in _addOnEntries) {
      e.dispose();
    }
    super.dispose();
  }

  void _addCoreService() {
    setState(() => _coreServiceControllers.add(TextEditingController()));
  }

  void _removeCoreService(int index) {
    setState(() {
      _coreServiceControllers[index].dispose();
      _coreServiceControllers.removeAt(index);
    });
  }

  void _addAddOn() {
    setState(() => _addOnEntries.add(AddOnEntry()));
  }

  void _removeAddOn(int index) {
    setState(() {
      _addOnEntries[index].dispose();
      _addOnEntries.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Safety-Check: Wenn Revisionen angeboten werden, muss eine Anzahl da sein.
    if (_offersRevisions) {
      final count = int.tryParse(_revisionCountController.text.trim());
      if (count == null || count < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bitte eine gültige Anzahl an Revisionen eingeben'),
            backgroundColor: Color(0xFFFF453A),
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final service = ServiceModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        serviceType: _selectedServiceType,
        location: _selectedLocation,
        priceModel: _selectedPriceModel,
        bookingMode: _selectedBookingMode,
        audioLength: int.tryParse(_audioLengthController.text.trim()),
        basePrice: _selectedPriceModel != PriceModel.inquiry
            ? double.tryParse(_priceController.text.trim())
            : null,
        revisionsOffered: _offersRevisions,
        revisionCount: _offersRevisions
            ? int.tryParse(_revisionCountController.text.trim())
            : null,
        allowCustomRequests: _allowCustomRequests,
        genres: _selectedGenres,
        coreServices: _coreServiceControllers
            .map((c) => c.text.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        addOns: _addOnEntries
            .where((e) => e.titleController.text.trim().isNotEmpty)
            .map(
              (e) => ServiceAddOnModel(
                title: e.titleController.text.trim(),
                description: e.descriptionController.text.trim(),
                price: double.tryParse(e.priceController.text.trim()) ?? 0,
              ),
            )
            .toList(),
      );

      await ref.read(serviceNotifierProvider.notifier).createService(service);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service erfolgreich erstellt'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        context.pop();
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: const Color(0xFFFF453A),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 30);

    return Scaffold(
      appBar: AppBar(title: const Text('Neuen Service erstellen')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServiceBasicInfoSection(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                ),
                gap,
                ServiceDetailsSection(
                  selectedType: _selectedServiceType,
                  onTypeChanged: (v) =>
                      setState(() => _selectedServiceType = v!),
                  audioLengthController: _audioLengthController,
                  selectedLocation: _selectedLocation,
                  onLocationChanged: (v) =>
                      setState(() => _selectedLocation = v!),
                ),
                gap,
                ServiceGenresSection(
                  onChanged: (genres) => _selectedGenres = genres,
                ),
                gap,
                CoreServicesSection(
                  controllers: _coreServiceControllers,
                  onAdd: _addCoreService,
                  onRemove: _removeCoreService,
                ),
                gap,
                AddOnsSection(
                  entries: _addOnEntries,
                  onAdd: _addAddOn,
                  onRemove: _removeAddOn,
                ),
                gap,
                RevisionsSection(
                  offersRevisions: _offersRevisions,
                  onChanged: (v) => setState(() => _offersRevisions = v),
                  countController: _revisionCountController,
                ),
                gap,
                PricingSection(
                  selectedModel: _selectedPriceModel,
                  onModelChanged: (v) =>
                      setState(() => _selectedPriceModel = v!),
                  priceController: _priceController,
                  allowCustomRequests: _allowCustomRequests,
                  onCustomRequestsChanged: (v) =>
                      setState(() => _allowCustomRequests = v),
                ),
                gap,
                BookingModeSection(
                  selected: _selectedBookingMode,
                  onChanged: (v) =>
                      setState(() => _selectedBookingMode = v),
                ),
                gap,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 106, 0, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Service erstellen',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
