import 'package:flutter/material.dart';
import 'package:sonara/features/profile/widgets/contact_row.dart';

class ContactSection extends StatelessWidget {
  final String? email;
  final String? location;
  const ContactSection({super.key, this.email, this.location});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactRow(
            icon: Icons.mail_outline_rounded,
            text: '$email',
            muted: email == null,
          ),
          const SizedBox(height: 8),
          ContactRow(
            icon: Icons.location_on,
            text: '$location',
            muted: location == null,
          ),
        ],
      ),
    );
  }
}
