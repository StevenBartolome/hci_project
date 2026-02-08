import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _clickPlayer = AudioPlayer();
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  bool _isMuted = false;
  bool _isBackgroundMusicPlaying = false;

  /// Get current mute status
  bool get isMuted => _isMuted;

  /// Get background music playing status
  bool get isBackgroundMusicPlaying => _isBackgroundMusicPlaying;

  /// Toggle mute for all sounds
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    if (_isMuted) {
      await _backgroundMusicPlayer.pause();
    } else {
      if (_isBackgroundMusicPlaying) {
        await _backgroundMusicPlayer.resume();
      }
    }
  }

  /// Play background music with loop
  Future<void> playBackgroundMusic() async {
    if (_isBackgroundMusicPlaying) return;

    try {
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.play(AssetSource('sounds/intro_sounds.mp3'));
      _isBackgroundMusicPlaying = true;

      if (_isMuted) {
        await _backgroundMusicPlayer.pause();
      }
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  /// Stop background music
  Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer.stop();
    _isBackgroundMusicPlaying = false;
  }

  /// Play click sound effect
  Future<void> playClick() async {
    if (_isMuted) return; // Don't play if muted

    try {
      await _clickPlayer.stop(); // Stop any previous click
      await _clickPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (e) {
      print('Error playing click sound: $e');
    }
  }

  /// Dispose audio players
  void dispose() {
    _clickPlayer.dispose();
    _backgroundMusicPlayer.dispose();
  }
}
