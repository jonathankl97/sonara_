import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/features/rooms/data/models/opening_hours_model.dart';
import 'package:sonara/features/rooms/data/models/room_equipment_model.dart';
import 'package:sonara/features/rooms/data/models/room_model.dart';
import 'package:sonara/features/rooms/presentation/room_provider.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_aminities_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_basic_info_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_booking_mode_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_equipment_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_image_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_location_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_opening_hours_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_pricing_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_size_section.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

class CreateRoomRentalScreen extends ConsumerStatefulWidget {
  const CreateRoomRentalScreen({super.key});

  @override
  ConsumerState<CreateRoomRentalScreen> createState() =>
      _CreateRoomRentalScreenState();
}

class _CreateRoomRentalScreenState
    extends ConsumerState<CreateRoomRentalScreen> {
  final _formKey = GlobalKey<FormState>();

  //Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _zipController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _sizeSqmController;
  late TextEditingController _capacityController;
  late TextEditingController _priceController;
  late TextEditingController _openFromController;
  late TextEditingController _openToController;

  // ── Dropdown-/Auswahl-State ──
  RoomType _selectedRoomType = RoomType.recordingStudio;
  RoomPriceModel _selectedPriceModel = RoomPriceModel.hourly;
  BookingMode _selectedBookingMode = BookingMode.onRequest;

  //Listen
  final List<EquipmentEntry> _selectedEquipmentEntries = [];
  List<String> _selectedAmenities = [];
  final List<String> _selectedImagePaths = [];
  List<String> _selectedDays = [];

  bool isLoading = false;

  // -Equipment-

  void _addEquipment() {
    setState(() {
      _selectedEquipmentEntries.add(EquipmentEntry());
    });
  }

  void _removeEntry(int index) {
    setState(() {
      _selectedEquipmentEntries[index].dispose();
      _selectedEquipmentEntries.removeAt(index);
    });
  }

  void _updateEquipmentCategory(int index, RoomEquipmentCategory category) {
    setState(() => _selectedEquipmentEntries[index].category = category);
  }

  // -Bilder-
  void _addImage(String path) {
    setState(() => _selectedImagePaths.add(path));
  }

  void _removeImage(int index) {
    setState(() => _selectedImagePaths.removeAt(index));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
    _stateController = TextEditingController();
    _zipController = TextEditingController();
    _sizeSqmController = TextEditingController();
    _capacityController = TextEditingController();
    _priceController = TextEditingController();
    _openToController = TextEditingController();
    _openFromController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _sizeSqmController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _openFromController.dispose();
    _openToController.dispose();
    for (final e in _selectedEquipmentEntries) {
      e.dispose();
    }
    super.dispose();
  }

  // -SUBMIT-

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Bilder sind Pflicht
    if (_selectedImagePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte mindestens ein Foto hinzufügen'),
          backgroundColor: Color(0xFFFF453A),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Oeffnungszeiten nur setzen wenn Daten vorhanden
      OpeningHoursModel? openingHours;
      final fromText = _openFromController.text.trim();
      final toText = _openToController.text.trim();
      if (_selectedDays.isNotEmpty &&
          fromText.isNotEmpty &&
          toText.isNotEmpty) {
        openingHours = OpeningHoursModel(
          days: _selectedDays,
          openFrom: fromText,
          openTo: toText,
        );
      }

      // RoomModel aus Formularfeldern zusammenbauen (ohne imageUrls)
      final room = RoomModel(
        name: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        roomType: _selectedRoomType,
        priceModel: _selectedPriceModel,
        bookingMode: _selectedBookingMode,
        basePrice: double.tryParse(_priceController.text.trim()) ?? 0,
        sizeSqm: int.tryParse(_sizeSqmController.text.trim()),
        capacity: int.tryParse(_capacityController.text.trim()),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        zip: _zipController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        amenities: _selectedAmenities,
        equipment: _selectedEquipmentEntries
            .where((e) => e.nameController.text.trim().isNotEmpty)
            .map(
              (e) => RoomEquipmentModel(
                category: e.category,
                name: e.nameController.text.trim(),
              ),
            )
            .toList(),
        imageUrls: [],
        openingHours: openingHours,
      );

      await ref
          .read(roomNotifierProvider.notifier)
          .createRoom(room: room, localImagePaths: _selectedImagePaths);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vermietung erfolgreich erstellt'),
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
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Fehler beim Hochladen'),
            backgroundColor: const Color(0xFFFF453A),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 30);
    return Scaffold(
      appBar: AppBar(title: Text('Vermietung einrichten')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  RoomBasicInfoSection(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    selectedRoomType: _selectedRoomType,
                    onTypeChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRoomType = value;
                        });
                      }
                    },
                  ),
                  gap,
                  RoomLocationSection(
                    addressController: _addressController,
                    cityController: _cityController,
                    zipController: _zipController,
                    stateController: _stateController,
                    countryController: _countryController,
                  ),
                  gap,
                  RoomEquipmentSection(
                    entries: _selectedEquipmentEntries,
                    onAdd: _addEquipment,
                    onRemove: _removeEntry,
                    onCategoryChanged: _updateEquipmentCategory,
                  ),
                  gap,
                  RoomAmenitiesSection(
                    selected: _selectedAmenities,
                    onChanged: (List<String> aminites) {
                      setState(() {
                        _selectedAmenities = aminites;
                      });
                    },
                  ),
                  gap,
                  RoomSizeSection(
                    sizeSqmController: _sizeSqmController,
                    capacityController: _capacityController,
                  ),
                  gap,
                  RoomPricingSection(
                    selectedModel: _selectedPriceModel,
                    onModelChanged: (RoomPriceModel? priceModel) {
                      if (priceModel != null) {
                        setState(() {
                          _selectedPriceModel = priceModel;
                        });
                      }
                    },
                    priceController: _priceController,
                  ),
                  gap,
                  RoomImageSection(
                    imagePaths: _selectedImagePaths,
                    onAdd: _addImage,
                    onRemove: _removeImage,
                  ),
                  gap,

                  RoomBookingModeSection(
                    selected: _selectedBookingMode,
                    onChanged: (v) => setState(() => _selectedBookingMode = v),
                  ),
                  gap,
                  if (_selectedBookingMode == BookingMode.weeklyAvailability)
                    RoomOpeningHoursSection(
                      selectedDays: _selectedDays,
                      onDaysChanged: (v) => setState(() => _selectedDays = v),
                      openFromController: _openFromController,
                      openToController: _openToController,
                    ),
                  gap,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 106, 0, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Vermietung starten',
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
      ),
    );
  }
}
