import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/data/models/room_detail_model.dart';
import 'package:sonara/features/discovery/data/repositories/discovery_repository.dart';
import 'package:sonara/features/profile/presentation/user_provider.dart';
import 'widgets/room_detail/room_image_gallery.dart';
import 'widgets/room_detail/room_detail_header.dart';
import 'widgets/room_detail/room_price_card.dart';
import 'widgets/room_detail/room_detail_info.dart';
import 'widgets/room_detail/room_equipment_list.dart';
import 'widgets/room_detail/room_opening_hours_info.dart';
import 'widgets/room_detail/room_provider_info.dart';

final roomDetailProvider = FutureProvider.family<RoomDetailModel, String>((
  ref,
  id,
) async {
  final repository = ref.read(discoveryRepositoryProvider);
  return repository.fetchRoomDetail(id);
});

class RoomDetailScreen extends ConsumerStatefulWidget {
  final String roomId;

  const RoomDetailScreen({super.key, required this.roomId});

  @override
  ConsumerState<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends ConsumerState<RoomDetailScreen> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(roomDetailProvider(widget.roomId));
    final currentUserId = ref.watch(userProvider.select((u) => u.value?.id));

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: detailAsync.whenOrNull(
        data: (room) {
          if (room.provider.id != currentUserId) return null;
          return FloatingActionButton.extended(
            onPressed: () => context.push('/rooms/${room.id}/edit'),
            backgroundColor: kAccent,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              'Bearbeiten',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
      ),
      body: detailAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kAccent)),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFFF453A),
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    ref.invalidate(roomDetailProvider(widget.roomId)),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
        data: (room) => _buildContent(room),
      ),
    );
  }

  Widget _buildContent(RoomDetailModel room) {
    return CustomScrollView(
      slivers: [
        // ── Bild-Galerie mit Like-Button ──
        RoomImageGallery(
          imageUrls: room.imageUrls,
          isLiked: _isLiked,
          onLikeToggle: () => setState(() => _isLiked = !_isLiked),
        ),
        // ── Content ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                RoomDetailHeader(
                  name: room.name,
                  roomTypeLabel: room.roomTypeLabel,
                  bookingMode: room.bookingMode,
                  ratingAverage: room.ratingAverage,
                  ratingCount: room.ratingCount,
                  city: room.city,
                ),
                const SizedBox(height: 20),
                // Preis
                RoomPriceCard(priceLabel: room.priceLabel),
                const SizedBox(height: 24),
                // Beschreibung, Details, Standort, Ausstattung
                RoomDetailInfo(
                  description: room.description,
                  sizeSqm: room.sizeSqm,
                  capacity: room.capacity,
                  fullAddress: room.fullAddress,
                  amenities: room.amenities,
                ),
                const SizedBox(height: 24),
                // Equipment
                RoomEquipmentList(equipment: room.equipment),
                if (room.equipment.isNotEmpty) const SizedBox(height: 24),
                // Oeffnungszeiten
                if (room.openingHours != null) ...[
                  RoomOpeningHoursInfo(openingHours: room.openingHours!),
                  const SizedBox(height: 24),
                ],
                // Provider-Info
                RoomProviderInfo(
                  provider: room.provider,
                  onTap: () {
                    context.push('/providers/${room.provider.id}');
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
