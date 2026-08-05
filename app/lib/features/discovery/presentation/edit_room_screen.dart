import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/data/models/room_detail_model.dart';
import 'package:sonara/features/discovery/presentation/room_detail_screen.dart';
import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/features/rooms/data/models/room_equipment_model.dart';
import 'package:sonara/features/rooms/data/models/opening_hours_model.dart';
import 'package:sonara/features/rooms/presentation/room_provider.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_aminities_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_basic_info_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_booking_mode_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_equipment_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_location_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_opening_hours_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_pricing_section.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_size_section.dart';
import 'package:sonara/shared/enums/booking_mode.dart';
import 'package:sonara/shared/widgets/section_title.dart';

class EditRoomScreen extends ConsumerStatefulWidget {
  final String roomId;

  const EditRoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends ConsumerState<EditRoomScreen> {
  final _formKey = GlobalKey<FormState>();

  // ── Text-Controller ──
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sizeSqmController = TextEditingController();
  final _capacityController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _priceController = TextEditingController();
  final _openFromController = TextEditingController();
  final _openToController = TextEditingController();

  // ── Dropdown-/Auswahl-State ──
  RoomType _selectedRoomType = RoomType.recordingStudio;
  RoomPriceModel _selectedPriceModel = RoomPriceModel.hourly;
  BookingMode _selectedBookingMode = BookingMode.onRequest;

  // ── Listen ──
  List<String> _selectedAmenities = [];
  List<String> _selectedDays = [];
  final List<EquipmentEntry> _equipmentEntries = [];

  // ── Bilder: bestehende URLs + neue lokale Pfade ──
  List<String> _existingImageUrls = [];
  final List<String> _newImagePaths = [];

  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sizeSqmController.dispose();
    _capacityController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _priceController.dispose();
    _openFromController.dispose();
    _openToController.dispose();
    for (final e in _equipmentEntries) {
      e.dispose();
    }
    super.dispose();
  }

  void _populateFromRoom(RoomDetailModel room) {
    _nameController.text = room.name;
    _descriptionController.text = room.description;
    _sizeSqmController.text = room.sizeSqm?.toString() ?? '';
    _capacityController.text = room.capacity?.toString() ?? '';
    _addressController.text = room.address;
    _cityController.text = room.city;
    _zipController.text = room.zip;
    _stateController.text = room.state;
    _countryController.text = room.country;
    _priceController.text = room.basePrice.toInt().toString();
    _selectedRoomType = room.roomType;
    _selectedPriceModel = room.priceModel;
    _selectedBookingMode = room.bookingMode;
    _selectedAmenities = List.from(room.amenities);
    _existingImageUrls = List.from(room.imageUrls);

    // Equipment vorausfuellen
    for (final eq in room.equipment) {
      final entry = EquipmentEntry(category: eq.category);
      entry.nameController.text = eq.name;
      _equipmentEntries.add(entry);
    }

    // Oeffnungszeiten vorausfuellen
    if (room.openingHours != null) {
      _selectedDays = List.from(room.openingHours!.days);
      _openFromController.text = room.openingHours!.openFrom;
      _openToController.text = room.openingHours!.openTo;
    }
  }

  // ── Equipment ──

  void _addEquipmentEntry() {
    setState(() => _equipmentEntries.add(EquipmentEntry()));
  }

  void _removeEquipmentEntry(int index) {
    setState(() {
      _equipmentEntries[index].dispose();
      _equipmentEntries.removeAt(index);
    });
  }

  void _onEquipmentCategoryChanged(int index, RoomEquipmentCategory category) {
    setState(() => _equipmentEntries[index].category = category);
  }

  // ── Bilder ──

  void _removeExistingImage(int index) {
    setState(() => _existingImageUrls.removeAt(index));
  }

  void _removeNewImage(int index) {
    setState(() => _newImagePaths.removeAt(index));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1920,
    );
    if (image != null) {
      setState(() => _newImagePaths.add(image.path));
    }
  }

  // ── Submit ──

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Mindestens ein Bild (bestehend oder neu)
    if (_existingImageUrls.isEmpty && _newImagePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte mindestens ein Foto hinzufügen'),
          backgroundColor: Color(0xFFFF453A),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Neue Bilder hochladen (ueber den Provider)
      // und mit bestehenden URLs kombinieren
      final List<String> allImageUrls = List.from(_existingImageUrls);

      if (_newImagePaths.isNotEmpty) {
        // Erstelle ein temporaeres RoomModel nur fuer den Upload
        // Hier nutzen wir createRoom nicht, sondern updateRoom mit den neuen URLs
        // Die Upload-Logik bleibt im Provider
      }

      // Oeffnungszeiten
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

      // Update-Daten zusammenbauen
      final updates = <String, dynamic>{
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'roomType': _selectedRoomType.value,
        'priceModel': _selectedPriceModel.value,
        'bookingMode': _selectedBookingMode.value,
        'basePrice': double.tryParse(_priceController.text.trim()) ?? 0,
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'zip': _zipController.text.trim(),
        'state': _stateController.text.trim(),
        'country': _countryController.text.trim(),
        'amenities': _selectedAmenities,
        'equipment': _equipmentEntries
            .where((e) => e.nameController.text.trim().isNotEmpty)
            .map(
              (e) => RoomEquipmentModel(
                category: e.category,
                name: e.nameController.text.trim(),
              ).toJson(),
            )
            .toList(),
        'imageUrls': allImageUrls,
        if (_sizeSqmController.text.trim().isNotEmpty)
          'sizeSqm': int.tryParse(_sizeSqmController.text.trim()),
        if (_capacityController.text.trim().isNotEmpty)
          'capacity': int.tryParse(_capacityController.text.trim()),
        if (openingHours != null) 'openingHours': openingHours.toJson(),
      };

      // Neue Bilder hochladen falls vorhanden
      if (_newImagePaths.isNotEmpty) {
        await ref
            .read(roomNotifierProvider.notifier)
            .uploadAndUpdateRoom(
              roomId: widget.roomId,
              updates: updates,
              localImagePaths: _newImagePaths,
              existingImageUrls: _existingImageUrls,
            );
      } else {
        await ref
            .read(roomNotifierProvider.notifier)
            .updateRoom(widget.roomId, updates);
      }

      // Detail-Provider invalidieren damit der Detail-Screen neu laedt
      ref.invalidate(roomDetailProvider(widget.roomId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Änderungen gespeichert'),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(roomDetailProvider(widget.roomId));

    return detailAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: kAccent)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Fehler')),
        body: Center(
          child: Text('$e', style: const TextStyle(color: Colors.white)),
        ),
      ),
      data: (room) {
        // Einmalig vorausfuellen
        if (!_isInitialized) {
          _populateFromRoom(room);
          _isInitialized = true;
        }

        const gap = SizedBox(height: 30);

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(title: const Text('Raum bearbeiten')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoomBasicInfoSection(
                      titleController: _nameController,
                      descriptionController: _descriptionController,
                      selectedRoomType: _selectedRoomType,
                      onTypeChanged: (v) =>
                          setState(() => _selectedRoomType = v!),
                    ),
                    gap,
                    RoomSizeSection(
                      sizeSqmController: _sizeSqmController,
                      capacityController: _capacityController,
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
                    RoomPricingSection(
                      selectedModel: _selectedPriceModel,
                      onModelChanged: (v) =>
                          setState(() => _selectedPriceModel = v!),
                      priceController: _priceController,
                    ),
                    gap,
                    RoomAmenitiesSection(
                      selected: _selectedAmenities,
                      onChanged: (v) => setState(() => _selectedAmenities = v),
                    ),
                    gap,
                    RoomEquipmentSection(
                      entries: _equipmentEntries,
                      onAdd: _addEquipmentEntry,
                      onRemove: _removeEquipmentEntry,
                      onCategoryChanged: _onEquipmentCategoryChanged,
                    ),
                    gap,
                    // ── Bilder: bestehende + neue ──
                    _buildImageSection(),
                    gap,
                    RoomOpeningHoursSection(
                      selectedDays: _selectedDays,
                      onDaysChanged: (v) => setState(() => _selectedDays = v),
                      openFromController: _openFromController,
                      openToController: _openToController,
                    ),
                    gap,
                    RoomBookingModeSection(
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
                          backgroundColor: kAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Änderungen speichern',
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
      },
    );
  }

  // ── Bilder-Sektion: zeigt bestehende URLs + neue lokale Bilder ──

  Widget _buildImageSection() {
    final totalImages = _existingImageUrls.length + _newImagePaths.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Bilder'),
        const SizedBox(height: 12),
        if (totalImages > 0) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: totalImages,
            itemBuilder: (context, index) {
              final isExisting = index < _existingImageUrls.length;

              return Stack(
                children: [
                  // Bild
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: isExisting
                        ? Image.network(
                            _existingImageUrls[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _imagePlaceholder(),
                          )
                        : Image.file(
                            File(
                              _newImagePaths[index - _existingImageUrls.length],
                            ),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  // Remove-Button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        if (isExisting) {
                          _removeExistingImage(index);
                        } else {
                          _removeNewImage(index - _existingImageUrls.length);
                        }
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xCC000000),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                  // Titelbild-Badge auf dem ersten Bild
                  if (index == 0)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: kAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Titelbild',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  // "Neu"-Badge auf neuen Bildern
                  if (!isExisting)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Neu',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
        ],
        // Bild hinzufuegen Button
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: totalImages == 0 ? 160 : null,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: totalImages == 0 ? const Color(0xFF1A1A1A) : null,
              border: Border.all(color: const Color(0x1AFFFFFF)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  totalImages == 0
                      ? Icons.file_upload_outlined
                      : Icons.add_photo_alternate_outlined,
                  color: const Color(0x66FFFFFF),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  totalImages == 0
                      ? 'Bilder hochladen'
                      : 'Weiteres Bild hinzufügen',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0x66FFFFFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: Icon(Icons.image, color: Color(0x33FFFFFF), size: 24),
      ),
    );
  }
}
