import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class PlayerPage extends StatefulWidget {
  final String songPath;
  final List<String> songList;
  final int initialIndex;
  final String imagePath;
  final Function(String) onFavoritePressed;

  const PlayerPage({
    Key? key,
    required this.songPath,
    required this.songList,
    required this.initialIndex,
    required this.imagePath,
    required this.onFavoritePressed, required List<String> favorites,
  }) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late AudioPlayer _audioPlayer;
  late int _currentSongIndex;
  double _volume = 0.8; // Volume range: 0.0 to 1.0
  bool _isPlaying = false;
  Duration _totalDuration = Duration();
  Duration _currentPosition = Duration();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentSongIndex = widget.initialIndex;
    _playSong(_currentSongIndex);
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration!;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSong(int index) async {
    try {
      final ByteData data = await rootBundle.load(widget.songList[index]);
      final buffer = data.buffer;
      final source = AudioSource.uri(Uri.dataFromBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ));
      await _audioPlayer.setAudioSource(source);
      _audioPlayer.setVolume(_volume); // Set the initial volume
      _audioPlayer.play();
      setState(() {
        _currentSongIndex = index;
        _isPlaying = true;
      });
    } catch (e) {
      print('Error loading audio source: $e');
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _stopSong() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _playNext() {
    if (_currentSongIndex < widget.songList.length - 1) {
      _playSong(_currentSongIndex + 1);
    }
  }

  void _playPrevious() {
    if (_currentSongIndex > 0) {
      _playSong(_currentSongIndex - 1);
    }
  }

  void _setVolume(double volume) {
    _audioPlayer.setVolume(volume);
    setState(() {
      _volume = volume;
    });
  }

  void _seekTo(double position) {
    final duration = _totalDuration * position;
    _audioPlayer.seek(duration);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (_isFavorite) {
      widget.onFavoritePressed(widget.songPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playing Now'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.imagePath,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
          Text(
            'Now Playing: ${widget.songList[_currentSongIndex].split('/').last}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _playPrevious,
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.white),
                onPressed: _stopSong,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _playNext,
              ),
            ],
          ),
          Slider(
            value: _currentPosition.inSeconds / _totalDuration.inSeconds,
            onChanged: _seekTo,
            activeColor: Colors.amber,
            label:
                '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Volume',
                style: TextStyle(color: Colors.white),
              ),
              Slider(
                value: _volume,
                onChanged: _setVolume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                activeColor: Colors.black,
                inactiveColor: Colors.black,
                label: (_volume * 100).round().toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
