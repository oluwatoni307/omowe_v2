import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_typography.dart';

enum ChapterState { read, current, unread }

/// One chapter list row.
class ChapterRow extends StatelessWidget {
  const ChapterRow({
    super.key,
    required this.number,
    required this.title,
    required this.state,
    this.onTap,
  });

  final int number;
  final String title;
  final ChapterState state;
  final VoidCallback? onTap;

  bool get _isCurrent => state == ChapterState.current;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: _isCurrent ? OmoweColors.sageWash : null,
        padding: EdgeInsets.symmetric(
          horizontal: _isCurrent ? 10 : 2,
          vertical: 12,
        ),
        decoration: _isCurrent
            ? null
            : const BoxDecoration(
                border: Border(top: BorderSide(color: OmoweColors.stone300)),
              ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              child: Text(
                number.toString().padLeft(2, '0'),
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: OmoweTypography.uiMicro.copyWith(
                  fontFeatures: OmoweTypography.tabularFigures,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OmoweTypography.uiBody.copyWith(
                  fontSize: 15,
                  color: state == ChapterState.read
                      ? OmoweColors.ink500
                      : OmoweColors.ink900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _Trailing(state: state),
          ],
        ),
      ),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.state});

  final ChapterState state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ChapterState.read:
        return const _DoneMark();
      case ChapterState.current:
        return Text(
          'reading',
          style: OmoweTypography.uiCaption.copyWith(
            color: OmoweColors.sage700,
            fontWeight: FontWeight.w500,
          ),
        );
      case ChapterState.unread:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: OmoweColors.stone300, width: 1.4),
          ),
        );
    }
  }
}

class _DoneMark extends StatelessWidget {
  const _DoneMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: OmoweColors.sage700,
      ),
      child: const Icon(Icons.check, size: 8, color: OmoweColors.stone50),
    );
  }
}
