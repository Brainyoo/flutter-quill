import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Audio extends StatefulWidget {
  const Audio({
    required this.audioUrl,
    super.key,
  });

  final String audioUrl;

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  bool isPlaying = false;
  late AudioPlayer player = AudioPlayer();

  Source sourceByUrl(String audioUrl) {
    if (audioUrl.startsWith('http')) {
      return UrlSource(audioUrl);
    }
    if (audioUrl.startsWith('assets')) {
      return AssetSource(audioUrl);
    }

    return DeviceFileSource(audioUrl);
  }

  @override
  void initState() {
    super.initState();

    player.onPlayerStateChanged.listen((event) {
      if (mounted) {
        setState(() {
          switch (event) {
            case PlayerState.playing:
              isPlaying = true;
              break;
            default:
              isPlaying = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isPlaying
        ? IconButton(
            tooltip: 'Stop',
            onPressed: _stop,
            icon: const Icon(Icons.stop_circle_outlined),
          )
        : IconButton(
            tooltip: 'Play',
            onPressed: () => _play(context),
            icon: const Icon(Icons.play_circle_outline),
          );
  }

  Future<void> _play(BuildContext context) async {
    final source = sourceByUrl(widget.audioUrl);
    await player.play(source);
  }

  void _stop() {
    player.stop();
  }
}
