import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

abstract class ForgeSoundPlayer {
  Future<void> playForgeSound();
  Future<void> playNewSessionSound();

  void dispose();
}

class DefaultForgeSoundPlayer implements ForgeSoundPlayer {
  AudioPlayer? _player;
  bool _disabled = false;

  @override
  Future<void> playForgeSound() async {
    await _playAsset('audio/parchment_forge.wav');
  }

  @override
  Future<void> playNewSessionSound() async {
    await _playAsset('audio/new_session.wav');
  }

  Future<void> _playAsset(String assetPath) async {
    if (_disabled) {
      return;
    }

    try {
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.play(AssetSource(assetPath));
    } catch (_) {
      // Audio failures should never block forging the parchment.
      _disabled = true;
    }
  }

  @override
  void dispose() {
    final player = _player;
    if (player == null) {
      return;
    }
    unawaited(player.dispose());
  }
}
