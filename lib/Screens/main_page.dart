import 'package:dude_music/Screens/home_screen.dart';
import 'package:dude_music/Screens/library.dart';
import 'package:dude_music/Screens/Playlist/playlist.dart';
import 'package:dude_music/Screens/Settings%20page/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
   int currentIndex=0;
   final screens=[
    const ScreenHome(),
    const ScreenLibrary(),
    const ScreenPlaylist(),
    const ScreenSettings(),
   ]; 
  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(
       const SystemUiOverlayStyle(
         statusBarColor: Colors.transparent
         //color set to transperent or set your own color
      )
  );
    return Scaffold(
      body:  IndexedStack(
        index: currentIndex,
        children: screens,
      ),
       bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) { setState(() =>currentIndex = index ,);},
        unselectedItemColor: Colors.white , 
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:const Color.fromARGB(255, 0, 0, 0) ,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.cyan,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.other_houses_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_motion_rounded),
            label: 'Library',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play_sharp),
            label: 'playlist',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          
        ],
      ),
    );
  }
}