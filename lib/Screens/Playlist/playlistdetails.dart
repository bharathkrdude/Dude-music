import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dude_music/Screens/Playlist/add_more_songs_playlist.dart';
import 'package:dude_music/Screens/Playlist/play_pause_button.dart';
import 'package:dude_music/Screens/Playlist/playlist.dart';
import 'package:dude_music/style.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../db/model/dbfunctions.dart';
import '../../db/model/model.dart';
List<Songs> playSongs = [];
List<Songs> playlistslist = [];
List<Audio> playlistsongs = [];
AssetsAudioPlayer audioPlayerplaylist = AssetsAudioPlayer.withId('0');

class PlaylistDetails extends StatefulWidget {
  const PlaylistDetails(
      {super.key,
      required this.playlistName,
      required this.allPlaylistSongs,
      required this.index});
  final String playlistName;
  final List<Songs> allPlaylistSongs;
  final int index;

  @override
  State<PlaylistDetails> createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  
@override
  void initState() {
    setState(() {
      addPlaylistsFromdb(allplaylistsongs: widget.allPlaylistSongs);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SafeArea(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              topPlaylist(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddSongs(
                                index: widget.index,
                              )));
                    },
                    icon: const Icon(Icons.add_to_photos_outlined)),
              ),
            ],
          )),
          const SizedBox(
            height: 30,
          ),
          playlistBoxTwo(index: widget.index),
          const SizedBox(height: 20,),
          PlayPauseButton(playlistname: widget.playlistName, playlistindex: widget.index, allplaylistsongs: widget.allPlaylistSongs),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.play_circle_outline,
          //     color: Colors.red,
          //   ),
          //   iconSize: 36,
          // ),
          Expanded(
            child: ValueListenableBuilder(
                 valueListenable: playlistsBox.listenable(),
              builder: (context, Box<Playlists> playlist, child) {
                 List<Playlists> currPlaylist =
                          playlist.values.toList();
                      playSongs =
                          currPlaylist[widget.index].playlistsonglist;
                           if (playSongs.isEmpty) {
                    return Center(
                     child: Text("Hey add some songs..",style: songnametext,),
                    );
                  }
                return ListView.builder(itemBuilder: (context, index) {
                 
                  return ListTile(
                    onTap: () {
                      
                    },
                    leading: QueryArtworkWidget(
                      artworkHeight: 90,
                      artworkWidth: 60,
                      artworkBorder: BorderRadius.circular(15),
                      id: playSongs[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          "assets/IMAGES/DJ.png",
                          width: 60,
                        ),
                      ),
                    ),
                     textColor: Colors.white,
                      title: Text(playSongs[index].songname,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false),
                      subtitle: Text(
                        playSongs[index].artist,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,),
                        trailing: IconButton(onPressed: (){
                          setState(() {
                            playSongs.removeAt(index);
                           // playlistsBox.putAt(widget.index, Playlists(playlistname: widget.playlistName, playlistsonglist: songs));
                          });
                        }, icon: const Icon(Icons.remove,color: Colors.white,)),

                  );
                },
                itemCount: playSongs.length,
                
                );
              }, 
            ),
          )
        ],
      ),
    );
  }
}

Container playlistBoxTwo({required int index,}) {
  return Container(
     height:180,
    // width: 80,
    // color: Colors.yellow,
    
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "assets/IMAGES/playlistlogo.png",
            height: 140,
          ),
        ),
        const SizedBox(height: 10,),
        Text(listPlaylist[index].playlistname, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
addPlaylistsFromdb({required List<Songs> allplaylistsongs}) {
  playlistsongs.clear();
  for (var item in allplaylistsongs) {
    playlistsongs.add(Audio.file(item.songurl,
        metas: Metas(
          title: item.songname,
          artist: item.artist,
          id: item.id.toString(),
        )));
  }
}

