import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final String? profileImageUrl;
  final String? bio;
  const ProfileHeader({super.key, this.profileImageUrl, this.bio});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: widget.profileImageUrl != null
              ? NetworkImage(widget.profileImageUrl!)
              : null,
          child: widget.profileImageUrl == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),

        const SizedBox(height: 16),
        if (widget.bio != null) Text(widget.bio!),
      ],
    );
  }
}
