import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/shared/models/user_model.dart';
import 'package:sonara/features/auth/auth_notifier.dart';
import 'package:sonara/core/theme/app_theme.dart';

class ProfileDrawer extends ConsumerWidget {
  final UserModel user;
  const ProfileDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              border: Border(
                right: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color(0xFF1A1A1A),
                          backgroundImage: user.profileImageUrl != null
                              ? NetworkImage(user.profileImageUrl!)
                              : null,
                          child: user.profileImageUrl == null
                              ? Text(
                                  (user.displayName ?? user.email)[0]
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName ?? 'Kein Name',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0x66FFFFFF),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Einstellungen
                  _SectionLabel('Einstellungen'),
                  _DrawerItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Zahlungsmethoden',
                    onTap: () {},
                  ),
                  _DrawerItem(
                    icon: Icons.favorite_outline_rounded,
                    label: 'Favoriten',
                    onTap: () {},
                  ),
                  _DrawerItem(
                    icon: Icons.shield_outlined,
                    label: 'Sicherheit & Datenschutz',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1,
                  ),
                  const SizedBox(height: 8),

                  // Rolle
                  _DrawerItem(
                    icon: user.role == 'artist'
                        ? Icons.headphones_rounded
                        : Icons.mic_rounded,
                    label: user.role == 'artist'
                        ? 'Werde Provider'
                        : 'Wechsel zu Artist',
                    accent: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1,
                  ),
                  const SizedBox(height: 8),

                  // Support
                  _SectionLabel('Support'),
                  _DrawerItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Hilfe & FAQ',
                    onTap: () {},
                  ),
                  _DrawerItem(
                    icon: Icons.feedback_outlined,
                    label: 'Feedback senden',
                    onTap: () {},
                  ),

                  const Spacer(),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1,
                  ),

                  // Abmelden
                  _DrawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Abmelden',
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(authProvider.notifier).signOut();
                    },
                    destructive: true,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.27),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool accent;
  final bool destructive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.accent = false,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? const Color(0xFFFF453A)
        : accent
        ? kAccent
        : Colors.white;

    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    );
  }
}
