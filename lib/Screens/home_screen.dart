import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dude_music/Screens/main_player.dart';
import 'package:dude_music/Widgets/search.dart';
import 'package:dude_music/db/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/model/dbfunctions.dart';
import 'Playlist/add_to_playlist.dart';
import 'splash_screen.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

List<Audio> allSong = [];
bool isVisible = false;

class _ScreenHomeState extends State<ScreenHome> {
  List<Songs> songs = box.values.toList();
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var item in songs) {
      allSong.add(
        Audio.file(
          item.songurl,
          metas: Metas(
            artist: item.artist,
            title: item.songname,
            id: item.id.toString(),
          ),
        ),
      );
    }
  }

  final _audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
            topSearch(context),
            allSongs(),
             
            Visibility(
              visible: isVisible,
              child: miniPlayer(width))
          ],
        ),
      ),
    );
  }

   miniPlayer(double width) {
    return InkWell(
      onTap: () {
         Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Mainplayer()));
      },
      child: Container(
              height: 82,
              decoration: BoxDecoration(
                boxShadow: [
                  const BoxShadow(
                    color: Color.fromARGB(255, 91, 87, 2),
                    blurRadius: 1.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: Offset(
                      1.0, // Move to right 10  horizontally
                      1.0, // Move to bottom 10 Vertically
                    ),
                  ),
                  const BoxShadow(
                    color: Color.fromARGB(255, 82, 31, 93),
                    blurRadius: 1.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: Offset(
                      -1.0, // Move to right 10  horizontally
                      -1.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(243, 15, 15, 15),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  audioPlayer.builderCurrent(builder: (context, playing) {
                    return Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: QueryArtworkWidget(
                            // artworkHeight: 50,
                            // artworkWidth: 50,
                            artworkBorder: BorderRadius.circular(15),
                            id: int.parse(playing.audio.audio.metas.id!),
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Image.asset(
                              'assets/IMAGES/DJ.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: width - 130,
                                child: Text(
                                  audioPlayer.getCurrentAudioTitle.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                )),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.skip_previous_sharp),
                                  color: Colors.white,
                                  onPressed: () {
                                    audioPlayer.previous();
                                  },
                                  padding: EdgeInsets.zero,
                                  splashRadius: 18,
                                ),
                                PlayerBuilder.isPlaying(
                                    player: audioPlayer,
                                    builder: (context, isPlaying) {
                                      return IconButton(
                                        icon: Icon(isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                        color: Colors.blue,
                                        onPressed: () {
                                          audioPlayer.playOrPause();
                                      
                                        },
                                        padding: EdgeInsets.zero,
                                        splashRadius: 18,
                                      );
                                    }),
                                IconButton(
                                  icon: const Icon(Icons.skip_next_sharp),
                                  color: Colors.white,
                                  onPressed: () {
                                    audioPlayer.next();
                                    setState(() {});
                                  },
                                  padding: EdgeInsets.zero,
                                  splashRadius: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
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
                onTap: () {
                  songCount(songs[index], index);
                  setState(() {
                    isVisible = true;
                  });
                  audioPlayer.open(
                    Playlist(audios: allSong, startIndex: index),
                    loopMode: LoopMode.playlist,
                    showNotification: true,
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Mainplayer()));

                  RecentSongs Recents = RecentSongs(
                      songname: songs[index].songname,
                      artist: songs[index].artist,
                      duration: songs[index].duration.toString(),
                      songurl: songs[index].songurl,
                      id: songs[index].id.toString());
                  recentlyPlayedUupdation(Recents);
                },
                trailing: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.black,
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  title: const Text(
                                    'Add to favorites',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    List<Favsongs> favor =
                                        favdb.values.toList();
                                    if (favor
                                        .where((e) =>
                                            e.songname == songs[index].songname)
                                        .isEmpty) {
                                      favdb.add(
                                        Favsongs(
                                          artist: songs[index].artist,
                                          duration:
                                              songs[index].duration.toString(),
                                          songname: songs[index].songname,
                                          songurl: songs[index].songurl,
                                          id: songs[index].id.toString(),
                                          //index: widget.index,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  '${songs[index].songname} Added To Favorites')));
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '${songs[index].songname} Is already Added To Favorites')));

                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.playlist_add,
                                    color: Colors.lightBlue,
                                  ),
                                  title: const Text(
                                    'Add to playlist',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    playlistBottomSheet(context, index);
                                  },
                                ),
                              ],
                            );
                          }).then((value) => setState(() {}));
                    },
                    icon: const Icon(
                      Icons.more_vert_outlined,
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

Row topSearch(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset("assets/IMAGES/Dude Music.png"),
      IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Search()));
        },
        icon: const Icon(
          Icons.search,
          color: Colors.white,
          size: 32,
        ),
      ),
    ],
  );
}
