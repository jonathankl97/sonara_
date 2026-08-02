import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/presentation/providers/provider_filter_state.dart';

const _serviceTypeLabels = {
  'recording': 'Recording',
  'mixing': 'Mixing',
  'mastering': 'Mastering',
  'production': 'Beat Making',
  'soundDesign': 'Sound Design',
  'songwriting': 'Songwriting',
  'vocals': 'Vocals',
  'instrumentalist': 'Instrumentalist',
  'arrangement': 'Arrangement',
  'toplining': 'Toplining',
  'other': 'Sonstiges',
};

class ProviderFilterPanel extends ConsumerStatefulWidget {
  const ProviderFilterPanel({super.key});

  @override
  ConsumerState<ProviderFilterPanel> createState() =>
      _ProviderFilterPanelState();
}

class _ProviderFilterPanelState extends ConsumerState<ProviderFilterPanel> {
  late String? _selectedServiceType;
  late List<String> _selectedGenres;
  late String _city;
  late RangeValues _priceRange;
  late bool _remoteOnly;

  @override
  void initState() {
    super.initState();
    final current = ref.read(providerFilterProvider);
    _selectedServiceType = current.serviceType;
    _selectedGenres = List.from(current.genres);
    _city = current.city ?? '';
    _priceRange = RangeValues(current.minPrice ?? 50, current.maxPrice ?? 1000);
    _remoteOnly = current.remoteOnly;
  }

  void _apply() {
    ref
        .read(providerFilterProvider.notifier)
        .update(
          ProviderFilterState(
            serviceType: _selectedServiceType,
            genres: _selectedGenres,
            city: _city.isNotEmpty ? _city : null,
            minPrice: _priceRange.start > 50 ? _priceRange.start : null,
            maxPrice: _priceRange.end < 1000 ? _priceRange.end : null,
            remoteOnly: _remoteOnly,
          ),
        );
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _selectedServiceType = null;
      _selectedGenres = [];
      _city = '';
      _priceRange = const RangeValues(50, 1000);
      _remoteOnly = false;
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
                    // Standort
                    _buildSectionLabel('Standort'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      value: _city,
                      hint: 'Berlin',
                      onChanged: (v) => _city = v,
                    ),
                    const SizedBox(height: 8),
                    // Remote moeglich
                    Row(
                      children: [
                        Checkbox(
                          value: _remoteOnly,
                          activeColor: kAccent,
                          onChanged: (v) =>
                              setState(() => _remoteOnly = v ?? false),
                        ),
                        const Text(
                          'Remote möglich',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Preis
                    _buildSectionLabel('Preis'),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _priceRange,
                      min: 50,
                      max: 1000,
                      divisions: 19,
                      activeColor: kAccent,
                      inactiveColor: const Color(0xFF2A2A2A),
                      labels: RangeLabels(
                        '${_priceRange.start.toInt()}€',
                        '${_priceRange.end.toInt()}€',
                      ),
                      onChanged: (v) => setState(() => _priceRange = v),
                    ),
                    Row(
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
                          '${_priceRange.end.toInt()}€',
                          style: const TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Musikservices
                    _buildSectionLabel('Musikservices'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _serviceTypeLabels.entries.map((entry) {
                        final isSelected = _selectedServiceType == entry.key;
                        return _buildChip(
                          label: entry.value,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedServiceType = isSelected
                                  ? null
                                  : entry.key;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Musikgenres
                    _buildSectionLabel('Musikgenres'),
                    const SizedBox(height: 12),
                    // TODO: Genre-Dropdown/Chips wie im Mockup
                    // Vorerst als Info-Text
                    const Text(
                      'Genre-Filter kommt in einer zukünftigen Version.',
                      style: TextStyle(color: Color(0x66FFFFFF), fontSize: 13),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              // Ergebnisse anzeigen Button
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
