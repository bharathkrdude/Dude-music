import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dude_music/Screens/Playlist/playlist.dart';
import 'package:dude_music/Screens/Playlist/playlistdetails.dart';
import 'package:dude_music/Widgets/search.dart';
import 'package:dude_music/db/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../db/model/dbfunctions.dart';
import '../../style.dart';

class AddSongs extends StatefulWidget {
  const AddSongs({super.key, required this.index});
  final int index;

  @override
  State<AddSongs> createState() => _AddSongsState();
}

List<Audio> allSong = [];

class _AddSongsState extends State<AddSongs> {
  List<Songs> songs = SongBox.getInstance().values.toList();
  List<Playlists> psongs = playlistsBox.values.toList();
  final box = SongBox.getInstance();
  bool isAlreadyAdded = false;

  @override
  void initState() {
    List<Songs> dbSongs = box.values.toList();
    allSong.clear();
     super.initState();
  }

  final _audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            topAddPlaylistSongs(context,),
            allSongs(),
          ],
        ),
      ),
    );
  }

  Expanded allSongs() {
    return Expanded(
      flex: 1,
      child: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(orderType: OrderType.ASC_OR_SMALLER),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (item.data!.isEmpty) {
            return const Center(child: Text("No Songs Found"));
          }
          return ListView.builder(
            itemBuilder: ((context, index) {
              return ListTile(
                trailing: IconButton(
                    onPressed: () {
                      Playlists? currPlaylist =
                          playlistsBox.getAt(widget.index);
                      List<Songs> currPlaylistSongs =
                          currPlaylist!.playlistsonglist;
                      isAlreadyAdded = currPlaylistSongs.any((element) =>
                          element.songname == songs[index].songname);
                      if (!isAlreadyAdded) {
                        currPlaylistSongs.add(Songs(
                            songname: songs[index].songname,
                            artist: songs[index].artist,
                            duration: songs[index].duration,
                            songurl: songs[index].songurl,
                            id: songs[index].id,
                            count: songs[index].count));
                        
                        setState(() {
                                });
                                playlistsBox.putAt(
                                  widget.index,
                                  Playlists(
                                      playlistname: listPlaylist[widget.index]
                                          .playlistname,
                                      playlistsonglist: currPlaylistSongs),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.black,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                      '${songs[index].songname}Added to ${psongs[widget.index].playlistname}',
                                      style: songnametext,
                                    ),
                                  ),
                                );
                      }
                    },
                    icon: const Icon(
                      Icons.add_box_outlined,
                      color: Colors.white,
                    )),
                leading: QueryArtworkWidget(
                  artworkHeight: 90,
                  artworkWidth: 60,
                  artworkBorder: BorderRadius.circular(15),
                  id: songs[index].id,
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
                  songs[index].songname,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  songs[index].artist,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
            itemCount: songs.length,
          );
        },
      ),
    );
  }
}

Row topAddPlaylistSongs(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset("assets/IMAGES/Dude Music.png"),
      IconButton(
        onPressed: () {
          Navigator.of(context)
              .pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 32,
        ),
      ),
    ],
  );
}
