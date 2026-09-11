import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_typography.dart';

/// Wordmark + search/add icons. Library screen only.
class LibraryTopBar extends StatelessWidget {
  const LibraryTopBar({super.key, this.onSearch, this.onAdd});

  final VoidCallback? onSearch;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('omowe', style: OmoweTypography.displayOnDevice(size: 26)),
        Row(
          children: [
            _ChromeIconButton(icon: Icons.search, onPressed: onSearch),
            const SizedBox(width: 4),
            _ChromeIconButton(icon: Icons.add, onPressed: onAdd),
          ],
        ),
      ],
    );
  }
}

class _ChromeIconButton extends StatelessWidget {
  const _ChromeIconButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      splashRadius: 24,
      icon: Icon(icon, size: 22, color: OmoweColors.ink900),
    );
  }
}
