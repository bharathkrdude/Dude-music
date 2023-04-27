import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dude_music/Screens/home_screen.dart';
import 'package:dude_music/Screens/splash_screen.dart';
import 'package:dude_music/Widgets/favouritebutton.dart';
import 'package:dude_music/db/model/dbfunctions.dart';
import 'package:dude_music/db/model/model.dart';
import 'package:dude_music/style.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'main_player.dart';

class ScreenLibrary extends StatefulWidget {
  const ScreenLibrary({super.key});

  @override
  State<ScreenLibrary> createState() => _ScreenLibraryState();
}

// List<RecentSongs> recentsongs = [];
// List<Favsongs> allfavsongs = [];
// List<Audio> fullrecentsongs = [];
// List<Audio> favsongsPlaylist = [];
// List<Audio> mpSongs = [];
// List<Songs> songlist = box.values.toList();
// List<Songs> mostplayedSongs = [];
// final AssetsAudioPlayer audioPlayerRecents = AssetsAudioPlayer.withId('0');

class _ScreenLibraryState extends State<ScreenLibrary> {
  late List<RecentSongs> recentsongs = [];
  List<Favsongs> allfavsongs = [];
  List<Audio> fullrecentsongs = [];
  List<Audio> favsongsPlaylist = [];
  List<Audio> mpSongs = [];
  List<Songs> songlist = box.values.toList();
  List<Songs> mostplayedSongs = [];
  @override
  void initState() {
    super.initState();
  }

  final AssetsAudioPlayer audioPlayerRecents = AssetsAudioPlayer.withId('0');
  @override
  Widget build(BuildContext context) {
    fetchRecentsongs();
    recentsongs = recentdb.values.toList().reversed.toList();
    fetchFavSongs();
    fetchMostPlayedSongs();
    allfavsongs = favdb.values.toList();

    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: topSearch(context),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Recently played",
                    style: libraryHeadingText,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 120,
                  child: ValueListenableBuilder(
                      valueListenable: recentdb.listenable(),
                      builder:
                          (context, Box<RecentSongs> allrecentsongs, child) {
                        final recentsongs =
                            allrecentsongs.values.toList().reversed.toList();
                        if (recentsongs.isEmpty) {
                          return Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/IMAGES/Recentconcert.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 200,
                            child: const Center(
                              child: Text(
                                'No recent songs.....',
                                style: libraryText2,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            return Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print(fullrecentsongs);
                                      setState(() {});
                                      audioPlayerRecents.open(
                                        Playlist(
                                          audios: fullrecentsongs,
                                          startIndex: recentsongs.indexWhere(
                                              (e) =>
                                                  e.songname ==
                                                  recentsongs[index].songname),
                                        ),
                                        loopMode: LoopMode.playlist,
                                        showNotification: true,
                                      );
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Mainplayer()));

                                      RecentSongs Recents = RecentSongs(
                                          songname: recentsongs[index].songname,
                                          artist: recentsongs[index].artist,
                                          duration: recentsongs[index]
                                              .duration
                                              .toString(),
                                          songurl: recentsongs[index].songurl,
                                          id: recentsongs[index].id.toString());
                                      recentlyPlayedUupdation(Recents);
                                    },
                                    child: Column(
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        QueryArtworkWidget(
                                          artworkHeight: 100,
                                          artworkWidth: 100,
                                          artworkBorder:
                                              BorderRadius.circular(15),
                                          id: int.parse(recentsongs[index].id),
                                          type: ArtworkType.AUDIO,
                                          nullArtworkWidget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.asset(
                                                "assets/IMAGES/image 21.png",
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    recentsongs[index].songname,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    softWrap: false,
                                  )
                                ],
                              ),
                            );
                          }),
                          itemCount: recentsongs.length,
                        );
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Most Played",
                    style: libraryHeadingText,
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ValueListenableBuilder(
                      valueListenable: box.listenable(),
                      builder: ((context, Box<Songs> mpsongs, child) {
                        fetchMostPlayedSongs();
                        if (mostplayedSongs.isEmpty) {
                          print('mmmmmm${mostplayedSongs.length}');
                          return Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/IMAGES/concert-3084876_1920.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 200,
                            child: const Center(
                              child: Text(
                                'just play and come back dude..',
                                style: libraryText,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              return Container(
                                width: 100,
                                // height: 140,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Column(
                                  // textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        RecentSongs Recents = RecentSongs(
                                            songname:
                                                mostplayedSongs[index].songname,
                                            artist:
                                                mostplayedSongs[index].artist,
                                            duration: mostplayedSongs[index]
                                                .duration
                                                .toString(),
                                            songurl:
                                                mostplayedSongs[index].songurl,
                                            id: mostplayedSongs[index]
                                                .id
                                                .toString());
                                        recentlyPlayedUupdation(Recents);
                                        audioPlayerRecents.open(
                                          Playlist(
                                              audios: mpSongs,
                                              startIndex: index),
                                          headPhoneStrategy: HeadPhoneStrategy
                                              .pauseOnUnplugPlayOnPlug,
                                          showNotification: true,
                                        );

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Mainplayer()));
                                      },
                                      child: Column(
                                        children: [
                                          QueryArtworkWidget(
                                            artworkHeight: 100,
                                            artworkWidth: 100,
                                            artworkBorder:
                                                BorderRadius.circular(15),
                                            id: mostplayedSongs[index].id,
                                            type: ArtworkType.AUDIO,
                                            nullArtworkWidget: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.asset(
                                                  "assets/IMAGES/image 21.png",
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      mostplayedSongs[index].songname,
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                              );
                            }),
                            itemCount: mostplayedSongs.length,
                          );
                        }
                      })),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Favourites",
                    style: libraryHeadingText,
                  ),
                ),
                musicList()
              ],
            ),
          ),
        ));
  }

  Flexible musicList() {
    return Flexible(
        child: ValueListenableBuilder(
            valueListenable: Hive.box<Favsongs>('favsongs').listenable(),
            builder: (context, Box<Favsongs> allfavdbsongs, child) {
              final allfavsongs = allfavdbsongs.values.toList();
              if (favdb.isEmpty) {
                return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/IMAGES/drums.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 200,
                  child: const Center(
                    child: Text(
                      'No favourite Songs',
                      style: libraryText3,
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  return ListTile(
                    onTap: () {
                      songCount(songlist[index], index);
                      RecentSongs Recents = RecentSongs(
                          songname: allfavsongs[index].songname,
                          artist: allfavsongs[index].artist,
                          duration: allfavsongs[index].duration.toString(),
                          songurl: allfavsongs[index].songurl,
                          id: allfavsongs[index].id.toString());
                      recentlyPlayedUupdation(Recents);
                      setState(() {});
                      print('${Recents.songname}');
                      audioPlayerRecents.open(
                          Playlist(
                            audios: favsongsPlaylist,
                            startIndex: allfavsongs.indexWhere((e) =>
                                e.songname == allfavsongs[index].songname),
                          ),
                          loopMode: LoopMode.playlist,
                          showNotification: true);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Mainplayer()));
                    },
                    trailing: IconButton(
                        onPressed: () {
                         allfavsongs.removeAt(index); 
                         favdb.deleteAt(index);
                         favsongsPlaylist.removeAt(index);
                         
                        },
                        icon: const Icon(
                          Icons.favorite_sharp,
                          color: Colors.red,
                        )),
                    leading: QueryArtworkWidget(
                      artworkHeight: 90,
                      artworkWidth: 60,
                      artworkBorder: BorderRadius.circular(15),
                      id: int.parse(allfavsongs[index].id),
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
                    title: Text(allfavsongs[index].songname,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false),
                    subtitle: Text(
                      allfavsongs[index].artist,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  );
                }),
                itemCount: allfavsongs.length,
              );
            }));
  }

  fetchRecentsongs() {
    fullrecentsongs.clear();
    for (var item in recentsongs) {
      fullrecentsongs.add(Audio.file(item.songurl,
          metas: Metas(title: item.songname, id: item.id)));
    }
  }

  fetchFavSongs() {
    favsongsPlaylist.clear();
    for (var item in allfavsongs) {
      favsongsPlaylist.add(Audio.file(item.songurl,
          metas:
              Metas(title: item.songname, id: item.id, artist: item.artist)));
    }
  }

  fetchMostPlayedSongs() {
    mostplayedSongs.clear();
    for (var item in songlist) {
      print('hiiiiiii $item');
      int i = 0;
      if (item.count >= 5) {
        mostplayedSongs.insert(i, item);
        print(mostplayedSongs);
        i = i + 1;
      }
    }
    for (var items in mostplayedSongs) {
      mpSongs.add(Audio.file(items.songurl,
          metas: Metas(
              title: items.songname,
              artist: items.artist,
              id: items.id.toString())));
    }
    // setState(() {

    // });
  }
}




