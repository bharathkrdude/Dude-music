import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dude_music/Screens/home_screen.dart';
import 'package:dude_music/Screens/splash_screen.dart';
import 'package:dude_music/Widgets/favouritebutton.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'Playlist/add_to_playlist.dart';

bool isRepeat = false;
bool isPlaying = false;
bool isShuffle = false;

class Mainplayer extends StatefulWidget {
  const Mainplayer({super.key});

  @override
  State<Mainplayer> createState() => _MainplayerState();
}

class _MainplayerState extends State<Mainplayer> {
  bool isRepeat = false;
  bool isPlaying = false;
  bool isShuffle = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: audioPlayer.builderCurrent(builder: (context, playing) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                topSearch(context),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: width - 100,
                      width: width - 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: QueryArtworkWidget(
                            id: int.parse(playing.audio.audio.metas.id!),
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                              child: Image.asset(
                                'assets/IMAGES/song logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  audioPlayer.getCurrentAudioTitle,
                  style: const TextStyle(fontSize: 22),
                   overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        audioPlayer.getCurrentAudioArtist,
                        style: const TextStyle(fontSize: 16,color: Colors.grey),
                        overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: false,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {playlistBottomSheet(context, playing.index);},
                            icon: const Icon(
                              Icons.playlist_add,
                              color: Colors.white,
                            )),
                            Favbutton(index: songs.indexWhere((element) =>
                              element.songname ==
                              playing.audio.audio.metas.title)),
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: const Icon(
                        //       Icons.favorite_sharp,
                        //       color: Colors.white,
                        //     )),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                audioPlayer.builderCurrentPosition(
                    builder: (context, currentPosition) {
                  return Column(
                    children: [
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        thumbColor: Colors.white,
                        value: currentPosition.inSeconds.toDouble(),
                        min: 0.0,
                        max: playing.audio.duration.inSeconds.toDouble(),
                        onChanged: (value) async {
                          final newDuration = Duration(seconds: value.toInt());
                          await audioPlayer.seek(newDuration);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${currentPosition.toString().split(':')[1]}:${currentPosition.toString().split(':')[2].split('.')[0]}',style: TextStyle(color: Colors.grey),),
                            Text(
                                '${playing.audio.duration.toString().split(':')[1]}:${playing.audio.duration.toString().split(':')[2].split('.')[0]}',style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: isShuffle
                          ? const Icon(
                              Icons.shuffle_rounded,
                              color: Colors.blue,
                            )
                          : const Icon(Icons.shuffle_rounded),
                      color: Colors.white,
                      onPressed: () {
                        audioPlayer.toggleShuffle();
                        setState(() {
                          if (isShuffle == true) {
                            isShuffle = false;
                          } else {
                            isShuffle = true;
                          }
                        });
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                    ),
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
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
                            color: Colors.blue,
                            onPressed: () {
                              audioPlayer.playOrPause();
                              // setState(() {
                              //   if (isPlaying == false){
                              //     isPlaying = true;
                              //   } else{
                              //     isPlaying = false;
                              //   }
                              // });
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
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                    ),
                    IconButton(
                      icon: isRepeat == true
                          ? const Icon(
                              Icons.repeat_one_rounded,
                              color: Colors.blue,
                            )
                          : const Icon(Icons.repeat_outlined),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          if (isRepeat == false) {
                            isRepeat = true;
                            audioPlayer.setLoopMode(LoopMode.single);
                          } else {
                            isRepeat = false;
                            audioPlayer.setLoopMode(LoopMode.none);
                          }
                        });
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                    ),
                  ],
                ),

                const SizedBox(height: 40,),
                Center(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.expand_more_sharp,
                          color: Colors.white,
                        ))),
              ],
            );
          }),
        ),
      ),
    );
  }
}
