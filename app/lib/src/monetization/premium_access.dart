import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/fantasy_theme.dart';
import '../ui/pages/design/campaign_builder_atmosphere.dart';
import 'monetization_prefs.dart';

// ─────────────────────────────────────────────
// State
// ─────────────────────────────────────────────

/// Describes the current premium access level of the user.
enum PremiumAccessState {
  /// User purchased "Go Ad-Free" — permanent, unlimited access.
  adFree,

  /// User watched a rewarded ad — access is active for a limited window.
  temporaryActive,

  /// No access — user must watch an ad or purchase to unlock premium features.
  locked,
}

// ─────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────

/// Pure, stateless logic for managing premium feature access.
///
/// There are two ways to unlock premium features:
/// 1. One-time "Go Ad-Free" purchase → [PremiumAccessState.adFree]
/// 2. Watching a rewarded ad → [PremiumAccessState.temporaryActive] for
///    [temporaryUnlockDuration] (5 minutes).
///
/// Usage:
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// final state = PremiumAccessService.checkState(prefs, _monetizationPrefs);
/// if (state == PremiumAccessState.locked) { ... }
/// ```
class PremiumAccessService {
  const PremiumAccessService._();

  /// How long a rewarded-ad unlock remains active.
  static const Duration temporaryUnlockDuration = Duration(minutes: 5);

  /// Returns the current [PremiumAccessState] for the user.
  ///
  /// Checks ad-free purchase first, then active temporary unlock.
  static PremiumAccessState checkState(
    SharedPreferences prefs,
    MonetizationPrefs monetizationPrefs,
  ) {
    if (monetizationPrefs.isAdFreePurchased(prefs)) {
      return PremiumAccessState.adFree;
    }
    if (_isTemporaryUnlockActive(prefs, monetizationPrefs)) {
      return PremiumAccessState.temporaryActive;
    }
    return PremiumAccessState.locked;
  }

  /// Returns the remaining time left on a temporary unlock, or null if none.
  static Duration? remainingTemporaryTime(
    SharedPreferences prefs,
    MonetizationPrefs monetizationPrefs,
  ) {
    final epochMs = monetizationPrefs.getTemporaryUnlockTimestamp(prefs);
    if (epochMs == null) return null;

    final grantedAt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    final expiresAt = grantedAt.add(temporaryUnlockDuration);
    final remaining = expiresAt.difference(DateTime.now());

    return remaining.isNegative ? null : remaining;
  }

  /// Records the current timestamp as the start of a temporary unlock.
  ///
  /// Call this immediately after the user successfully watches a rewarded ad.
  static Future<void> grantTemporaryAccess(
    SharedPreferences prefs,
    MonetizationPrefs monetizationPrefs,
  ) async {
    await monetizationPrefs.setTemporaryUnlockTimestamp(
      prefs,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Clears the temporary unlock timestamp.
  ///
  /// Useful for testing or if you want to expire access early.
  static Future<void> revokeTemporaryAccess(
    SharedPreferences prefs,
    MonetizationPrefs monetizationPrefs,
  ) async {
    await monetizationPrefs.clearTemporaryUnlockTimestamp(prefs);
  }

  // ── Internal ──────────────────────────────

  static bool _isTemporaryUnlockActive(
    SharedPreferences prefs,
    MonetizationPrefs monetizationPrefs,
  ) {
    final epochMs = monetizationPrefs.getTemporaryUnlockTimestamp(prefs);
    if (epochMs == null) return false;

    final grantedAt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return DateTime.now().difference(grantedAt) < temporaryUnlockDuration;
  }
}

// ─────────────────────────────────────────────
// Crown Badge Widget
// ─────────────────────────────────────────────

/// A small crown icon that marks an element as a premium feature.
///
/// The crown colour follows the campaign-type atmosphere highlight, so it
/// always feels native to the current theme.
///
/// **Inline usage** (next to text / inside a chip):
/// ```dart
/// Row(children: [
///   Text('Premium option'),
///   const SizedBox(width: 4),
///   PremiumCrownBadge(highlightColor: atmosphere.highlight),
/// ])
/// ```
///
/// **Overlay usage** (top-right corner of a card):
/// ```dart
/// Stack(children: [
///   MyCard(),
///   Positioned(
///     top: 6, right: 6,
///     child: PremiumCrownBadge(highlightColor: atmosphere.highlight),
///   ),
/// ])
/// ```
///
/// Use [PremiumCrownBadge.fromAtmosphere] for convenience when you already
/// have a [CampaignAtmosphereData] at hand.
class PremiumCrownBadge extends StatelessWidget {
  const PremiumCrownBadge({
    super.key,
    required this.highlightColor,
    this.size = 16,
  });

  /// Convenience constructor — extracts [highlightColor] from the atmosphere.
  factory PremiumCrownBadge.fromAtmosphere(
    CampaignAtmosphereData atmosphere, {
    Key? key,
    double size = 16,
  }) {
    return PremiumCrownBadge(
      key: key,
      highlightColor: atmosphere.highlight,
      size: size,
    );
  }

  /// The colour of the crown icon — typically [CampaignAtmosphereData.highlight].
  final Color highlightColor;

  /// Icon size in logical pixels. Defaults to 16.
  final double size;

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      FontAwesomeIcons.crown,
      size: size,
      color: highlightColor,
    );
  }
}

// ─────────────────────────────────────────────
// Unlock Prompt Widget
// ─────────────────────────────────────────────

/// A full-bleed panel shown when the user tries to access a premium feature
/// without the necessary entitlement.
///
/// Presents two actions:
/// - **Watch Ad** — grants a [PremiumAccessService.temporaryUnlockDuration]
///   temporary unlock (caller is responsible for triggering the ad).
/// - **Go Ad-Free** — navigates to or opens the IAP purchase flow (caller
///   is responsible for initiating the purchase).
///
/// The [showAdOption] flag lets callers hide the ad button when ads are
/// unavailable (e.g. no network, ad not loaded yet).
///
/// Example — inside a bottom sheet:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (_) => PremiumUnlockPrompt(
///     highlightColor: atmosphere.highlight,
///     onWatchAd: () async {
///       Navigator.pop(context);
///       await _adService.show();
///       await PremiumAccessService.grantTemporaryAccess(prefs, monetizationPrefs);
///       setState(() {});
///     },
///     onGoAdFree: () {
///       Navigator.pop(context);
///       _coordinator.startAdFreePurchase();
///     },
///   ),
/// );
/// ```
class PremiumUnlockPrompt extends StatelessWidget {
  const PremiumUnlockPrompt({
    super.key,
    required this.highlightColor,
    this.onWatchAd,
    this.onGoAdFree,
    this.showAdOption = true,
  });

  /// Crown tint — typically [CampaignAtmosphereData.highlight].
  final Color highlightColor;

  /// Called when the user taps "Watch Ad (5 min)".
  ///
  /// The caller should show the ad and then call
  /// [PremiumAccessService.grantTemporaryAccess] on success.
  final VoidCallback? onWatchAd;

  /// Called when the user taps "Go Ad-Free".
  ///
  /// The caller should open the IAP purchase flow.
  final VoidCallback? onGoAdFree;

  /// Whether to show the "Watch Ad" button.
  ///
  /// Set to false when no ad is ready or available.
  final bool showAdOption;

  @override
  Widget build(BuildContext context) {
    final colors = context.fantasy;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: colors.outline.withValues(alpha: 0.4), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Crown icon
          FaIcon(
            FontAwesomeIcons.crown,
            size: 44,
            color: highlightColor,
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            'Premium Feature',
            style: textTheme.titleMedium?.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            showAdOption
                ? 'Watch a short ad to unlock this feature for 5 minutes,\n'
                    'or unlock Premium to access everything permanently.'
                : 'Unlock Premium to access this feature permanently.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.foregroundMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // "Watch Ad" primary button
          if (showAdOption) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onWatchAd,
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: const Text('Watch Ad (5 min)'),
                style: FilledButton.styleFrom(
                  backgroundColor: highlightColor,
                  foregroundColor: Colors.black.withValues(alpha: 0.87),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // "Unlock Premium" secondary button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onGoAdFree,
              icon: FaIcon(
                FontAwesomeIcons.crown,
                size: 14,
                color: highlightColor,
              ),
              label: Text(
                'Unlock Premium',
                style: textTheme.labelLarge?.copyWith(
                  color: highlightColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
