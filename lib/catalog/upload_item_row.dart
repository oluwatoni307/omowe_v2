import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_typography.dart';
import 'thin_progress_bar.dart';

enum UploadState { transferring, processing, ready }

/// One "recently added" row on the upload screen.
class UploadItemRow extends StatelessWidget {
  const UploadItemRow({
    super.key,
    required this.title,
    required this.state,
    this.subtitle,
    this.progress,
  });

  final String title;
  final UploadState state;
  final String? subtitle;

  /// 0.0–1.0. Only meaningful when [state] is [UploadState.transferring].
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 2),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: OmoweColors.stone300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 41,
            decoration: BoxDecoration(
              color: OmoweColors.paper100,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: _Meta(
              title: title,
              state: state,
              subtitle: subtitle,
              progress: progress,
            ),
          ),
          const SizedBox(width: 8),
          _Trailing(state: state, progress: progress),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({
    required this.title,
    required this.state,
    this.subtitle,
    this.progress,
  });

  final String title;
  final UploadState state;
  final String? subtitle;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final titleStyle = state == UploadState.transferring
        ? OmoweTypography.uiBody.copyWith(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: OmoweColors.ink500,
          )
        : OmoweTypography.uiBody.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        if (state == UploadState.transferring && progress != null) ...[
          const SizedBox(height: 5),
          ThinProgressBar(value: progress!),
        ] else if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: OmoweTypography.uiMicro),
        ],
      ],
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.state, this.progress});

  final UploadState state;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case UploadState.transferring:
        return Text(
          '${((progress ?? 0) * 100).round()}%',
          style: OmoweTypography.uiMicro.copyWith(
            fontFeatures: OmoweTypography.tabularFigures,
          ),
        );
      case UploadState.processing:
        return const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: OmoweColors.sage400,
            backgroundColor: OmoweColors.stone300,
          ),
        );
      case UploadState.ready:
        return Container(
          width: 15,
          height: 15,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: OmoweColors.sage700,
          ),
          child: const Icon(Icons.check, size: 8, color: OmoweColors.stone50),
        );
    }
  }
}
