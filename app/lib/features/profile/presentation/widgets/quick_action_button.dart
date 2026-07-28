import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionButton extends StatelessWidget {
  final String buttonText;
  final String route;
  final IconData icon;
  const QuickActionButton({
    super.key,
    required this.buttonText,
    required this.route,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(route);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 12),
            Text(buttonText, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
