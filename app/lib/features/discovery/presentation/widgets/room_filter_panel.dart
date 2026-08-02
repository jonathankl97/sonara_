import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/presentation/providers/room_filter_state.dart';

const _roomTypeLabels = {
  'recordingStudio': 'Tonstudio',
  'rehearsalRoom': 'Proberaum',
  'productionSuite': 'Produktionsraum',
  'podcastStudio': 'Podcast Studio',
  'vocalBooth': 'Vocal Booth',
  'djBooth': 'DJ Booth',
  'other': 'Sonstiges',
};

const _amenityOptions = [
  'WIFI',
  'Parkplatz',
  'Küche',
  'Bad',
  'Klimaanlage',
  'Aufzug',
  'Barrierefreiheit',
  'Lounge',
  'Lagerraum',
];

class RoomFilterPanel extends ConsumerStatefulWidget {
  const RoomFilterPanel({super.key});

  @override
  ConsumerState<RoomFilterPanel> createState() => _RoomFilterPanelState();
}

class _RoomFilterPanelState extends ConsumerState<RoomFilterPanel> {
  late String? _selectedRoomType;
  late String _city;
  late RangeValues _priceRange;
  late int? _capacity;
  late List<String> _selectedAmenities;

  final _capacityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final current = ref.read(roomFilterProvider);
    _selectedRoomType = current.roomType;
    _city = current.city ?? '';
    _priceRange = RangeValues(current.minPrice ?? 10, current.maxPrice ?? 500);
    _capacity = current.capacity;
    _selectedAmenities = List.from(current.amenities);
    _capacityController.text = _capacity?.toString() ?? '';
  }

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  void _apply() {
    ref
        .read(roomFilterProvider.notifier)
        .update(
          RoomFilterState(
            roomType: _selectedRoomType,
            city: _city.isNotEmpty ? _city : null,
            minPrice: _priceRange.start > 10 ? _priceRange.start : null,
            maxPrice: _priceRange.end < 500 ? _priceRange.end : null,
            capacity: _capacity,
            amenities: _selectedAmenities,
          ),
        );
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _selectedRoomType = null;
      _city = '';
      _priceRange = const RangeValues(10, 500);
      _capacity = null;
      _capacityController.clear();
      _selectedAmenities = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF111111),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: _reset,
                      child: const Icon(
                        Icons.refresh,
                        color: Color(0x99FFFFFF),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Scrollbare Filter
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // ── Standort ──
                    _buildSectionLabel('Standort'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      value: _city,
                      hint: 'Berlin',
                      onChanged: (v) => _city = v,
                    ),
                    const SizedBox(height: 20),

                    // ── Preis ──
                    _buildSectionLabel('Preis'),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _priceRange,
                      min: 10,
                      max: 500,
                      divisions: 49,
                      activeColor: kAccent,
                      inactiveColor: const Color(0xFF2A2A2A),
                      labels: RangeLabels(
                        '${_priceRange.start.toInt()}€',
                        '${_priceRange.end.toInt()}€',
                      ),
                      onChanged: (v) => setState(() => _priceRange = v),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_priceRange.start.toInt()}€',
                            style: const TextStyle(
                              color: Color(0x99FFFFFF),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${_priceRange.start.toInt()}€ - ${_priceRange.end.toInt()}€',
                            style: const TextStyle(
                              color: Color(0x66FFFFFF),
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '${_priceRange.end.toInt()}€',
                            style: const TextStyle(
                              color: Color(0x99FFFFFF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Raumtyp ──
                    _buildSectionLabel('Raumtyp'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _roomTypeLabels.entries.map((entry) {
                        final isSelected = _selectedRoomType == entry.key;
                        return _buildChip(
                          label: entry.value,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedRoomType = isSelected ? null : entry.key;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // ── Kapazität ──
                    _buildSectionLabel('Mindestkapazität (Personen)'),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        controller: _capacityController,
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          _capacity = int.tryParse(v);
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'z.B. 3',
                          hintStyle: const TextStyle(color: Color(0x33FFFFFF)),
                          filled: true,
                          fillColor: const Color(0xFF1A1A1A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0x1AFFFFFF),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0x1AFFFFFF),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Ausstattung ──
                    _buildSectionLabel('Ausstattung'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _amenityOptions.map((amenity) {
                        final isSelected = _selectedAmenities.contains(amenity);
                        return _buildChip(
                          label: amenity,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedAmenities.remove(amenity);
                              } else {
                                _selectedAmenities.add(amenity);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              // ── Ergebnisse anzeigen ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Ergebnisse anzeigen',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField({
    required String value,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0x33FFFFFF)),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x1AFFFFFF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x1AFFFFFF)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? kAccent.withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? kAccent : const Color(0x33FFFFFF),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? kAccent : Colors.white,
          ),
        ),
      ),
    );
  }
}
