import 'package:flutter/material.dart';
import 'package:project1/player_page.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final List<String> _songs = [
    'assets/music/track1.mp3',
    'assets/music/track2.mp3',
    'assets/music/track3.mp3',
    'assets/music/track4.mp3',
    // Add more song paths here
  ];

  final List<String> _images = [
    'assets/image/pic1.jpg',
    'assets/image/pic1.jpg',
    'assets/image/pic1.jpg',
    'assets/image/pic1.jpg',
    // Add corresponding image paths here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Music Player'),
      ),
      body: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          final image = _images[index];
          return Card(
            color: Colors.blueGrey[300],
            child: ListTile(
              leading: Image.asset(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                song.split('/').last,
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerPage(
                      songPath: song,
                      songList: _songs,
                      initialIndex: index,
                      imagePath: image,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
