import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';

class ProfileStats extends StatelessWidget {
  final DateTime createdAt;
  final int ratingsCount;
  final double averageRating;

  const ProfileStats({
    super.key,
    required this.createdAt,
    required this.ratingsCount,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    final days = DateTime.now().difference(createdAt).inDays;

    final memberSince = days < 30 ? '$days Tage' : '${days ~/ 30} Monate';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              memberSince,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Mitglied seit',
              style: TextStyle(
                fontSize: 12,
                color: const Color.fromARGB(128, 255, 255, 255),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Icon(Icons.star_rounded, color: kAccent, size: 20),
                SizedBox(width: 4),
                Text(ratingsCount > 0 ? averageRating.toStringAsFixed(1) : '-', style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Rating',
              style: TextStyle(
                fontSize: 12,
                color: const Color.fromARGB(128, 255, 255, 255),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(ratingsCount.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            const SizedBox(height: 4),
            Text(
              'Bewertungen',
              style: TextStyle(
                fontSize: 12,
                color: const Color.fromARGB(128, 255, 255, 255),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
