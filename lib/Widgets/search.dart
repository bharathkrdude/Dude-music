import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dude_music/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../Screens/main_player.dart';
import '../db/model/dbfunctions.dart';
import '../db/model/model.dart';
import 'favouritebutton.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _searchController = TextEditingController();
  List<Songs> allDbSongs = Hive.box<Songs>('Songs').values.toList();
  late List<Songs> songsDisplay = List<Songs>.from(allDbSongs);
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId('0');
  void _searchSongs(String value) {
    setState(() {
      songsDisplay = allDbSongs
          .where((element) =>
              element.songname.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    songsDisplay = List.from(allDbSongs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset("assets/IMAGES/Dude Music.png"),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Search for songs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          searchField(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: songsDisplay.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          _audioPlayer.open(
                            Playlist(
                              audios: allSong,
                              startIndex: songs.indexWhere((e) =>
                                  e.songname == songsDisplay[index].songname),
                                
                            ),
                            showNotification: true,
                          );
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Mainplayer()));

                          RecentSongs Recents = RecentSongs(
                              songname: songsDisplay[index].songname,
                              artist: songsDisplay[index].artist,
                              duration: songsDisplay[index].duration.toString(),
                              songurl: songsDisplay[index].songurl,
                              id: songsDisplay[index].id.toString());
                          recentlyPlayedUupdation(Recents);
                        },
                        leading: QueryArtworkWidget(
                          artworkHeight: 90,
                          artworkWidth: 60,
                          artworkBorder: BorderRadius.circular(15),
                          id: songsDisplay[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset("assets/IMAGES/image 21.png",
                                height: 90, width: 60),
                          ),
                        ),
                        textColor: Colors.white,
                        title: Text(
                          songsDisplay[index].songname,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          songsDisplay[index].artist,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                    itemCount: songsDisplay.length,
                  )
                : const Center(
                    child: Text(
                      'No Songs found',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Container searchField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              hintText: 'What do you want to listen to?'),
          onChanged: (value) {
            _searchSongs(value);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    songsDisplay.clear();
    super.dispose();
  }
}
