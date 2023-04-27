import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dude_music/Screens/main_page.dart';
import 'package:dude_music/db/model/dbfunctions.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/model/model.dart';
bool playbuttonvisible = false;
class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

final box = SongBox.getInstance();
final _audioQuery = OnAudioQuery();
final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
List<SongModel> fetchallSongs = [];
List<SongModel> allsongs = [];
List<Audio> songsList = [];

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    openfavbox();
    openrecentbox();
    openplaylistdb();
  
    super.initState();
    requestStoragePremission();
    // print(box.values.toList());
    super.initState();
  }

  Timer goToHome() {
    return Timer(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const MainPage()),
      ),
    );
  }

  void requestStoragePremission() async {
    //Permission.storage.request();
    bool permissionStatus = await _audioQuery.permissionsStatus();
    // status = permissionStatus;
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
      goToHome();
      fetchallSongs = await _audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
      );

      for (var element in fetchallSongs) {
        if (element.fileExtension == "mp3") {
          allsongs.add(element);
        }
      }

      for (var element in allsongs) {
        box.add(Songs(
            songname: element.title,
            artist: element.artist!,
            duration: element.duration!,
            songurl: element.uri!,
            id: element.id,
            count: 0));
      }
    } else {
      fetchallSongs = await _audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
      );
      for (var element in fetchallSongs) {
        if (element.fileExtension == "mp3") {
          allsongs.add(element);
        }
      }
      if (allsongs.length != box.length) {
        box.clear();
        for (var element in allsongs) {
      await  box.add(Songs(
            songname: element.title,
            artist: element.artist!,
            duration: element.duration!,
            songurl: element.uri!,
            id: element.id,
            count: 0));
      }
      } 
      goToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(child: Image.asset("assets/IMAGES/mainlogo.png")));
  }
}
