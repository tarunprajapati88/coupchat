import 'package:coupchat/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class VoiceMessage extends StatefulWidget {
  final String audioUrl;

  const VoiceMessage({super.key, required this.audioUrl});

  @override
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void didUpdateWidget(covariant VoiceMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioUrl != widget.audioUrl) {
      _initializeAudio();
    }
  }

  Future<void> _initializeAudio() async {
    await _audioPlayer.setUrl(widget.audioUrl);
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration ?? Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data?.playing ?? false;
              final processingState = snapshot.data?.processingState;

              if (processingState == ProcessingState.completed) {
                _audioPlayer.seek(Duration.zero);
                _audioPlayer.pause();
              }

              return IconButton(
               color: Colors.grey,
                highlightColor: themeColors[1],
                icon: Icon(
                  color: Colors.black,
                  isPlaying && processingState != ProcessingState.completed
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                onPressed: _togglePlayback,
              );
            },
          ),
          Expanded(
            child: Column(
              children: [
                Slider(
                  inactiveColor:Colors.grey[400],
                  activeColor: themeColors[1],
                  min: 0,
                  max: _totalDuration.inSeconds.toDouble(),
                  value: _currentPosition.inSeconds
                      .toDouble()
                      .clamp(0, _totalDuration.inSeconds.toDouble()),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                  },
                ),
                Text(
                  "${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
